from fastapi import APIRouter, HTTPException, Query, status

from fitness_assistant.schemas.user import (
    UserMeasurementCreate,
    UserMeasurementResponse,
    UserResponse,
    UserUpdate,
)
from fitness_assistant.web.deps import UserSvc

router = APIRouter()


@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, user_service: UserSvc) -> UserResponse:

    user = await user_service.get_user(user_id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return UserResponse.model_validate(user)


@router.patch("/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: int,
    data: UserUpdate,
    user_service: UserSvc,
) -> UserResponse:

    user = await user_service.get_user(user_id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    updated = await user_service.update_user(user, data)
    return UserResponse.model_validate(updated)


# Measurements
@router.get("/{user_id}/measurements", response_model=list[UserMeasurementResponse])
async def get_measurements(
    user_id: int,
    user_service: UserSvc,
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
) -> list[UserMeasurementResponse]:

    measurements, _ = await user_service.get_measurements(user_id, page=page, size=size)
    return [UserMeasurementResponse.model_validate(m) for m in measurements]


@router.post(
    "/{user_id}/measurements",
    response_model=UserMeasurementResponse,
    status_code=status.HTTP_201_CREATED,
)
async def add_measurement(
    user_id: int,
    data: UserMeasurementCreate,
    user_service: UserSvc,
) -> UserMeasurementResponse:

    measurement = await user_service.add_measurement(user_id, data)
    return UserMeasurementResponse.model_validate(measurement)
