"""Pydantic схемы для упражнений."""

from datetime import datetime

from pydantic import BaseModel

from fitness_assistant.enums.exercise_enums import (
    ExerciseForce,
    ExerciseLevel,
    ExerciseMechanic,
    MuscleRole,
)


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
