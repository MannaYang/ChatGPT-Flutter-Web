from functools import lru_cache

from fastapi import APIRouter

from app.api.agent.role_play import rolePlayPromptManager, RolePlayPromptManager
from app.db.schemas import ResponseModel

promptTemplate = APIRouter(
    tags=['PromptTemplate'],
    responses={404: {"description": "404 Not Found"}}
)


@lru_cache
def get_cache_prompt_template():
    return ResponseModel(data=rolePlayPromptManager.get_prompt_template())


@promptTemplate.get("/api/llm/v1/prompt/template")
async def get_prompt_template():
    """ If you want to get new prompt template, you can use clear(), such as
    ```
    get_cache_prompt_template().clear()
    ```
    """
    return get_cache_prompt_template()


def get_audio_transcription_prompt(audio: str):
    return RolePlayPromptManager.get_audio_transcription_prompt(audio)
