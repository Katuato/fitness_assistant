"""Pydantic схемы для упражнений."""

from datetime import datetime

from pydantic import BaseModel, ConfigDict

from fitness_assistant.enums.exercise_enums import (
    ExerciseForce,
    ExerciseLevel,
    ExerciseMechanic,
    MuscleRole,
)




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
    description: str | None = None
    difficulty: str | None = None
    estimated_duration: int | None = None
    calories_burn: int | None = None
    default_sets: int | None = None
    default_reps: int | None = None
    image_url: str | None = None

    equipment: str | None
    force: ExerciseForce | None
    level: ExerciseLevel | None
    mechanic: ExerciseMechanic | None
    instructions: dict | list | None


class ExerciseResponse(ExerciseBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    created_at: datetime | None
    muscles: list[ExerciseMuscleResponse] = []
    images: list[ExerciseImageResponse] = []




class CategoryResponse(BaseModel):
    """Ответ с категорией упражнения."""

    name: str
    exercise_count: int


class CategoriesListResponse(BaseModel):
    """Ответ со списком категорий."""

    categories: list[CategoryResponse]


# Новые схемы для iOS интеграции (AddExerciseView)

class IOSCategoryResponse(BaseModel):
    """Категория упражнений для AddExerciseView (iOS формат)."""
    id: str  # UUID-like для совместимости с iOS
    name: str
    icon: str
    color: str  # Hex цвет


class CategorizedExerciseResponse(BaseModel):
    """Упражнение с категорией для AddExerciseView."""
    id: int
    name: str
    category: str
    target_muscles: list[str] = []
    description: str | None = None
    instructions: list[str] = []
    sets: int | None = None
    reps: int | None = None
    difficulty: str | None = None
    estimated_duration: int | None = None
    calories_burn: int | None = None
    image_url: str | None = None


