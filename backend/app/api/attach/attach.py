import base64
import os
import time
from typing import List

from loguru import logger
from fastapi import Request
from fastapi import UploadFile, File, APIRouter
from openai.types import Image

from app.api.agent import client
from app.api.agent.agent import create_file_vector
from app.api.task.task import wav_trim_silence
from app.db.schemas import ResponseModel

attach = APIRouter(
    tags=['attach'],
    responses={404: {"description": "404 Not Found"}}
)


def generate_uuid():
    # return uuid.uuid4().hex
    return int(round(time.time() * 1000))


file_ext_mapping = {
    "wav": "audio",
    "pdf": "vector",
    "docx": "vector",
    "txt": "vector",
    "md": "vector",
}


@attach.post("/api/llm/v1/file/vector", summary="Upload doc to vectorize it")
async def upload_file(files: UploadFile = File(...)):
    file_name = files.filename
    file_path = "app/attach/file/" + file_name
    if os.path.isfile(file_path):
        return ResponseModel(code=-1, msg="[" + file_name + "]has already uploaded",
                             data={"file_name": file_name, "res_id": f"{file_name}"})
    file_ext = file_name.split(".")[-1]
    f = open(file_path, 'wb')
    data = await files.read()
    f.write(data)
    f.close()
    create_file_vector(file_ext, file_path)
    return ResponseModel(msg="[" + files.filename + "]upload success",
                         data={"file_name": file_name, "res_id": f"{file_name}"})


@attach.post("/api/llm/v1/file/upload", summary="Upload images/audios")
async def upload_file(request: Request, files: UploadFile = File(...)):
    res_id = generate_uuid()
    file_name = files.filename
    file_ext = file_name.split(".")[-1]
    path_tag = file_ext_mapping.get(file_ext, "image")
    file_path = f"app/attach/{path_tag}/{res_id}.{file_ext}"
    f = open(file_path, 'wb')
    data = await files.read()
    f.write(data)
    f.close()
    if path_tag == "audio":
        wav_trim_silence.apply_async((file_path,))
        # path_url = f"{request.url.scheme}://{request.headers['host']}/static/{path_tag}/{res_id}.{file_ext}"
        audio_url = f"{request.url.scheme}://{request.headers['host']}/static/{path_tag}/{res_id}.{file_ext}"
        path_url = f' <audio>{audio_url}</audio> '
    else:
        path_url = f"![]({request.url.scheme}://{request.headers['host']}/static/{path_tag}/{res_id}.{file_ext})"
    return ResponseModel(msg="[" + files.filename + "]upload success",
                         data={"file_name": file_name, "res_id": f"{path_url}"})


def save_base64_image(images: List[Image], save_directory) -> List[str]:
    file_name_list = []
    for image in images:
        image_data = base64.b64decode(image.b64_json)
        file_name = f"{generate_uuid()}.png"
        save_path = os.path.join(save_directory, file_name)
        with open(save_path, 'wb') as f:
            f.write(image_data)
        file_name_list.append(file_name)
    return file_name_list


async def generate_image(input_str: str, host: str):
    response = await client.images.generate(
        model="dall-e-2",
        prompt=f"Generate a detailed prompt to generate an image based on the following description: {input_str}",
        n=1,
        size="256x256",
        response_format="b64_json"
    )
    file_name = save_base64_image(response.data, "app/attach/image")
    image = "".join([f"![](http://{host}/static/image/{name})" for name in file_name])
    return image


async def edit_image(image_path: str, input_str: str, host: str):
    local_path = f'app/attach{(image_path.split("static")[-1][:-1])}'
    response = await client.images.edit(
        image=open(local_path, "rb"),
        prompt=input_str,
        n=1, size="256x256", response_format="b64_json")
    file_name = save_base64_image(response.data, "app/attach/image")
    image = "".join([f"![](http://{host}/static/image/{name})" for name in file_name])
    return image


async def generate_audio(input_str: str, host: str):
    res_id = generate_uuid()
    speech_file_path = f"app/attach/audio/{res_id}.wav"
    response = await client.audio.speech.create(
        model="tts-1",
        voice="alloy",
        input=input_str
    )
    await response.astream_to_file(speech_file_path)
    audio_path = f"http://{host}/static/audio/{res_id}.{'wav'}"
    audio = f"<audio>{audio_path}</audio>"
    return audio


async def transcription_audio(audio_path: str, input_str: str):
    start_index = audio_path.find("http")
    end_index = audio_path.find("</audio>", start_index)
    http_link = audio_path[start_index:end_index]
    local_path = f'app/attach{(http_link.split("static")[-1])}'
    logger.info(f"local_path : {local_path}")
    audio_file = open(local_path, "rb")
    transcription = await client.audio.transcriptions.create(
        model="whisper-1",
        file=audio_file,
        response_format="text",
        prompt=input_str
    )
    return transcription
