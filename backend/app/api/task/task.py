import asyncio
import json
import os
from typing import List

import pydub
from pydub.silence import split_on_silence
from celery import Celery, group
from loguru import logger
from app.api.conversation.conversation import update_conversation_socket
from app.api.message.message import add_message_socket
from app.db.database import get_db_session, get_redis_session_task

text = (f"Thanks to the high-quality feedback from Flutter users, in this release we have continued to improve the "
        f"performance of Impeller on iOS.")

# celery -A tasks worker --pool=eventlet --concurrency=500 --loglevel=info
# celery -A tasks worker --pool=gevent --concurrency=500 --loglevel=info

celery = Celery(broker=os.getenv("CELERY_BROKER", "redis://127.0.0.1:6379/0"),
                backend=os.getenv("CELERY_BACKEND", "redis://127.0.0.1:6379/0"))
celery.conf.timezone = 'Asia/Shanghai'
celery.conf.update(
    task_serializer='json',
    task_track_started=True,
    task_retry_policy={
        'max_retries': 3,
        'backoff_factor': 0.3,
        'max_doublings': 10,
    },
)


def test_stream():
    text_len = len(text)
    for i in range(text_len):
        yield text[i]


@celery.task()
def save_message_db_task(params: dict):
    logger.info(f"Request : {params}")

    async def save_message_db():
        # session = await anext(get_db_session())
        async for session in get_db_session():
            # session = await get_db_session_task()
            response = await add_message_socket(params, session)
            logger.info(f"Response : {response.status_code}")
            response_body = json.loads(response.body)
            logger.info(f"Response : {response_body}")
            if response_body['code'] == 0:
                save_message_redis_task.delay([response_body['data']], params)
            return response_body

    return asyncio.get_event_loop().run_until_complete(save_message_db())


@celery.task()
def save_message_redis_task(response_json: List[str], params: dict):
    logger.info(f"Request Params : {params}")
    logger.info(f"Request Data : {response_json}")

    async def save_message_redis():
        async for redis in get_redis_session_task():
            chat_key = f"chat:{params['conversation_id']}"
            logger.info(f"Chat Cache Key : {chat_key}")

            value_len = await redis.llen(chat_key)
            if value_len == 40:
                await redis.lpop(chat_key)
            push_result = await redis.rpush(chat_key, *response_json)
            await redis.expire(chat_key, 3600)
            logger.info(f"Redis RPush Count : {push_result}")

    return asyncio.get_event_loop().run_until_complete(save_message_redis())


@celery.task()
def update_conversation_db_task(params: dict):
    logger.info(f"Request Params : {params}")

    async def update_conversation_db():
        async for session in get_db_session():
            response = await update_conversation_socket(params, session)
            logger.info(f"Response : {response.status_code}")
            response_body = json.loads(response.body)
            logger.info(f"Response : {response_body}")
            return response_body

    return asyncio.get_event_loop().run_until_complete(update_conversation_db())


@celery.task()
def wav_trim_silence(file_path: str):
    audio = pydub.AudioSegment.from_file(file_path)
    chunks = split_on_silence(audio, min_silence_len=600, silence_thresh=-40, keep_silence=400)
    chunk_sum = audio[:1]
    for chunk in chunks:
        chunk_sum += chunk
    chunk_sum.export(file_path, format="wav")


# Add Message Task - Update Conversation SubTitle
group_db_conversation_message = group(save_message_db_task.s(), update_conversation_db_task.s())
