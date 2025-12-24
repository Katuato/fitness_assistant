from datetime import date, datetime, timedelta

from sqlalchemy import and_, func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from fitness_assistant.models.session import Session


class StatsRepository:

    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_workout_count(self, user_id: int) -> int:
        stmt = select(func.count(Session.id)).where(
            and_(Session.user_id == user_id, Session.end_time.is_not(None))
        )
        result = await self.session.execute(stmt)
        return result.scalar() or 0

    async def get_current_streak(self, user_id: int) -> int:
        # Получаем все даты тренировок (только дату, без времени)
        stmt = (
            select(func.date(Session.start_time).label("workout_date"))
            .where(
                and_(Session.user_id == user_id, Session.end_time.is_not(None))
            )
            .distinct()
            .order_by(func.date(Session.start_time).desc())
        )
        result = await self.session.execute(stmt)
        workout_dates = [row.workout_date for row in result.all()]

        if not workout_dates:
            return 0

        # Проверяем серию
        today = date.today()
        yesterday = today - timedelta(days=1)

        # Если последняя тренировка не сегодня и не вчера - серия прервана
        if workout_dates[0] not in (today, yesterday):
            return 0

        streak = 0
        expected_date = today if workout_dates[0] == today else yesterday

        for workout_date in workout_dates:
            if workout_date == expected_date:
                streak += 1
                expected_date -= timedelta(days=1)
            else:
                break

        return streak

    async def get_average_accuracy(self, user_id: int) -> int:
        """Средняя точность тренировок"""
        stmt = select(func.avg(Session.accuracy)).where(
            and_(
                Session.user_id == user_id,
                Session.accuracy.is_not(None),
                Session.end_time.is_not(None),
            )
        )
        result = await self.session.execute(stmt)
        avg = result.scalar()
        return int(avg) if avg else 0

    async def get_weekly_accuracies(
        self, user_id: int, start_date: date
    ) -> list[tuple[date, float]]:
        """Точность по дням за неделю"""
        end_date = start_date + timedelta(days=7)

        stmt = (
            select(
                func.date(Session.start_time).label("workout_date"),
                func.avg(Session.accuracy).label("avg_accuracy"),
            )
            .where(
                and_(
                    Session.user_id == user_id,
                    Session.accuracy.is_not(None),
                    func.date(Session.start_time) >= start_date,
                    func.date(Session.start_time) < end_date,
                )
            )
            .group_by(func.date(Session.start_time))
            .order_by(func.date(Session.start_time))
        )

        result = await self.session.execute(stmt)
        return [(row.workout_date, float(row.avg_accuracy)) for row in result.all()]

    async def get_recent_sessions(
        self, user_id: int, limit: int = 10
    ) -> list[Session]:
        """Получить последние тренировки"""
        stmt = (
            select(Session)
            .where(
                and_(Session.user_id == user_id, Session.end_time.is_not(None))
            )
            .options(selectinload(Session.exercise_runs))
            .order_by(Session.start_time.desc())
            .limit(limit)
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())