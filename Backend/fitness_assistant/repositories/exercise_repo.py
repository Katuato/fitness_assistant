from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from fitness_assistant.models.exercise import (
    Exercise,
    ExerciseMuscle,
    Muscle,
)


class ExerciseRepository:
    """Репозиторий для работы с моделью Exercise"""

    def __init__(self, session: AsyncSession) -> None:
        self.session = session

    async def get_by_id(self, exercise_id: int) -> Exercise | None:
        result = await self.session.execute(
            select(Exercise)
            .where(Exercise.id == exercise_id)
            .options(
                selectinload(Exercise.muscles).selectinload(ExerciseMuscle.muscle),
                selectinload(Exercise.images),
            )
        )
        return result.scalar_one_or_none()

    async def get_list_with_muscles(
        self,
        limit: int = 20,
        offset: int = 0,
        category: str | None = None,
        level: str | None = None,
        muscle_id: int | None = None,
    ) -> list[Exercise]:
        """Получить список упражнений с загрузкой связанных данных (muscles)."""
        query = select(Exercise).options(
            selectinload(Exercise.muscles).selectinload(ExerciseMuscle.muscle),
            selectinload(Exercise.images),
        )

        if category:
            query = query.where(Exercise.category == category)
        if level:
            query = query.where(Exercise.level == level)
        if muscle_id:
            query = query.join(Exercise.muscles).where(ExerciseMuscle.muscle_id == muscle_id)

        query = query.limit(limit).offset(offset)
        result = await self.session.execute(query)
        return list(result.scalars().unique().all())

    async def count(
        self,
        category: str | None = None,
        level: str | None = None,
        muscle_id: int | None = None,
    ) -> int:
        """Посчитать количество упражнений с опциональными фильтрами."""
        query = select(func.count()).select_from(Exercise)

        if category:
            query = query.where(Exercise.category == category)
        if level:
            query = query.where(Exercise.level == level)
        if muscle_id:
            query = query.join(Exercise.muscles).where(ExerciseMuscle.muscle_id == muscle_id)

        result = await self.session.execute(query)
        return result.scalar() or 0

    async def get_categories(self) -> list[str]:
        """Получить список уникальных категорий упражнений."""
        result = await self.session.execute(
            select(Exercise.category)
            .where(Exercise.category.is_not(None))
            .distinct()
            .order_by(Exercise.category)
        )
        return [row[0] for row in result.all()]