from datetime import date
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status

from fitness_assistant.schemas.workout_plan import (
    PlanExerciseCreate,
    TodaysPlanResponse,
    UserDailyPlanCreate,
    UserDailyPlanResponse,
)
from fitness_assistant.services.auth_service import AuthService
from fitness_assistant.web.deps import AuthSvc, WorkoutPlanSvc, get_current_user_id

router = APIRouter()


@router.get("/today", response_model=TodaysPlanResponse)
async def get_todays_plan(
    user_id: Annotated[int, Depends(get_current_user_id)],
    workout_plan_service: WorkoutPlanSvc,
) -> TodaysPlanResponse:
    """
    Получить план тренировки на сегодня.

    Используется в HomeView для отображения списка упражнений.
    """
    return await workout_plan_service.get_todays_plan(user_id)


@router.post("/today/exercises", response_model=TodaysPlanResponse)
async def add_exercise_to_todays_plan(
    exercise_data: PlanExerciseCreate,
    user_id: Annotated[int, Depends(get_current_user_id)],
    workout_plan_service: WorkoutPlanSvc,
) -> TodaysPlanResponse:
    """
    Добавить упражнение в план на сегодня.

    Используется при добавлении упражнения через AddExerciseView.
    """
    return await workout_plan_service.add_exercise_to_todays_plan(
        user_id, exercise_data
    )


@router.delete(
    "/exercises/{plan_exercise_id}",
    response_model=TodaysPlanResponse,
)
async def remove_exercise_from_plan(
    plan_exercise_id: int,
    user_id: Annotated[int, Depends(get_current_user_id)],
    workout_plan_service: WorkoutPlanSvc,
) -> TodaysPlanResponse:
    """
    Удалить упражнение из плана.
    """
    return await workout_plan_service.remove_exercise_from_plan(
        user_id, plan_exercise_id
    )


@router.patch(
    "/exercises/{plan_exercise_id}/complete",
    response_model=TodaysPlanResponse,
)
async def mark_exercise_completed(
    plan_exercise_id: int,
    user_id: Annotated[int, Depends(get_current_user_id)],
    workout_plan_service: WorkoutPlanSvc,
    completed: bool = True,
) -> TodaysPlanResponse:
    """
    Отметить упражнение как выполненное/невыполненное.
    """
    return await workout_plan_service.mark_exercise_completed(
        user_id, plan_exercise_id, completed
    )


@router.post("", response_model=UserDailyPlanResponse)
async def create_plan(
    plan_data: UserDailyPlanCreate,
    user_id: Annotated[int, Depends(get_current_user_id)],
    workout_plan_service: WorkoutPlanSvc,
) -> UserDailyPlanResponse:
    """
    Создать план тренировки на определенный день.

    Если plan_date не указан, создается план на сегодня.
    """
    return await workout_plan_service.create_or_update_plan(user_id, plan_data)


@router.get("/date/{plan_date}", response_model=TodaysPlanResponse)
async def get_plan_by_date(
    plan_date: date,
    user_id: Annotated[int, Depends(get_current_user_id)],
    workout_plan_service: WorkoutPlanSvc,
) -> TodaysPlanResponse:
    """
    Получить план тренировки на указанную дату.
    """
    return await workout_plan_service.get_plan_by_date(user_id, plan_date)


@router.get("", response_model=list[UserDailyPlanResponse])
async def get_user_plans(
    user_id: Annotated[int, Depends(get_current_user_id)],
    workout_plan_service: WorkoutPlanSvc,
) -> list[UserDailyPlanResponse]:
    """
    Получить все планы тренировок пользователя.
    """
    return await workout_plan_service.get_user_plans(user_id)

