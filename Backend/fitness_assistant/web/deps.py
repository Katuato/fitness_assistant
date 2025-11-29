from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from fitness_assistant.db.session import get_db
from fitness_assistant.repositories.analysis_repo import AnalysisRepository
from fitness_assistant.repositories.exercise_repo import ExerciseRepository
from fitness_assistant.repositories.media_repo import MediaRepository
from fitness_assistant.repositories.session_repo import SessionRepository
from fitness_assistant.repositories.user_repo import UserRepository
from fitness_assistant.services.analysis_service import AnalysisService
from fitness_assistant.services.exercise_service import ExerciseService
from fitness_assistant.services.media_service import MediaService
from fitness_assistant.services.session_service import SessionService
from fitness_assistant.services.user_service import UserService

# Database Session
DBSession = Annotated[AsyncSession, Depends(get_db)]


# Repositories
def get_user_repo(session: DBSession) -> UserRepository:
    return UserRepository(session)


def get_exercise_repo(session: DBSession) -> ExerciseRepository:
    return ExerciseRepository(session)


def get_session_repo(session: DBSession) -> SessionRepository:
    return SessionRepository(session)


def get_media_repo(session: DBSession) -> MediaRepository:
    return MediaRepository(session)


def get_analysis_repo(session: DBSession) -> AnalysisRepository:
    return AnalysisRepository(session)


UserRepo = Annotated[UserRepository, Depends(get_user_repo)]
ExerciseRepo = Annotated[ExerciseRepository, Depends(get_exercise_repo)]
SessionRepo = Annotated[SessionRepository, Depends(get_session_repo)]
MediaRepo = Annotated[MediaRepository, Depends(get_media_repo)]
AnalysisRepo = Annotated[AnalysisRepository, Depends(get_analysis_repo)]


# Services
def get_user_service(user_repo: UserRepo) -> UserService:
    return UserService(user_repo)


def get_exercise_service(exercise_repo: ExerciseRepo) -> ExerciseService:
    return ExerciseService(exercise_repo)


def get_session_service(session_repo: SessionRepo) -> SessionService:
    return SessionService(session_repo)


def get_media_service(media_repo: MediaRepo) -> MediaService:
    return MediaService(media_repo)


def get_analysis_service(analysis_repo: AnalysisRepo) -> AnalysisService:
    return AnalysisService(analysis_repo)


UserSvc = Annotated[UserService, Depends(get_user_service)]
ExerciseSvc = Annotated[ExerciseService, Depends(get_exercise_service)]
SessionSvc = Annotated[SessionService, Depends(get_session_service)]
MediaSvc = Annotated[MediaService, Depends(get_media_service)]
AnalysisSvc = Annotated[AnalysisService, Depends(get_analysis_service)]
