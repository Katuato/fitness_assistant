from datetime import date, datetime
from typing import TYPE_CHECKING

from sqlalchemy import Boolean, Date, DateTime, ForeignKey, Integer, Text, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from fitness_assistant.db.base import Base

if TYPE_CHECKING:
    from fitness_assistant.models.exercise import Exercise
    from fitness_assistant.models.user import User


class UserDailyPlan(Base):
    """План тренировки пользователя на конкретный день"""

    __tablename__ = "user_daily_plans"

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), nullable=False)
    plan_date: Mapped[date] = mapped_column(Date, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    # Relationships
    user: Mapped["User"] = relationship(back_populates="daily_plans")
    exercises: Mapped[list["PlanExercise"]] = relationship(back_populates="plan", cascade="all, delete-orphan")


class PlanExercise(Base):
    """Упражнение в плане тренировки"""

    __tablename__ = "plan_exercises"

    id: Mapped[int] = mapped_column(primary_key=True)
    plan_id: Mapped[int] = mapped_column(Integer, ForeignKey("user_daily_plans.id"), nullable=False)
    exercise_id: Mapped[int] = mapped_column(Integer, ForeignKey("exercises.id"), nullable=False)
    sets: Mapped[int] = mapped_column(Integer, nullable=False, default=3)
    reps: Mapped[int] = mapped_column(Integer, nullable=False, default=12)
    order_index: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    is_completed: Mapped[bool] = mapped_column(Boolean, default=False)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    # Relationships
    plan: Mapped["UserDailyPlan"] = relationship(back_populates="exercises")
    exercise: Mapped["Exercise"] = relationship()
