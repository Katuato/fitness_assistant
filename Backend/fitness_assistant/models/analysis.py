from datetime import datetime
from decimal import Decimal
from typing import TYPE_CHECKING

from sqlalchemy import DateTime, ForeignKey, Integer, Numeric, SmallInteger, Text, func
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship

from fitness_assistant.db.base import Base

if TYPE_CHECKING:
    from fitness_assistant.models.media import Media


class AnalysisTask(Base):
    """Модель таблицы 'analysis_tasks'"""

    __tablename__ = "analysis_tasks"

    id: Mapped[int] = mapped_column(primary_key=True)
    media_id: Mapped[int | None] = mapped_column(ForeignKey("media.id"))
    status: Mapped[str] = mapped_column(Text, nullable=False, default="queued")
    priority: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)
    attempts: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    error_text: Mapped[str | None] = mapped_column(Text)
    started_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    finished_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    media: Mapped["Media"] = relationship(back_populates="analysis_tasks")
    results: Mapped[list["AnalysisResult"]] = relationship(back_populates="task")


class AnalysisResult(Base):
    """Модель таблицы 'analysis_results'"""

    __tablename__ = "analysis_results"

    id: Mapped[int] = mapped_column(primary_key=True)
    task_id: Mapped[int] = mapped_column(ForeignKey("analysis_tasks.id"), nullable=False)
    result: Mapped[dict] = mapped_column(JSONB, nullable=False)
    summary_text: Mapped[str | None] = mapped_column(Text)
    score: Mapped[Decimal | None] = mapped_column(Numeric(5, 3))
    thumbnails: Mapped[dict | None] = mapped_column(JSONB)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )

    task: Mapped["AnalysisTask"] = relationship(back_populates="results")
