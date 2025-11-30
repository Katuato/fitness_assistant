from datetime import datetime

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from fitness_assistant.models.session import Session, SessionExerciseRun


class SessionRepository:
    """Репозиторий для работы с моделью Session"""

    def __init__(self, session: AsyncSession) -> None:
        self.session = session

    async def get_by_id(self, session_id: int) -> Session | None:

        result = await self.session.execute(
            select(Session)
            .where(Session.id == session_id)
            .options(selectinload(Session.exercise_runs))
        )
        return result.scalar_one_or_none()

    async def get_list(self, user_id: int, limit: int = 20, offset: int = 0) -> list[Session]:

        result = await self.session.execute(
            select(Session)
            .where(Session.user_id == user_id)
            .options(selectinload(Session.exercise_runs))
            .order_by(Session.start_time.desc())
            .limit(limit)
            .offset(offset)
        )
        return list(result.scalars().all())

    async def count(self, user_id: int) -> int:
        """Посчитать количество тренировочных сессий пользователя."""
        result = await self.session.execute(
            select(func.count()).select_from(Session).where(Session.user_id == user_id)
        )
        return result.scalar() or 0

    async def create(self, session: Session) -> Session:

        self.session.add(session)
        await self.session.flush()
        await self.session.refresh(session)
        return session

    async def update(
        self, session: Session, **kwargs: str | int | float | datetime | dict | None
    ) -> Session:

        for key, value in kwargs.items():
            if value is not None:
                setattr(session, key, value)
        await self.session.flush()
        await self.session.refresh(session)
        return session

    async def delete(self, session: Session) -> None:

        await self.session.delete(session)
        await self.session.flush()

    async def add_exercise_run(self, run: SessionExerciseRun) -> SessionExerciseRun:

        self.session.add(run)
        await self.session.flush()
        await self.session.refresh(run)
        return run

    async def get_exercise_runs(self, session_id: int) -> list[SessionExerciseRun]:

        result = await self.session.execute(
            select(SessionExerciseRun)
            .where(SessionExerciseRun.session_id == session_id)
            .order_by(SessionExerciseRun.start_time)
        )
        return list(result.scalars().all())
