from fastapi import APIRouter, Depends, HTTPException, status

from fitness_assistant.schemas.exercise import (
    IOSCategoryResponse,
    CategorizedExerciseResponse,
    ExerciseMuscleResponse,
    ExerciseResponse,
)
from fitness_assistant.web.deps import ExerciseSvc

router = APIRouter()



@router.get("/{exercise_id}", response_model=ExerciseResponse)
async def get_exercise(exercise_id: int, exercise_service: ExerciseSvc) -> ExerciseResponse:

    exercise = await exercise_service.get_exercise(exercise_id)
    if not exercise:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Exercise not found")

    muscles = [
        ExerciseMuscleResponse.model_validate({
            "muscle_id": em.muscle_id,
            "muscle_name": em.muscle.name,
            "role": em.role,
        })
        for em in exercise.muscles
    ]

    return ExerciseResponse.model_validate({
        "id": exercise.id,
        "name": exercise.name,
        "category": exercise.category,
        "equipment": exercise.equipment,
        "force": exercise.force,
        "level": exercise.level,
        "mechanic": exercise.mechanic,
        "instructions": exercise.instructions,
        "created_at": exercise.created_at,
        "muscles": muscles,
        "images": [],
    })


# Новые эндпоинты для iOS интеграции (AddExerciseView)

@router.get("/ios/categories", response_model=list[IOSCategoryResponse])
async def get_categories_for_ios(exercise_service: ExerciseSvc) -> list[IOSCategoryResponse]:
    """Получить категории упражнений в формате iOS приложения."""
    return await exercise_service.get_categories_for_ios()


@router.get("/ios/categories/{category_name}/exercises", response_model=list[CategorizedExerciseResponse])
async def get_exercises_by_category_for_ios(
    category_name: str,
    exercise_service: ExerciseSvc
) -> list[CategorizedExerciseResponse]:
    """Получить упражнения по категории в формате iOS приложения."""
    return await exercise_service.get_exercises_by_category_for_ios(category_name)


