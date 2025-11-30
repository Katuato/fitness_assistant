from datetime import datetime

from pydantic import BaseModel, ConfigDict


# Session Exercise Run schemas
class SessionExerciseRunBase(BaseModel):
    exercise_id: int | None = None


class SessionExerciseRunCreate(SessionExerciseRunBase):
    pass


class SessionExerciseRunResponse(SessionExerciseRunBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    session_id: int
    start_time: datetime
    end_time: datetime | None


# Session schemas
class SessionBase(BaseModel):
    notes: str | None = None
    device_info: dict | None = None


class SessionCreate(SessionBase):
    pass


class SessionUpdate(BaseModel):
    notes: str | None = None
    end_time: datetime | None = None


class SessionResponse(SessionBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    start_time: datetime
    end_time: datetime | None
    exercise_runs: list[SessionExerciseRunResponse] = []


class SessionListResponse(BaseModel):
    items: list[SessionResponse]
    total: int
    page: int
    size: int
