from datetime import datetime, timedelta
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Request
from jose import jwt, JWTError
from loguru import logger
from passlib.context import CryptContext
from redis.asyncio import Redis
from sqlalchemy import exc, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.sql.operators import eq
from starlette.responses import Response

import app.db.schemas
from app.db.database import get_db_session, get_redis_session
from app.db.models import User
from app.db.schemas import ResponseModel, Token

pwd_context = CryptContext(schemes=['bcrypt'], deprecated='auto')

auth = APIRouter(
    tags=['Auth'],
    responses={404: {"description": "404 Not Found"}}
)

# openssl rand -hex 32
# a7c7ba9328ce348b8112198cd19c1d801d5b6203fe9022673b6dec5c7d89e3a4

SECRET_KEY = "a7c7ba9328ce348b8112198cd19c1d801d5b6203fe9022673b6dec5c7d89e3a4"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


async def get_hash_pwd(pwd: str):
    return pwd_context.hash(pwd)


async def verify_pwd(origin_pwd: str, hash_pwd: str):
    """
    :param origin_pwd: origin
    :param hash_pwd: hashed
    :return: if verify successfully,return True,otherwise false
    """
    return pwd_context.verify(origin_pwd, hash_pwd)


async def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(hours=30)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def check_access_token(access_token: str) -> str:
    if access_token is None or len(access_token) == 0:
        return ""
    try:
        payload = jwt.decode(access_token, SECRET_KEY, algorithms=ALGORITHM)
        email: str = payload.get("sub")
        if email is None:
            return ""
        else:
            return email
    except JWTError as error:
        print(error)
        return ""


async def get_user_info(email: str, session: AsyncSession) -> Optional[app.db.schemas.UserCreate]:
    query = select(User.email, User.id, User.hashed_password).where(eq(User.email, email))
    user_info = await session.execute(query)
    data = user_info.first()
    if data is None:
        return None
    model = app.db.schemas.UserCreate.from_orm(data)
    return model


async def authenticate_user(username: str, session: AsyncSession):
    if username is None or len(username) == 0:
        return None
    user_info = await get_user_info(username, session)
    return user_info


async def authenticate_token(token: Optional[str]):
    if token is None or len(token) == 0:
        logger.info("Token not be null or empty.")
        return None
    else:
        access_token = token.split(" ")[1]
        check_user = await check_access_token(access_token)
        logger.info(f"Check User : {check_user}")
        if len(check_user) == 0:
            return None
        return access_token


@auth.post("/api/llm/v1/auth/signin", summary="User sign in")
async def sign_in(user_info: app.db.schemas.UserInfo, session: AsyncSession = Depends(get_db_session),
                  redis: Redis = Depends(get_redis_session)):
    # check account
    if user_info.email is None or len(user_info.email) == 0:
        raise HTTPException(status_code=403, detail="Username or password not be empty")
    # check user
    check_user = await authenticate_user(user_info.email, session)
    if check_user is None:
        check_create = await create_user(user_info, session)
        if not check_create:
            raise HTTPException(status_code=403, detail="User create error")
    # check password
    else:
        check_pwd = await verify_pwd(user_info.password, check_user.hashed_password)
        if not check_pwd:
            raise HTTPException(status_code=403, detail="Username or password error")
    db_user = await get_user_info(user_info.email, session)
    if db_user is None:
        raise HTTPException(status_code=403, detail="User info query error")
    else:
        cache_token = await redis.get(db_user.email)
        access_token_expires = timedelta(hours=ACCESS_TOKEN_EXPIRE_MINUTES)
        if cache_token is None:
            token = await create_access_token(
                data={"sub": user_info.email},
                expires_delta=access_token_expires,
            )
            await redis.setex(token, access_token_expires, db_user.id)
            await redis.setex(db_user.email, access_token_expires, token)
            await redis.expire(token, access_token_expires)
        else:
            token = cache_token
        await redis.expire(token, access_token_expires)
        data = ResponseModel(data=Token(access_token=token, token_type="Bearer", user_id=db_user.id))
        return Response(status_code=200, content=data.json())


async def create_user(user_info: app.db.schemas.UserInfo, session: AsyncSession) -> bool:
    hash_pwd = await get_hash_pwd(user_info.password)
    db_user = User(email=user_info.email, hashed_password=hash_pwd)
    try:
        session.add(db_user)
        await session.commit()
        await session.refresh(db_user)
        return True
    except exc.SQLAlchemyError as error:
        print(error)
        return False


async def get_request_token(request: Request) -> str:
    authorization = request.headers.get('Authorization')
    logger.info(f"Authorization: {authorization}")
    if authorization is None or not authorization.startswith("Bearer") or len(authorization) == 0:
        raise HTTPException(401, detail="Token not exist or expired or format error.")
    access_token = authorization.split(" ")[1]
    return access_token


async def get_query_token(request: Request) -> str:
    authorization = request.query_params.get("Authorization")
    logger.info(f"Authorization: {authorization}")
    if authorization is None or not authorization.startswith("Bearer") or len(authorization) == 0:
        raise HTTPException(401, detail="Token not exist or expired or format error.")
    access_token = authorization.split(" ")[1]
    return access_token


async def get_cache_user_id(
        request: Request,
        redis: Redis = Depends(get_redis_session),
        session: AsyncSession = Depends(get_db_session)
) -> int:
    authorization = request.headers.get('Authorization')
    if authorization is None or not authorization.startswith("Bearer") or len(authorization) == 0:
        raise HTTPException(401, detail="Token not exist or expired or format error.")
    access_token = authorization.split(" ")[1]
    cache_user_id = await redis.get(name=access_token)
    if cache_user_id is None:
        email = await check_access_token(access_token)
        if email is None or len(email) == 0:
            raise HTTPException(status_code=400, detail="Email or password not be empty")
        db_user = await get_user_info(email, session)
        if db_user is None:
            raise HTTPException(status_code=403, detail="User query error")
        else:
            cache_user_id = db_user.id
    return cache_user_id


@auth.get('/api/llm/v1/auth/user', summary="Get user info")
async def get_user(user_id: int, session: AsyncSession = Depends(get_db_session)) -> Response:
    query = select(User).where(eq(User.id, user_id))
    user_info = await session.execute(query)
    data = user_info.scalar()
    if data is None:
        response = ResponseModel(code=-1, msg="User info query is emtpy, please sign in first.")
    else:
        response = ResponseModel(data=app.db.schemas.User.from_orm(data))
    return Response(content=response.json())


@auth.post('/api/llm/v1/auth/signOut', summary="Sign out")
async def sign_out(
        params: app.db.schemas.UserBase,
        access_token: str = Depends(get_request_token),
        redis: Redis = Depends(get_redis_session)
) -> Response:
    try:
        await redis.delete(access_token)
        await redis.delete(params.email)
        response = ResponseModel(data=True, msg="Sign out successfully.")
        return Response(content=response.json())
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"{e}")
