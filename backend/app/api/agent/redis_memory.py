import os

from langchain_community.chat_message_histories import RedisChatMessageHistory
from langchain_core.runnables.history import RunnableWithMessageHistory
from langchain_openai import ChatOpenAI
from loguru import logger

from app.api.agent.role_play import rolePlayPromptManager


class RedisMemoryManager:
    instances = {}

    @staticmethod
    def get_instance(cls, session_id):
        if session_id not in cls.instances:
            logger.info(f"Creating new memory manager for session {session_id}.")
            instance = RedisChatMessageHistory(session_id=session_id,
                                               url=os.getenv("REDIS_URL", "redis://127.0.0.1:6379?encoding=utf-8"),
                                               ttl=3600)
            cls.instances[session_id] = instance
        logger.info(f"Returning memory manager for session {session_id}.")
        return cls.instances[session_id]


class RunnableHistoryManager:
    instances = {}

    @staticmethod
    def get_instance(cls, session_id, role) -> RunnableWithMessageHistory:
        if session_id not in cls.instances:
            logger.info(f"Creating new history manager for session {session_id} and role {role}.")
            prompt = rolePlayPromptManager.format_prompt(role=role)
            llm = ChatOpenAI(temperature=0.7, model_name="gpt-3.5-turbo-1106",
                             max_tokens=1024, streaming=True)
            history = RedisMemoryManager.get_instance(RedisMemoryManager, session_id=session_id)
            chain_with_history = RunnableWithMessageHistory(
                prompt | llm,
                history,
                input_messages_key="input",
                history_messages_key="history"
            )
            cls.instances[session_id] = chain_with_history
        logger.info(f"Returning history manager for session {session_id} and role {role}.")
        return cls.instances[session_id]
