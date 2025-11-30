from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from fitness_assistant.models.exercise import (
    Equipment,
    Exercise,
    ExerciseImage,
    ExerciseMuscle,
    Muscle,
)


class ExerciseRepository:
    """Репозиторий для работы с моделью Exercise"""

    def __init__(self, session: AsyncSession) -> None:
        self.session = session

    async def get_by_id(self, exercise_id: int) -> Exercise | None:
        """Get exercise by ID with relationships."""
        result = await self.session.execute(
            select(Exercise)
            .where(Exercise.id == exercise_id)
            .options(
                selectinload(Exercise.muscles).selectinload(ExerciseMuscle.muscle),
                selectinload(Exercise.images),
            )
        )
        return result.scalar_one_or_none()

    async def get_list(
        self,
        limit: int = 20,
        offset: int = 0,
        category: str | None = None,
        level: str | None = None,
        muscle_id: int | None = None,
    ) -> list[Exercise]:
        """Получить список упражнений с опциональными фильтрами."""
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

    async def get_all_muscles(self) -> list[Muscle]:

        result = await self.session.execute(select(Muscle).order_by(Muscle.name))
        return list(result.scalars().all())

    async def get_all_equipment(self) -> list[Equipment]:

        result = await self.session.execute(select(Equipment).order_by(Equipment.name))
        return list(result.scalars().all())

    async def get_exercise_images(self, exercise_id: int) -> list[ExerciseImage]:

        result = await self.session.execute(
            select(ExerciseImage).where(ExerciseImage.exercise_id == exercise_id)
        )
        return list(result.scalars().all())
