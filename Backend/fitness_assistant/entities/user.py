from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field


class UserGender(str, Enum):
    MALE = "male"
    FEMALE = "female"
    OTHER = "other"


class UserRole(str, Enum):
    USER = "user"
    ADMIN = "admin"


class UserBase(BaseModel):
    name: str | None = None
    birth_date: str | None = None
    gender: str | None = None
    locale: str | None = None


class UserCreate(UserBase):
    email: str
    password: str = Field(min_length=6)


class UserUpdate(BaseModel):
    name: str | None = None
    birth_date: str | None = None
    gender: str | None = None
    locale: str | None = None


class UserResponse(UserBase):
    id: int
    email: str
    role: str | None
    created_at: datetime | None
    last_login: datetime | None

    class Config:
        from_attributes = True


# User Measurement schemas
class UserMeasurementBase(BaseModel):
    weight: str | None = None
    height: str | None = None


class UserMeasurementCreate(UserMeasurementBase):
    pass


class UserMeasurementResponse(UserMeasurementBase):
    id: int
    user_id: int
    measured_at: datetime

    class Config:
        from_attributes = True
