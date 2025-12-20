from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text, func
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship

from fitness_assistant.db.base import Base
from fitness_assistant.enums.exercise_enums import ExerciseForce, ExerciseLevel, ExerciseMechanic, MuscleRole

if TYPE_CHECKING:
    from fitness_assistant.models.media import Media


class Exercise(Base):
    """Модель таблицы 'exercises'"""

    __tablename__ = "exercises"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str | None] = mapped_column(Text)
    category: Mapped[str | None] = mapped_column(Text)
    description: Mapped[str | None] = mapped_column(Text)
    difficulty: Mapped[str | None] = mapped_column(Text)  
    estimated_duration: Mapped[int | None] = mapped_column(Integer)  
    calories_burn: Mapped[int | None] = mapped_column(Integer)
    default_sets: Mapped[int | None] = mapped_column(Integer, default=3)
    default_reps: Mapped[int | None] = mapped_column(Integer, default=12)
    image_url: Mapped[str | None] = mapped_column(Text) 

    equipment: Mapped[str | None] = mapped_column(Text)
    force: Mapped[ExerciseForce | None] = mapped_column(Text)
    level: Mapped[ExerciseLevel | None] = mapped_column(Text)
    mechanic: Mapped[ExerciseMechanic | None] = mapped_column(Text)
    instructions: Mapped[dict | list | None] = mapped_column(JSONB)
    raw: Mapped[dict | None] = mapped_column(JSONB)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    muscles: Mapped[list["ExerciseMuscle"]] = relationship(back_populates="exercise")
    equipment_links: Mapped[list["ExerciseEquipment"]] = relationship(back_populates="exercise")
    images: Mapped[list["ExerciseImage"]] = relationship(back_populates="exercise")
    media_files: Mapped[list["Media"]] = relationship(back_populates="exercise")


class ExerciseImage(Base):
    """Модель таблицы 'exercise_images'"""

    __tablename__ = "exercise_images"

    id: Mapped[int] = mapped_column(primary_key=True)
    exercise_id: Mapped[int | None] = mapped_column(ForeignKey("exercises.id"))
    image_path: Mapped[str] = mapped_column(String(500), nullable=False)
    created_at: Mapped[datetime | None] = mapped_column(DateTime, server_default=func.now())

    exercise: Mapped["Exercise"] = relationship(back_populates="images")


class Muscle(Base):
    """Модель таблицы 'muscles'"""

    __tablename__ = "muscles"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(Text, nullable=False)

    exercises: Mapped[list["ExerciseMuscle"]] = relationship(back_populates="muscle")


class ExerciseMuscle(Base):
    """Модель таблицы 'exercise_muscle'"""

    __tablename__ = "exercise_muscle"

    muscle_id: Mapped[int] = mapped_column(ForeignKey("muscles.id"), primary_key=True)
    exercise_id: Mapped[int] = mapped_column(ForeignKey("exercises.id"), primary_key=True)
    role: Mapped[MuscleRole] = mapped_column(Text, nullable=False)  # 'primary' or 'secondary'

    muscle: Mapped["Muscle"] = relationship(back_populates="exercises")
    exercise: Mapped["Exercise"] = relationship(back_populates="muscles")


class Equipment(Base):
    """Модель таблицы 'equipment'"""

    __tablename__ = "equipment"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(Text, nullable=False)

    exercises: Mapped[list["ExerciseEquipment"]] = relationship(back_populates="equipment")
    users: Mapped[list["UserEquipment"]] = relationship(back_populates="equipment")


class ExerciseEquipment(Base):
    """Модель таблицы 'exercise_equipment'"""

    __tablename__ = "exercise_equipment"

    equipment_id: Mapped[int] = mapped_column(ForeignKey("equipment.id"), primary_key=True)
    exercise_id: Mapped[int | None] = mapped_column(ForeignKey("exercises.id"))

    equipment: Mapped["Equipment"] = relationship(back_populates="exercises")
    exercise: Mapped["Exercise"] = relationship(back_populates="equipment_links")


class UserEquipment(Base):
    """Модель таблицы 'user_equipment'"""

    __tablename__ = "user_equipment"

    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), primary_key=True)
    equipment_id: Mapped[int] = mapped_column(ForeignKey("equipment.id"), primary_key=True)

    # Relationships
    equipment: Mapped["Equipment"] = relationship(back_populates="users")
    user: Mapped["User"] = relationship(back_populates="equipment")
