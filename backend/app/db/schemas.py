import datetime
from typing import List, Union, Any, Optional
from pydantic import BaseModel, Field


class MessageBase(BaseModel):
    content: str


class MessageInfo(BaseModel):
    conversation_id: int


class MessageCreate(MessageBase):
    conversation_id: int
    role: str


class MessageDelete(BaseModel):
    id: int
    conversation_id: int


class Message(MessageBase):
    id: int
    conversation_id: int
    role: str
    image: str
    file: str
    audio: str
    create_time: datetime.datetime = Field(format="%Y-%m-%d %H:%M:%S")
    update_time: datetime.datetime = Field(format="%Y-%m-%d %H:%M:%S")

    @property
    def create_time_str(self):
        return self.create_time.strftime("%Y-%m-%d %H:%M:%S")

    @property
    def update_time_str(self):
        return self.update_time.strftime("%Y-%m-%d %H:%M:%S")

    class Config:
        orm_mode = True


class ConversationBase(BaseModel):
    title: str
    sub_title: str
    role_play: str


class ConversationCreate(ConversationBase):
    id: int


class ConversationDelete(BaseModel):
    id: int
    role_play: str


class Conversation(ConversationBase):
    id: int
    user_id: int
    items: List[Message] = []

    class Config:
        orm_mode = True


class UserBase(BaseModel):
    email: str


class UserCreate(UserBase):
    id: int
    hashed_password: str

    class Config:
        orm_mode = True


class UserInfo(UserBase):
    password: str


class User(UserBase):
    id: int
    is_active: bool
    items: List[Conversation] = []

    class Config:
        orm_mode = True


class Token(BaseModel):
    access_token: str
    token_type: str
    user_id: int


class ResponseModel(BaseModel):
    code: int = 0
    msg: str = "Success"
    success: bool = True
    data: Any = None

    def to_dict(self):
        return {
            "code": self.code,
            "msg": self.msg,
            "success": self.success,
            "data": self.data
        }
