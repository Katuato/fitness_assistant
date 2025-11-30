from fitness_assistant.models.session import Session, SessionExerciseRun
from fitness_assistant.repositories.session_repo import SessionRepository
from fitness_assistant.schemas.session import (
    SessionCreate,
    SessionExerciseRunCreate,
    SessionUpdate,
)


class SessionService:
    def __init__(self, session_repo: SessionRepository) -> None:
        self.session_repo = session_repo

    async def get_user_sessions(
        self, user_id: int, page: int = 1, size: int = 20
    ) -> tuple[list[Session], int]:
        offset = (page - 1) * size
        sessions = await self.session_repo.get_list(user_id, limit=size, offset=offset)
        total = await self.session_repo.count(user_id)
        return sessions, total

    async def create_session(self, user_id: int, data: SessionCreate) -> Session:
        session = Session(
            user_id=user_id,
            notes=data.notes,
            device_info=data.device_info,
        )
        return await self.session_repo.create(session)

    async def update_session(self, session: Session, data: SessionUpdate) -> Session:
        update_data = data.model_dump(exclude_unset=True)
        return await self.session_repo.update(session, **update_data)

    async def delete_session(self, session: Session) -> None:
        await self.session_repo.delete(session)

    async def add_exercise_run(
        self, session_id: int, data: SessionExerciseRunCreate
    ) -> SessionExerciseRun:
        run = SessionExerciseRun(
            session_id=session_id,
            exercise_id=data.exercise_id,
        )
        return await self.session_repo.add_exercise_run(run)
