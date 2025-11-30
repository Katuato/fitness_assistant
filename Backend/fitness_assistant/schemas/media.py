"""Pydantic схемы для медиа файлов."""

from datetime import datetime

from pydantic import BaseModel

from fitness_assistant.enums.media_enums import MediaType


class MediaBase(BaseModel):
    """Базовая схема для медиа файлов."""

    media_type: MediaType
    exercise_id: int | None = None
    meta: dict | None = None


class MediaCreate(MediaBase):
    """Схема для создания медиа файла."""

    s3_key: str


class MediaResponse(MediaBase):
    """Схема для ответа медиа файла."""

    id: int
    owner_user: int | None
    s3_key: str | None
    created_at: datetime

    class Config:
        from_attributes = True


class MediaListResponse(BaseModel):
    """Схема для списка медиа файлов с пагинацией."""

    items: list[MediaResponse]
    total: int
    page: int
    size: int


class MediaUploadResponse(BaseModel):
    """Схема для ответа на загрузку медиа файла с presigned URL."""

    media_id: int
    upload_url: str
    s3_key: str
