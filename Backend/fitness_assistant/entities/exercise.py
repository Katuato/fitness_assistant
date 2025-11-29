"""Pydantic схемы для упражнений."""

from datetime import datetime
from enum import Enum

from pydantic import BaseModel


class MuscleRole(str, Enum):
    """Роль мышцы в упражнении."""

    PRIMARY = "primary"
    SECONDARY = "secondary"


class ExerciseForce(str, Enum):
    """Тип мышечного сокращения."""

    PUSH = "push"
    PULL = "pull"
    STATIC = "static"


class ExerciseMechanic(str, Enum):
    """Механика выполнения упражнения."""

    COMPOUND = "compound"
    ISOLATION = "isolation"


class ExerciseLevel(str, Enum):
    """Уровень сложности упражнения."""

    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"


class MuscleResponse(BaseModel):

    id: int
    name: str

    class Config:
        from_attributes = True


class EquipmentResponse(BaseModel):

    id: int
    name: str

    class Config:
        from_attributes = True


class ExerciseMuscleResponse(BaseModel):

    muscle_id: int
    muscle_name: str
    role: MuscleRole


class ExerciseImageResponse(BaseModel):

    id: int
    image_path: str

    class Config:
        from_attributes = True


class ExerciseBase(BaseModel):

    name: str | None
    category: str | None
    equipment: str | None
    force: ExerciseForce | None
    level: ExerciseLevel | None
    mechanic: ExerciseMechanic | None
    instructions: dict | None


class ExerciseResponse(ExerciseBase):

    id: int
    created_at: datetime | None
    muscles: list[ExerciseMuscleResponse] = []
    images: list[ExerciseImageResponse] = []

    class Config:
        from_attributes = True


class ExerciseListResponse(BaseModel):

    items: list[ExerciseResponse]
    total: int
    page: int
    size: int
