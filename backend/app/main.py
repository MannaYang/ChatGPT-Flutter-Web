import asyncio
import json
from contextlib import asynccontextmanager

import uvicorn
from fastapi import FastAPI, Request, HTTPException, Depends
from loguru import logger
from sqlalchemy.ext.asyncio import AsyncSession
from starlette import status
from starlette.middleware.cors import CORSMiddleware
from starlette.responses import Response
from starlette.staticfiles import StaticFiles
from starlette.websockets import WebSocket, WebSocketDisconnect

from app.api.agent import conversation_chain
from app.api.agent.agent import retrieval_agent, chain_invoke
from app.api.attach.attach import attach, generate_image, edit_image, generate_audio, \
    transcription_audio
from app.api.auth.auth import auth, get_request_token, check_access_token, get_query_token, authenticate_token
from app.api.conversation.conversation import conversation
from app.api.message.message import message, get_message_socket, get_message_list_db
from app.api.prompt.prompt import promptTemplate, get_audio_transcription_prompt
from app.api.task.task import save_message_db_task, group_db_conversation_message, save_message_redis_task
from app.db.database import engine, Base, get_db_session
from app.db.schemas import ResponseModel


@asynccontextmanager
async def lifespan(start_app: FastAPI):
    logger.info(f"Initializing the database...{start_app.routes}")
    async with engine.begin() as conn:
        # await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
        logger.info("The database and tables have been initialized successfully.")
    yield


app = FastAPI(lifespan=lifespan)
app.mount("/attach", StaticFiles(directory="app/attach"), name="attach")
app.add_middleware(
    CORSMiddleware,
    # When deploying to production, make sure to set `allow_origins=["Host url"]`,not `allow_origins=["*"]`
    # allow_origins=["http://localhost:60652", "http://127.0.0.1:8000"],
    allow_origins=["*"],
    # Very Important!
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"]
)
app.include_router(auth)
app.include_router(conversation)
app.include_router(message)
app.include_router(promptTemplate)
app.include_router(attach)


# Do not use Exception, it can not be caught. Unless you use this:
# ```
# raise Exception()
# ```
#
@app.exception_handler(HTTPException)
async def http_exception_handler(request, exception):
    logger.info(f"Request: {request.method} {request.url}")
    headers = {"Access-Control-Allow-Origin": "*"}
    data = ResponseModel(code=exception.status_code, msg=exception.detail)
    return Response(content=data.json(), headers=headers)


# This method has been deprecated, please use lifespan()
# @app.on_event("startup")
# async def startup_event():
#     async with engine.begin() as conn:
#         # await conn.run_sync(Base.metadata.drop_all)
#         await conn.run_sync(Base.metadata.create_all)
#         logger.info("The database and tables have been initialized successfully.")


@app.middleware("http")
async def check_authentication(request: Request, call_next):
    logger.info(f"RequestParams: {request.method} {request.url}")
    white_list = ["signin", "docs", "openapi", "chat"]
    # When the request method is OPTIONS, it will be continued
    if request.method == "OPTIONS":
        return await call_next(request)
    match request.url.path:
        case url_str if (any(url in url_str for url in white_list)
                         or request.url.port == 6379):
            return await call_next(request)
        case url_str if "attach/audio" in url_str:
            access_token: str = await get_query_token(request)
        case _:
            access_token: str = await get_request_token(request)
    check_user = await check_access_token(access_token)
    if len(check_user) == 0:
        raise HTTPException(401, "Token not exist or expired.")
    return await call_next(request)


@app.websocket("/chat/receive")
async def websocket_chat_receive(
        ws: WebSocket,
        token: str = Depends(authenticate_token),
        session: AsyncSession = Depends(get_db_session)
):
    if token is None:
        await ws.close(code=status.WS_1008_POLICY_VIOLATION, reason="Your token is invalid.")
        return
    try:
        await ws.accept()
        while True:
            logger.info(f"Receive message token : {token}")
            data = await ws.receive_json()
            logger.info(f"Receive message info : {data}")
            if data["message"] is None:
                # select redis cache
                json_result = await get_message_socket(data["conversationId"])
                # redis cache empty
                logger.info(
                    f"Websocket : ws.url={ws.url} ,ws.headers = {ws.headers} "
                    f", {ws.client.host} , {ws.client.port}")
                if len(json_result) == 0:
                    # select db
                    json_source = await get_message_list_db(session, data["conversationId"])
                    json_result = [json.loads(result) for result in json_source]
                    # sync redis cache
                    if json_source:
                        save_message_redis_task.apply_async(
                            args=[json_source, {"conversation_id": data["conversationId"]}])
                await ws.send_json(data={"code": 0, "msg": "Success", "success": True, "data": json_result})
                continue
            input_str = data["message"]["input"]
            image_str = data["message"]["image"]
            audio_str = data["message"]["audio"]
            temp_image = "\n\n" + image_str if len(image_str) > 1 else ""
            temp_audio = "\n\n" + audio_str if len(audio_str) > 1 else ""
            data["message"]["input"] = f"{input_str}{temp_image}{temp_audio}"
            user_message = {
                "conversation_id": data["conversationId"],
                "message": data["message"]
            }
            # result = group_db_redis.apply_async((user_message,))
            result = save_message_db_task.apply_async(args=[user_message])
            result_data = result.get()
            logger.info(f"Celery task executed result : {result_data['msg']}")
            if result_data["code"] == 0:
                logger.info(
                    f"Websocket : ws.url={ws.url} ,ws.headers = {ws.headers} "
                    f", {ws.client.host} , {ws.client.port}")
                data = [json.loads(result_data["data"])]
                await ws.send_json(data={"code": 0, "msg": "Success", "success": True, "data": data})
    except WebSocketDisconnect as wsd:
        logger.info(f"WebSocket disconnect :{wsd.args}")
        await ws.close()
    except RuntimeError as re:
        logger.info(f"WebSocket runtimeError :{re.args}")


@app.websocket("/chat/send")
async def websocket_chat_send(ws: WebSocket, token: str = Depends(authenticate_token)):
    if token is None:
        await ws.close(code=status.WS_1008_POLICY_VIOLATION, reason="Your token is invalid.")
        return
    try:
        await ws.accept()
        while True:
            logger.info(f"Receive message token : {token}")
            data = await ws.receive_json()
            logger.info(f"Receive message info :{data}")
            messages = data["message"]
            input_str: str = messages["input"]
            image = ""
            if len(messages["image"]) == 1:
                image = await generate_image(input_str, ws.headers['host'])
                logger.info(f"Image to image : {image}")
            if len(messages["image"]) > 1:
                image = await edit_image(messages["image"], input_str, ws.headers['host'])
                logger.info(f"Image to image : {image}")
            file = ""
            if len(messages["file"]) >= 1:
                file = await retrieval_agent(input_str, messages["file"])
            audio = ""
            if len(messages["audio"]) == 1:
                audio = await generate_audio(input_str, ws.headers['host'])
            if len(messages["audio"]) > 1:
                audio = await transcription_audio(messages["audio"], input_str)
            if len(messages["image"]) >= 1 or len(messages["audio"]) == 1 or len(messages["file"]) == 1:
                input_data = f"{image} {audio} {file}"
                chat_response = input_data
            elif len(messages["audio"]) > 1:
                input_data = get_audio_transcription_prompt(audio)
                chat_response = await conversation_chain.apredict(input=input_data)
            elif len(data["rolePlay"]) != 0:
                input_data = f"{input_str}"
                chat_response = await chain_invoke(input_data, data["conversationId"], data["rolePlay"])
            else:
                input_data = f"{input_str}"
                chat_response = await conversation_chain.apredict(input=input_data)
            # chat_response = test_stream()
            result = ""
            # for text in chat_response:
            #     result += text
            #     await ws.send_text(result)
            #     await asyncio.sleep(0.016)
            for text in chat_response:
                result += text
                if len(text) == 0:
                    continue
                await ws.send_text(result)
                await asyncio.sleep(0.016)
            # cache content
            data["message"]["input"] = result
            system_message = {
                "conversation_id": data["conversationId"],
                "message": data["message"],
                "sub_title": result[:36],
            }
            # cache conversation-subTitle , message db
            group_result = group_db_conversation_message.apply_async((system_message,))
            result_data = group_result.get()
            message_result = result_data[0]
            logger.info(f"Celery task executed result : {message_result['msg']}")
            if message_result["code"] == 0:
                data = [json.loads(message_result["data"])]
                await ws.send_json(data={"code": 0, "msg": "Success", "success": True, "data": data})
    except WebSocketDisconnect as wsd:
        logger.info(f"WebSocket disconnect :{wsd.args}")
        await ws.close()
    except RuntimeError as re:
        logger.info(f"WebSocket runtimeError :{re.args}")
        await ws.send_text(f"{re.args}")
    except Exception as re:
        logger.info(f"WebSocket exception :{re.args}")
        await ws.send_text(f"{re.args}")


if __name__ == "__main__":
    uvicorn.run(app='main:app', host="127.0.0.1", port=8000, reload=True)
