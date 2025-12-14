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

    async def get_by_name(self, name: str) -> User | None:
        result = await self.session.execute(select(User).where(User.name == name))
        return result.scalar_one_or_none()

    async def get_by_email_or_name(self, identifier: str) -> User | None:
        result = await self.session.execute(
            select(User).where((User.email == identifier) | (User.name == identifier))
        )
        return result.scalar_one_or_none()

    async def create(self, user: User) -> User:
        self.session.add(user)
        await self.session.flush()
        await self.session.refresh(user)
        return user

    async def update(self, user: User, name: str | None = None, birth_date: str | None = None,
                    gender: str | None = None, locale: str | None = None,
                    last_login: bool = False) -> User:
        """
        Обновляет пользователя.

        Разрешено обновлять только безопасные поля профиля.
        last_login обновляется автоматически при аутентификации.
        """
        # Обновляем только разрешенные поля
        if name is not None:
            user.name = name
        if birth_date is not None:
            user.birth_date = birth_date
        if gender is not None:
            user.gender = gender
        if locale is not None:
            user.locale = locale
        if last_login:
            # Импортируем здесь чтобы избежать circular imports
            from datetime import datetime, timezone
            user.last_login = datetime.now(timezone.utc)

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
