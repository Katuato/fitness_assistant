from fastapi import APIRouter, HTTPException, Query, status

from fitness_assistant.schemas.base import PaginatedResponse, PaginationParams
from fitness_assistant.schemas.exercise import (
    EquipmentResponse,
    ExerciseMuscleResponse,
    ExerciseResponse,
    MuscleResponse,
)
from fitness_assistant.web.deps import ExerciseSvc

router = APIRouter()


@router.get("", response_model=PaginatedResponse[ExerciseResponse])
async def list_exercises(
    exercise_service: ExerciseSvc,
    params: PaginationParams = Query(),
    category: str | None = Query(None),
    level: str | None = Query(None),
    muscle_id: int | None = Query(None),
) -> PaginatedResponse[ExerciseResponse]:

    exercises, total = await exercise_service.get_exercises(
        page=params.page,
        size=params.size,
        category=category,
        level=level,
        muscle_id=muscle_id,
    )

    items = []
    for ex in exercises:
        muscles = [
            ExerciseMuscleResponse.model_validate({
                "muscle_id": em.muscle_id,
                "muscle_name": em.muscle.name,
                "role": em.role,
            })
            for em in ex.muscles
        ]
        items.append(
            ExerciseResponse.model_validate({
                "id": ex.id,
                "name": ex.name,
                "category": ex.category,
                "equipment": ex.equipment,
                "force": ex.force,
                "level": ex.level,
                "mechanic": ex.mechanic,
                "instructions": ex.instructions,
                "created_at": ex.created_at,
                "muscles": muscles,
                "images": [],
            })
        )

    return PaginatedResponse[ExerciseResponse](
        items=items, total=total, page=params.page, size=params.size
    )


@router.get("/muscles", response_model=list[MuscleResponse])
async def list_muscles(exercise_service: ExerciseSvc) -> list[MuscleResponse]:

    muscles = await exercise_service.get_all_muscles()
    return [MuscleResponse.model_validate(m) for m in muscles]


@router.get("/equipment", response_model=list[EquipmentResponse])
async def list_equipment(exercise_service: ExerciseSvc) -> list[EquipmentResponse]:

    equipment = await exercise_service.get_all_equipment()
    return [EquipmentResponse.model_validate(e) for e in equipment]


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
