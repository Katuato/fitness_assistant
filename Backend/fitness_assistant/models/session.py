from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import DateTime, ForeignKey, Integer, Text, func
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship

from fitness_assistant.db.base import Base

if TYPE_CHECKING:
    from fitness_assistant.models.user import User


class Session(Base):
    __tablename__ = "sessions"

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), nullable=False)
    start_time: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    end_time: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    accuracy: Mapped[int | None] = mapped_column(Integer)  
    body_part: Mapped[str | None] = mapped_column(Text)  

    device_info: Mapped[dict | None] = mapped_column(JSONB)
    notes: Mapped[str | None] = mapped_column(Text)

    # Relationships
    user: Mapped["User"] = relationship(back_populates="sessions")
    exercise_runs: Mapped[list["SessionExerciseRun"]] = relationship(back_populates="session")


class SessionExerciseRun(Base):
    __tablename__ = "session_exercise_runs"

    id: Mapped[int] = mapped_column(primary_key=True)
    session_id: Mapped[int] = mapped_column(Integer, ForeignKey("sessions.id"), nullable=False)
    exercise_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("exercises.id"))
    start_time: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    end_time: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    # Relationships
    session: Mapped["Session"] = relationship(back_populates="exercise_runs")
