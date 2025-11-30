from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import DateTime, ForeignKey, Text, func
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship

from fitness_assistant.db.base import Base

if TYPE_CHECKING:
    from fitness_assistant.models.analysis import AnalysisTask
    from fitness_assistant.models.exercise import Exercise
    from fitness_assistant.models.user import User


class Media(Base):
    """Модель таблицы 'media'"""

    __tablename__ = "media"

    id: Mapped[int] = mapped_column(primary_key=True)
    owner_user: Mapped[int | None] = mapped_column(ForeignKey("users.id"))
    exercise_id: Mapped[int | None] = mapped_column(ForeignKey("exercises.id"))
    media_type: Mapped[str] = mapped_column(Text, nullable=False)  # image, gif, video, thumbnail
    s3_key: Mapped[str | None] = mapped_column(Text)
    meta: Mapped[dict | None] = mapped_column(JSONB)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )

    owner: Mapped["User"] = relationship(back_populates="media_files")
    exercise: Mapped["Exercise"] = relationship(back_populates="media_files")
    analysis_tasks: Mapped[list["AnalysisTask"]] = relationship(back_populates="media")
