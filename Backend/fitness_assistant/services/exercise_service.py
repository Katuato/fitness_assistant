from fitness_assistant.models.exercise import Equipment, Exercise, Muscle
from fitness_assistant.repositories.exercise_repo import ExerciseRepository


class ExerciseService:

    def __init__(self, exercise_repo: ExerciseRepository) -> None:
        self.exercise_repo = exercise_repo

    async def get_exercise(self, exercise_id: int) -> Exercise | None:

        return await self.exercise_repo.get_by_id(exercise_id)

    async def get_exercises(
        self,
        page: int = 1,
        size: int = 20,
        category: str | None = None,
        level: str | None = None,
        muscle_id: int | None = None,
    ) -> tuple[list[Exercise], int]:

        offset = (page - 1) * size
        exercises = await self.exercise_repo.get_list(
            limit=size,
            offset=offset,
            category=category,
            level=level,
            muscle_id=muscle_id,
        )
        total = await self.exercise_repo.count(
            category=category,
            level=level,
            muscle_id=muscle_id,
        )
        return exercises, total

    async def get_all_muscles(self) -> list[Muscle]:
        return await self.exercise_repo.get_all_muscles()

    async def get_all_equipment(self) -> list[Equipment]:
        return await self.exercise_repo.get_all_equipment()
