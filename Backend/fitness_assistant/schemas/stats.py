from datetime import datetime

from pydantic import BaseModel, Field


class WorkoutStatsResponse(BaseModel):
    """Статистика тренировок для HomeView"""

    workouts_count: int = Field(..., description="Общее количество тренировок")
    day_streak: int = Field(..., description="Текущая серия дней подряд")
    accuracy: int = Field(..., ge=0, le=100, description="Средняя точность %")


class WeeklyStatsResponse(BaseModel):
    """Недельная статистика для DashboardView"""

    week_label: str = Field(..., description="Например: 'This week'")
    average_accuracy: float = Field(..., ge=0, le=100)
    daily_accuracies: list["DayAccuracy"]


class DayAccuracy(BaseModel):
    """Точность за день"""

    day: str = Field(..., description="M, T, W, Th, F, S, Su")
    accuracy: float = Field(..., ge=0, le=100)


class RecentSessionResponse(BaseModel):
    """Недавняя тренировка для DashboardView"""

    id: int
    date: datetime
    exercise_count: int
    total_time: int
    accuracy: int
    body_part: str
