"""Pydantic схемы для упражнений."""

from datetime import datetime

from pydantic import BaseModel, ConfigDict

from fitness_assistant.enums.exercise_enums import (
    ExerciseForce,
    ExerciseLevel,
    ExerciseMechanic,
    MuscleRole,
)


class MuscleResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str


class EquipmentResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str


class ExerciseMuscleResponse(BaseModel):

    muscle_id: int
    muscle_name: str
    role: MuscleRole


class ExerciseImageResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    image_path: str


class ExerciseBase(BaseModel):

    name: str | None
    category: str | None
    equipment: str | None
    force: ExerciseForce | None
    level: ExerciseLevel | None
    mechanic: ExerciseMechanic | None
    instructions: dict | None


class ExerciseResponse(ExerciseBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    created_at: datetime | None
    muscles: list[ExerciseMuscleResponse] = []
    images: list[ExerciseImageResponse] = []


class ExerciseListResponse(BaseModel):

    items: list[ExerciseResponse]
    total: int
    page: int
    size: int
