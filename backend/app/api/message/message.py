import json
from typing import List

from fastapi import APIRouter, Depends
from fastapi_pagination import Params
from fastapi_pagination.ext.async_sqlalchemy import paginate
from loguru import logger
from sqlalchemy import select, exc, delete
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.sql.operators import eq
from starlette.responses import Response

import app
from app import db
from app.db.database import get_db_session, get_redis_session_task
from app.db.models import Message
from app.db.schemas import MessageBase

message = APIRouter(
    tags=["Message"],
    responses={404: {"description": "404 Not Found"}}
)


@message.get("/api/llm/v1/message/list")
async def get_message_list(
        conversation_id: int,
        page: int = 1,
        size: int = 10,
        session: AsyncSession = Depends(get_db_session),
):
    if conversation_id is None:
        return Response(content=json.dumps({"code": -1, "msg": "Conversation id is null."}))
    query = select(Message).where(eq(Message.conversation_id, conversation_id))
    messages = await paginate(conn=session, query=query, params=Params(page=page, size=size))
    print(messages)
    return messages


async def get_message_list_db(
        session: AsyncSession,
        conversation_id: int,
        page: int = 1,
        size: int = 40,
):
    if conversation_id is None:
        return Response(content=json.dumps({"code": -1, "msg": "Conversation id is null."}))
    query = select(Message).where(eq(Message.conversation_id, conversation_id)).order_by(
        Message.id.desc()).limit(size)
    message_info = await session.execute(query)
    data = message_info.scalars().all()
    dict_data = [app.db.schemas.Message.from_orm(message).json() for message in data]
    dict_data.reverse()
    return dict_data


async def get_message_socket_one(
        conversation_id: int,
        session: AsyncSession = Depends(get_db_session),
):
    if conversation_id is None:
        return Response(content=json.dumps({"code": -1, "msg": "Conversation id is null."}))
    query = select(Message).where(eq(Message.conversation_id, conversation_id)).order_by(
        Message.id.desc()).limit(1)
    message_info = await session.execute(query)
    data = message_info.fetchone()
    dict_data = app.db.schemas.Message.from_orm(data).json()
    return dict_data


@message.post("/api/llm/v1/message/add")
async def add_message(
        params: db.schemas.MessageCreate,
        session: AsyncSession = Depends(get_db_session)
) -> Response:
    if params.conversation_id is None or len(params.content) == 0:
        return Response(content=json.dumps({"code": -1, "msg": "Message content is null."}))
    db_message = db.models.Message(content=params.content, conversation_id=params.conversation_id, role=params.role,
                                   image="", file="", audio="")
    try:
        session.add(db_message)
        await session.commit()
        await session.refresh(db_message)
        return Response(content=json.dumps({"code": 0, "msg": "Add message successfully."}))
    except exc.SQLAlchemyError as error:
        print(error)
        return Response(content=json.dumps({"code": -1, "msg": "Add message error."}))


async def add_message_socket(
        params: dict,
        session: AsyncSession
) -> Response:
    logger.info(f"Add Data Info : {params}")
    conversation_id = params["conversation_id"]
    data = params["message"]

    if conversation_id is None or len(data["input"]) == 0:
        return Response(content=json.dumps({"code": -1, "msg": "Message content is null."}))
    db_message = Message(content=data["input"], role=data["role"], conversation_id=conversation_id, image=data["image"],
                         file=data["file"],
                         audio=data["audio"])
    try:
        session.add(db_message)
        await session.commit()
        await session.refresh(db_message)
        return Response(content=json.dumps(
            {
                "code": 0,
                "msg": "Add message successfully.",
                "success": True,
                "data": app.db.schemas.Message.from_orm(db_message).json()
            }))
    except exc.SQLAlchemyError as error:
        print(error)
        return Response(content=json.dumps({"code": -1, "msg": f"Add message error = {error}"}))


async def get_message_socket(conversation_id: int) -> List[str]:
    async for redis in get_redis_session_task():
        chat_key = f"chat:{conversation_id}"
        logger.info(f"Chat Key : {chat_key}")
        cache_result = await redis.lrange(chat_key, -40, -1)
        logger.info(f"Redis Cache : {cache_result}")
        if len(cache_result) == 0:
            return []
        json_result = [json.loads(obj) for obj in cache_result]
        return json_result


@message.post("/api/llm/v1/message/delete")
async def delete_message(
        params: app.db.schemas.MessageDelete,
        session: AsyncSession = Depends(get_db_session)
) -> Response:
    if params.id is None:
        return Response(content=json.dumps({"code": -1, "msg": "Message id is null."}))
    try:
        # stmt = delete(Message).where(eq(Message.conversation_id, params.id))
        stmt = delete(Message).where(eq(Message.id, params.id))
        await session.execute(stmt)
        await session.commit()
        return Response(content=json.dumps({"code": 0, "msg": "Delete message successfully."}))
    except exc.SQLAlchemyError as error:
        print(error)
        return Response(content=json.dumps({"code": 0, "msg": "Delete message error."}))
