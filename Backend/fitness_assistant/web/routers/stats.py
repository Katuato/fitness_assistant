from typing import Annotated

from fastapi import APIRouter, Depends, Query

from fitness_assistant.schemas.stats import (
    RecentSessionResponse,
    WeeklyStatsResponse,
    WorkoutStatsResponse,
)
from fitness_assistant.web.deps import StatsSvc, get_current_user_id

router = APIRouter()


@router.get("/workout-stats", response_model=WorkoutStatsResponse)
async def get_workout_stats(
    user_id: Annotated[int, Depends(get_current_user_id)],
    stats_service: StatsSvc,
) -> WorkoutStatsResponse:
    """
    Получить общую статистику тренировок.

    Используется в HomeView для отображения карточек статистики:
    - Количество тренировок
    - Текущая серия дней подряд
    - Средняя точность
    """
    return await stats_service.get_workout_stats(user_id)


@router.get("/weekly-stats", response_model=WeeklyStatsResponse)
async def get_weekly_stats(
    user_id: Annotated[int, Depends(get_current_user_id)],
    stats_service: StatsSvc,
) -> WeeklyStatsResponse:
    """
    Получить статистику за текущую неделю.

    Используется в DashboardView для графика точности по дням.
    """
    return await stats_service.get_weekly_stats(user_id)


@router.get("/recent-sessions", response_model=list[RecentSessionResponse])
async def get_recent_sessions(
    user_id: Annotated[int, Depends(get_current_user_id)],
    stats_service: StatsSvc,
    limit: int = Query(10, ge=1, le=50),
) -> list[RecentSessionResponse]:
    """
    Получить последние тренировки пользователя.

    Используется в DashboardView для отображения списка недавних тренировок.
    """
    return await stats_service.get_recent_sessions(user_id, limit)


@router.post("/sessions/start")
async def start_session(
    user_id: Annotated[int, Depends(get_current_user_id)],
    body_part: str = "Mixed",
):
    """
    Начать новую тренировочную сессию.
    Используется когда пользователь начинает тренировку вручную.
    """
    # TODO: Реализовать создание сессии
    return {"message": "Session started", "user_id": user_id, "body_part": body_part}


@router.post("/sessions/{session_id}/end")
async def end_session(
    session_id: int,
    user_id: Annotated[int, Depends(get_current_user_id)],
    accuracy: int = 85,
):
    """
    Завершить тренировочную сессию.
    Используется когда пользователь заканчивает тренировку.
    """
    # TODO: Реализовать завершение сессии
    return {"message": "Session ended", "session_id": session_id, "accuracy": accuracy}