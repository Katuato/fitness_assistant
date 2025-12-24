from typing import Annotated

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession

from fitness_assistant.db.session import async_session_factory
from fitness_assistant.repositories.analysis_repo import AnalysisRepository
from fitness_assistant.repositories.exercise_repo import ExerciseRepository
from fitness_assistant.repositories.media_repo import MediaRepository
from fitness_assistant.repositories.session_repo import SessionRepository
from fitness_assistant.repositories.stats_repo import StatsRepository
from fitness_assistant.repositories.user_repo import UserRepository
from fitness_assistant.repositories.workout_plan_repo import WorkoutPlanRepository
from fitness_assistant.services.analysis_service import AnalysisService
from fitness_assistant.services.auth_service import AuthService
from fitness_assistant.services.exercise_service import ExerciseService
from fitness_assistant.services.media_service import MediaService
from fitness_assistant.services.session_service import SessionService
from fitness_assistant.services.stats_service import StatsService
from fitness_assistant.services.user_service import UserService
from fitness_assistant.services.workout_plan_service import WorkoutPlanService

# OAuth2 scheme
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login", auto_error=False)


# Database session dependency
async def get_db_session() -> AsyncSession:
    async with async_session_factory() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()

DBSession = Annotated[AsyncSession, Depends(get_db_session)]


# Repository dependencies
def get_user_repo(session: DBSession) -> UserRepository:
    return UserRepository(session)


def get_exercise_repo(session: DBSession) -> ExerciseRepository:
    return ExerciseRepository(session)


def get_session_repo(session: DBSession) -> SessionRepository:
    return SessionRepository(session)


def get_workout_plan_repo(session: DBSession) -> WorkoutPlanRepository:
    return WorkoutPlanRepository(session)


def get_stats_repo(session: DBSession) -> StatsRepository:
    return StatsRepository(session)


def get_media_repo(session: DBSession) -> MediaRepository:
    return MediaRepository(session)


def get_analysis_repo(session: DBSession) -> AnalysisRepository:
    return AnalysisRepository(session)


# Service dependencies
def get_auth_service(
    user_repo: Annotated[UserRepository, Depends(get_user_repo)],
) -> AuthService:
    return AuthService(user_repo)


def get_user_service(
    user_repo: Annotated[UserRepository, Depends(get_user_repo)],
) -> UserService:
    return UserService(user_repo)


def get_exercise_service(
    exercise_repo: Annotated[ExerciseRepository, Depends(get_exercise_repo)],
) -> ExerciseService:
    return ExerciseService(exercise_repo)


def get_session_service(
    session_repo: Annotated[SessionRepository, Depends(get_session_repo)],
) -> SessionService:
    return SessionService(session_repo)


def get_workout_plan_service(
    workout_plan_repo: Annotated[WorkoutPlanRepository, Depends(get_workout_plan_repo)],
    exercise_repo: Annotated[ExerciseRepository, Depends(get_exercise_repo)],
) -> WorkoutPlanService:
    return WorkoutPlanService(workout_plan_repo, exercise_repo)


def get_stats_service(
    stats_repo: Annotated[StatsRepository, Depends(get_stats_repo)],
    session_repo: Annotated[SessionRepository, Depends(get_session_repo)],
) -> StatsService:
    return StatsService(stats_repo, session_repo)


def get_media_service(
    media_repo: Annotated[MediaRepository, Depends(get_media_repo)],
) -> MediaService:
    return MediaService(media_repo)


def get_analysis_service(
    analysis_repo: Annotated[AnalysisRepository, Depends(get_analysis_repo)],
) -> AnalysisService:
    return AnalysisService(analysis_repo)


# Annotated dependencies for convenience
AuthSvc = Annotated[AuthService, Depends(get_auth_service)]
UserSvc = Annotated[UserService, Depends(get_user_service)]
ExerciseSvc = Annotated[ExerciseService, Depends(get_exercise_service)]
SessionSvc = Annotated[SessionService, Depends(get_session_service)]
WorkoutPlanSvc = Annotated[WorkoutPlanService, Depends(get_workout_plan_service)]
StatsSvc = Annotated[StatsService, Depends(get_stats_service)]
MediaSvc = Annotated[MediaService, Depends(get_media_service)]
AnalysisSvc = Annotated[AnalysisService, Depends(get_analysis_service)]


# Current user dependency
async def get_current_user_id(
    token: Annotated[str | None, Depends(oauth2_scheme)],
    auth_service: AuthSvc,
) -> int:
    """
    Получить ID текущего пользователя из JWT токена.

    Raises:
        HTTPException: Если токен отсутствует, невалиден или пользователь не найден
    """
    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated",
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        user = await auth_service.get_current_user(token)
        return user.id
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )
