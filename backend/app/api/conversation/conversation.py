import json

from redis.asyncio import Redis
from fastapi import APIRouter, Depends, Request
from fastapi_pagination import Params
from fastapi_pagination.ext.sqlalchemy import paginate
from loguru import logger
from sqlalchemy import select, exc, delete
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.sql.operators import eq
from starlette.responses import Response

import app
from app.api.auth.auth import get_request_token, get_cache_user_id
from app.db.database import get_redis_session, get_db_session
from app.db.models import Conversation
from app.db.schemas import ConversationBase, ResponseModel

conversation = APIRouter(
    tags=["Conversation"],
    responses={404: {"description": "404 Not Found"}}
)


@conversation.get("/api/llm/v1/conversation/list", summary="Get conversation list")
async def get_conversation_list(
        request: Request,
        page: int = 1,
        size: int = 10,
        redis: Redis = Depends(get_redis_session),
        session: AsyncSession = Depends(get_db_session),
        access_token: str = Depends(get_request_token),
        cache_user_id: int = Depends(get_cache_user_id),
) -> Response:
    query = select(Conversation).where(eq(Conversation.user_id, cache_user_id))
    conversations = await paginate(conn=session, query=query, params=Params(page=page, size=size))
    data = [app.db.schemas.Conversation.from_orm(conversation) for conversation in conversations.items]
    logger.info(f"get_conversation_list : {data}")
    return Response(content=ResponseModel(data=data).json())


@conversation.post("/api/llm/v1/conversation/add", summary="Add conversation")
async def add_conversation(
        params: ConversationBase,
        session: AsyncSession = Depends(get_db_session),
        cache_user_id: int = Depends(get_cache_user_id),
) -> Response:
    if params.title is None or len(params.title) == 0:
        return Response(content=ResponseModel(code=-1, msg="Conversation title is null.").json())
    db_conversation = Conversation(title=params.title, sub_title=params.sub_title, role_play=params.role_play,
                                   user_id=cache_user_id)
    try:
        session.add(db_conversation)
        await session.commit()
        await session.refresh(db_conversation)
        logger.info(f"add_conversation : {db_conversation.id}")
        return Response(content=ResponseModel(msg="Add conversation successfully.", data=db_conversation.id).json())
    except exc.SQLAlchemyError as error:
        print(error)
        return Response(content=ResponseModel(code=-1, msg="Add conversation error.").json())


async def add_conversation_socket(
        params: ConversationBase,
        access_token: str,
        session: AsyncSession = Depends(get_db_session),
        redis: Redis = Depends(get_redis_session)
) -> Response:
    cache_user_id = await redis.get(name=access_token)
    if cache_user_id is None:
        return Response(content=json.dumps({"code": -1, "msg": "User id is null."}))
    if len(params.title) == 0:
        return Response(content=json.dumps({"code": -1, "msg": "Conversation title is null."}))
    db_conversation_socket = Conversation(
        title=params.title, sub_title=params.sub_title, role_play=params.role_play, user_id=cache_user_id
    )
    try:
        session.add(db_conversation_socket)
        await session.commit()
        await session.refresh(db_conversation_socket)
        return Response(content=json.dumps({"code": 0, "msg": "Add conversation successfully."}))
    except exc.SQLAlchemyError as error:
        print(error)
        return Response(content=json.dumps({"code": -1, "msg": "Add conversation error."}))


@conversation.post("/api/llm/v1/conversation/update", summary="Update conversation")
async def update_conversation(
        params: app.db.schemas.ConversationCreate,
        session: AsyncSession = Depends(get_db_session)
) -> Response:
    if params.id is None or len(params.sub_title) == 0:
        return Response(content=ResponseModel(code=-1, msg="Conversation id is null or subTitle is null.").json())
    try:
        _conversation = await session.get(Conversation, params.id)
        _conversation.title = params.title
        _conversation.sub_title = params.sub_title
        await session.commit()
        await session.refresh(_conversation)
        logger.info(f"update_conversation : {_conversation}")
        return Response(content=ResponseModel(msg="Update conversation successfully.").json())
    except exc.SQLAlchemyError as error:
        print(error)
        return Response(content=ResponseModel(code=-1, msg="Update conversation error.").json())


async def update_conversation_socket(
        params: dict,
        session: AsyncSession = Depends(get_db_session)
) -> Response:
    if params["conversation_id"] is None or len(params["sub_title"]) == 0:
        return Response(content=ResponseModel(code=-1, msg="Conversation id is null or subTitle is null.").json())
    try:
        _conversation = await session.get(Conversation, params["conversation_id"])
        _conversation.sub_title = params["sub_title"]
        await session.commit()
        await session.refresh(_conversation)
        logger.info(f"update_conversation : {_conversation}")
        return Response(
            content=ResponseModel(msg="Update conversation successfully.", data=_conversation.sub_title).json())
    except exc.SQLAlchemyError as error:
        print(error)
        return Response(content=ResponseModel(code=-1, msg="Update conversation error.").json())


@conversation.post("/api/llm/v1/conversation/delete", summary="Delete conversation")
async def delete_conversation(
        params: app.db.schemas.ConversationDelete,
        session: AsyncSession = Depends(get_db_session),
        redis: Redis = Depends(get_redis_session)
) -> Response:
    if params.id is None:
        return Response(content=ResponseModel(code=-1, msg="Conversation id is null.").json())
    try:
        # stmt = delete(Message).where(eq(Message.conversation_id, params.id))
        if len(params.role_play) != 0:
            await redis.delete(f"message_store:{params.id}")
        stmt = delete(Conversation).where(eq(Conversation.id, params.id))
        _conversation = await session.execute(stmt)
        await session.commit()
        return Response(content=ResponseModel(msg="Delete conversation successfully.").json())
    except exc.SQLAlchemyError as error:
        print(error)
        return Response(content=ResponseModel(code=-1, msg="Delete conversation error.").json())
