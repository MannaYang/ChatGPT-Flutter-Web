from pydantic import BaseSettings


class Settings(BaseSettings):
    database_url: str
    redis_url: str
    celery_broker: str
    celery_backend: str
    database_pool_size: int
    database_pool_recycle: int
    database_pool_timeout: int
    database_max_overflow: int
    database_connect_timeout: int
    database_echo: bool
    database_pool_pre_ping: bool
    pinecone_controller_host: str
    pinecone_api_key: str
    pinecone_env: str

    class Config:
        env_file = ".env"


settings = Settings()
