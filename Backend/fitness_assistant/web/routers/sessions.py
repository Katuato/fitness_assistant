from fastapi import APIRouter, HTTPException, Query, status

from fitness_assistant.schemas.session import (
    SessionCreate,
    SessionExerciseRunCreate,
    SessionExerciseRunResponse,
    SessionListResponse,
    SessionResponse,
    SessionUpdate,
)
from fitness_assistant.web.deps import SessionSvc

router = APIRouter()


@router.get("", response_model=SessionListResponse)
async def list_sessions(
    session_service: SessionSvc,
    user_id: int = Query(..., description="User ID"),
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
) -> SessionListResponse:

    sessions, total = await session_service.get_user_sessions(user_id, page=page, size=size)
    items = [SessionResponse.model_validate(s) for s in sessions]
    return SessionListResponse(items=items, total=total, page=page, size=size)


@router.post("", response_model=SessionResponse, status_code=status.HTTP_201_CREATED)
async def create_session(
    data: SessionCreate,
    session_service: SessionSvc,
    user_id: int = Query(..., description="User ID"),
) -> SessionResponse:

    session = await session_service.create_session(user_id, data)
    return SessionResponse.model_validate(session)


@router.get("/{session_id}", response_model=SessionResponse)
async def get_session(session_id: int, session_service: SessionSvc) -> SessionResponse:

    session = await session_service.session_repo.get_by_id(session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    return SessionResponse.model_validate(session)


@router.patch("/{session_id}", response_model=SessionResponse)
async def update_session(
    session_id: int,
    data: SessionUpdate,
    session_service: SessionSvc,
) -> SessionResponse:

    session = await session_service.session_repo.get_by_id(session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    updated = await session_service.update_session(session, data)
    return SessionResponse.model_validate(updated)


@router.delete("/{session_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_session(session_id: int, session_service: SessionSvc) -> None:

    session = await session_service.session_repo.get_by_id(session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    await session_service.delete_session(session)


# Exercise Runs
@router.post(
    "/{session_id}/runs",
    response_model=SessionExerciseRunResponse,
    status_code=status.HTTP_201_CREATED,
)
async def add_exercise_run(
    session_id: int,
    data: SessionExerciseRunCreate,
    session_service: SessionSvc,
) -> SessionExerciseRunResponse:

    session = await session_service.session_repo.get_by_id(session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    run = await session_service.add_exercise_run(session_id, data)
    return SessionExerciseRunResponse.model_validate(run)
