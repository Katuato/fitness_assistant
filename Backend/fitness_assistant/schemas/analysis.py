"""Pydantic схемы для анализа"""

from datetime import datetime
from decimal import Decimal

from pydantic import BaseModel, Field


# Analysis Task schemas
class AnalysisTaskBase(BaseModel):

    media_id: int | None
    priority: int = Field(default=0, ge=0, le=10)


class AnalysisTaskCreate(AnalysisTaskBase):

    pass


class AnalysisTaskResponse(AnalysisTaskBase):

    id: int
    status: str
    attempts: int
    error_text: str | None
    started_at: datetime | None
    finished_at: datetime | None

    class Config:
        from_attributes = True


class AnalysisResultResponse(BaseModel):

    id: int
    task_id: int
    result: dict
    summary_text: str | None
    score: Decimal | None = Field(ge=0, le=100)
    thumbnails: dict | None
    created_at: datetime

    class Config:
        from_attributes = True


class AnalysisTaskWithResultResponse(AnalysisTaskResponse):

    results: list[AnalysisResultResponse] = []
