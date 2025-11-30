from fitness_assistant.enums.analysis_enums import AnalysisStatus
from fitness_assistant.enums.exercise_enums import (
    ExerciseForce,
    ExerciseLevel,
    ExerciseMechanic,
    MuscleRole,
)
from fitness_assistant.enums.media_enums import MediaType
from fitness_assistant.enums.user_enums import UserGender, UserRole
from fitness_assistant.schemas.analysis import (
    AnalysisResultResponse,
    AnalysisTaskCreate,
    AnalysisTaskResponse,
    AnalysisTaskWithResultResponse,
)
from fitness_assistant.schemas.base import (
    PaginatedResponse,
    PaginationParams,
)
from fitness_assistant.schemas.exercise import (
    EquipmentResponse,
    ExerciseListResponse,
    ExerciseResponse,
    MuscleResponse,
)
from fitness_assistant.schemas.media import (
    MediaCreate,
    MediaListResponse,
    MediaResponse,
    MediaUploadResponse,
)
from fitness_assistant.schemas.session import (
    SessionCreate,
    SessionExerciseRunCreate,
    SessionExerciseRunResponse,
    SessionListResponse,
    SessionResponse,
    SessionUpdate,
)
from fitness_assistant.schemas.user import (
    UserCreate,
    UserMeasurementCreate,
    UserMeasurementResponse,
    UserResponse,
    UserUpdate,
)

__all__ = [
    # Enums
    "AnalysisStatus",
    "ExerciseForce",
    "ExerciseLevel",
    "ExerciseMechanic",
    "MediaType",
    "MuscleRole",
    "UserGender",
    "UserRole",
    # User schemas
    "UserCreate",
    "UserUpdate",
    "UserResponse",
    "UserMeasurementCreate",
    "UserMeasurementResponse",
    # Exercise schemas
    "ExerciseResponse",
    "ExerciseListResponse",
    "MuscleResponse",
    "EquipmentResponse",
    # Session schemas
    "SessionCreate",
    "SessionUpdate",
    "SessionResponse",
    "SessionListResponse",
    "SessionExerciseRunCreate",
    "SessionExerciseRunResponse",
    # Media schemas
    "MediaCreate",
    "MediaResponse",
    "MediaListResponse",
    "MediaUploadResponse",
    # Analysis schemas
    "AnalysisTaskCreate",
    "AnalysisTaskResponse",
    "AnalysisResultResponse",
    "AnalysisTaskWithResultResponse",
    # Common schemas
    "PaginationParams",
    "PaginatedResponse",
]
