import os
from collections.abc import AsyncGenerator
from redis import asyncio as aioredis
from redis.asyncio import Redis
from sqlalchemy import exc
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.pool import QueuePool

# charset=utf8mb4 -> emoji

# engine
engine = create_async_engine(
    os.getenv("DATABASE_URL", "mysql+aiomysql://root:123456@127.0.0.1:3306/ai_my?charset=utf8mb4"),
    pool_size=int(os.getenv("DATABASE_POOL_SIZE", 98)),
    pool_recycle=int(os.getenv("DATABASE_POOL_RECYCLE", 3600)),
    pool_timeout=int(os.getenv("DATABASE_POOL_TIMEOUT", 15)),
    max_overflow=int(os.getenv("DATABASE_MAX_OVERFLOW", 2)),
    connect_args={"connect_timeout": int(os.getenv("DATABASE_CONNECT_TIMEOUT", 60))},
    poolclass=QueuePool,
    pool_pre_ping=bool(os.getenv("DATABASE_POOL_PRE_PING", True)),
    echo=bool(os.getenv("DATABASE_ECHO", True)))

# session
SessionLocal = async_sessionmaker(
    class_=AsyncSession,
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()


# db session
async def get_db_session() -> AsyncGenerator[AsyncSession, None]:
    async with SessionLocal() as session:
        try:
            yield session
            await session.commit()
        except exc.SQLAlchemyError:
            await session.rollback()
            raise


async def get_redis_session() -> Redis:
    redis = await aioredis.from_url(os.getenv("REDIS_URL", "redis://127.0.0.1:6379?encoding=utf-8"))
    try:
        yield redis
    finally:
        await redis.aclose()


async def get_redis_session_task() -> AsyncGenerator[Redis, None]:
    redis = await aioredis.from_url(os.getenv("REDIS_URL", "redis://127.0.0.1:6379?encoding=utf-8"))
    try:
        yield redis
    finally:
        await redis.aclose()
