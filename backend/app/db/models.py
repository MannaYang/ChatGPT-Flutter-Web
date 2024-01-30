from datetime import datetime

from sqlalchemy import Column, String, Boolean, Integer, ForeignKey, DateTime
from sqlalchemy.dialects.mysql import TEXT
from sqlalchemy.orm import relationship

from app.db.database import Base


class BaseMixin:
    create_time = Column(DateTime, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, default=datetime.now, onupdate=datetime.now, comment='修改时间')


class User(Base, BaseMixin):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(30), unique=True, index=True)
    hashed_password = Column(String(100))
    is_active = Column(Boolean, default=True)

    conversations = relationship("Conversation", back_populates="users", uselist=True, lazy="dynamic",
                                 cascade="all,delete", passive_deletes=True)

    def __init__(self, email: str, hashed_password: str):
        self.email = email
        self.hashed_password = hashed_password


class Conversation(Base, BaseMixin):
    __tablename__ = "conversations"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(100), index=True, comment='对话标题')
    sub_title = Column(String(255), nullable=True, comment='对话摘要')
    role_play = Column(String(20), nullable=True, comment='角色扮演')

    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), comment='关联用户')
    users = relationship("User", back_populates="conversations", uselist=False)
    messages = relationship("Message", back_populates="conversations", uselist=True, lazy="dynamic",
                            cascade="all,delete", passive_deletes=True)

    def __init__(self, title: str, sub_title: str, role_play: str, user_id: int):
        self.title = title
        self.sub_title = sub_title
        self.role_play = role_play
        self.user_id = user_id


class Message(Base, BaseMixin):
    __tablename__ = "messages"

    id = Column(Integer, primary_key=True, index=True)
    content = Column(TEXT, comment='消息内容')
    role = Column(String(20), comment='消息角色')
    image = Column(String(200), nullable=True, comment='图片地址')
    audio = Column(String(200), nullable=True, comment='语音地址')
    file = Column(String(200), nullable=True, comment='文档地址')
    conversation_id = Column(Integer, ForeignKey("conversations.id", ondelete="CASCADE"), comment='关联对话')
    conversations = relationship("Conversation", back_populates="messages", uselist=False)

    def __init__(self, content: str, conversation_id: int, role: str, image: str, audio: str, file: str):
        self.content = content
        self.conversation_id = conversation_id
        self.role = role
        self.image = image
        self.file = file
        self.audio = audio
