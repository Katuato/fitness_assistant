from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field, computed_field


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
    accuracy: int | None = Field(None, ge=0, le=100)
    body_part: str | None = None


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


    @computed_field
    @property
    def total_time_minutes(self) -> int | None:
        """Длительность тренировки в минутах"""
        if self.end_time and self.start_time:
            delta = self.end_time - self.start_time
            return int(delta.total_seconds() / 60)
        return None


class SessionListResponse(BaseModel):
    items: list[SessionResponse]
    total: int
    page: int
    size: int
