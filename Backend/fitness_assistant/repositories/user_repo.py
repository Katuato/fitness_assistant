"""Репозиторий для работы с пользователями."""

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from fitness_assistant.models.user import User, UserMeasurement


class UserRepository:

    def __init__(self, session: AsyncSession) -> None:
        self.session = session

    async def get_by_id(self, user_id: int) -> User | None:
        result = await self.session.execute(select(User).where(User.id == user_id))
        return result.scalar_one_or_none()

    async def get_by_email(self, email: str) -> User | None:
        result = await self.session.execute(select(User).where(User.email == email))
        return result.scalar_one_or_none()

    async def create(self, user: User) -> User:
        self.session.add(user)
        await self.session.flush()
        await self.session.refresh(user)
        return user

    async def update(self, user: User, **kwargs: str | int | float | None) -> User:
        for key, value in kwargs.items():
            if value is not None:
                setattr(user, key, value)
        await self.session.flush()
        await self.session.refresh(user)
        return user

    async def delete(self, user: User) -> None:
        await self.session.delete(user)
        await self.session.flush()

    async def get_measurements(
        self, user_id: int, limit: int = 20, offset: int = 0
    ) -> list[UserMeasurement]:
        """Get user measurements."""
        result = await self.session.execute(
            select(UserMeasurement)
            .where(UserMeasurement.user_id == user_id)
            .order_by(UserMeasurement.measured_at.desc())
            .limit(limit)
            .offset(offset)
        )
        return list(result.scalars().all())

    async def create_measurement(self, measurement: UserMeasurement) -> UserMeasurement:
        """Create new measurement."""
        self.session.add(measurement)
        await self.session.flush()
        await self.session.refresh(measurement)
        return measurement

    async def count_measurements(self, user_id: int) -> int:
        """Count user measurements."""
        result = await self.session.execute(
            select(func.count())
            .select_from(UserMeasurement)
            .where(UserMeasurement.user_id == user_id)
        )
        return result.scalar() or 0
