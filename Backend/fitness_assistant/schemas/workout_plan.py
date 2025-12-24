from datetime import date, datetime

from pydantic import BaseModel, ConfigDict, Field


class PlanExerciseBase(BaseModel):
    exercise_id: int
    sets: int = Field(default=3, ge=1)
    reps: int = Field(default=12, ge=1)
    order_index: int = Field(default=0, ge=0)


class PlanExerciseCreate(PlanExerciseBase):
    pass


class PlanExerciseUpdate(BaseModel):
    sets: int | None = Field(None, ge=1)
    reps: int | None = Field(None, ge=1)
    order_index: int | None = Field(None, ge=0)
    is_completed: bool | None = None


class PlanExerciseResponse(PlanExerciseBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    plan_id: int
    is_completed: bool
    completed_at: datetime | None
    exercise_id: int
    exercise_name: str
    exercise_description: str | None
    exercise_difficulty: str | None
    exercise_image_url: str | None
    target_muscles: list[str] = []


# UserDailyPlan schemas
class UserDailyPlanCreate(BaseModel):
    """Схема для создания плана (дата опциональна - по умолчанию сегодня)"""
    plan_date: date | None = None
    exercises: list[PlanExerciseCreate] = []


class UserDailyPlanResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    plan_date: date
    created_at: datetime
    updated_at: datetime
    exercises: list[PlanExerciseResponse] = []


class TodaysPlanResponse(BaseModel):
    """Упрощенная схема для today's plan в HomeView"""

    exercises: list["TodaysPlanExercise"]
    total_exercises: int
    completed_exercises: int


class TodaysPlanExercise(BaseModel):
    """Упражнение в плане на сегодня (для HomeView)"""

    id: int
    exercise_id: int  # Добавлено: ID упражнения в таблице exercises
    name: str
    sets: int
    reps: int
    is_completed: bool
    description: str | None = None
    difficulty: str | None = None
    target_muscles: list[str] = []
    image_url: str | None = None

