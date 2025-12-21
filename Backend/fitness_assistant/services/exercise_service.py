from fitness_assistant.models.exercise import Exercise
from fitness_assistant.repositories.exercise_repo import ExerciseRepository
from fitness_assistant.schemas.exercise import (
    IOSCategoryResponse,
    CategorizedExerciseResponse,
)


class ExerciseService:

    def __init__(self, exercise_repo: ExerciseRepository) -> None:
        self.exercise_repo = exercise_repo

    async def get_exercise(self, exercise_id: int) -> Exercise | None:

        return await self.exercise_repo.get_by_id(exercise_id)


    async def get_exercises_with_muscles(
        self,
        page: int = 1,
        size: int = 20,
        category: str | None = None,
        level: str | None = None,
        muscle_id: int | None = None,
    ) -> tuple[list[Exercise], int]:

        offset = (page - 1) * size
        exercises = await self.exercise_repo.get_list_with_muscles(
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


    async def get_categories(self) -> list[str]:
        """Получить список уникальных категорий упражнений."""
        return await self.exercise_repo.get_categories()

    async def get_categories_for_ios(self) -> list[IOSCategoryResponse]:
        """Получить категории в формате iOS приложения."""
        categories = await self.get_categories()

        # Маппинг категорий на iOS формат
        category_mapping = {
            "biceps": ("Biceps", "figure.strengthtraining.traditional", "#E47E18"),
            "chest": ("Chest", "figure.strengthtraining.functional", "#39D963"),
            "legs": ("Legs", "figure.walk", "#007AFF"),
            "back": ("Back", "figure.cooldown", "#8E8E93"),
            "shoulders": ("Shoulders", "figure.flexibility", "#FF9500"),
            "core": ("Core", "figure.core.training", "#FF3B30"),
            "full_body": ("Full Body", "figure.mixed.cardio", "#AF52DE"),
            "arms": ("Biceps", "figure.strengthtraining.traditional", "#E47E18"),  # fallback
        }

        result = []
        for category in categories:
            name, icon, color = category_mapping.get(
                category,
                (category.title(), "figure.strengthtraining.functional", "#8E8E93")
            )

            result.append(IOSCategoryResponse(
                id=f"cat_{category}",  # Создаем UUID-like ID
                name=name,
                icon=icon,
                color=color
            ))

        return result

    async def get_exercises_by_category_for_ios(self, category: str) -> list[CategorizedExerciseResponse]:
        """Получить упражнения по категории в формате iOS."""
        # Маппинг iOS названий категорий в формат базы данных
        category_mapping = {
            "Biceps": "biceps",
            "Chest": "chest",
            "Legs": "legs",
            "Back": "back",
            "Shoulders": "shoulders",
            "Core": "core",
            "Full Body": "full body",
        }

        db_category = category_mapping.get(category, category.lower())
        exercises, _ = await self.get_exercises_with_muscles(category=db_category)

        result = []
        for exercise in exercises:
            # Получаем target muscles
            target_muscles = [
                em.muscle.name for em in exercise.muscles
            ] if exercise.muscles else []

            # Парсим инструкции из JSON
            instructions = []
            if exercise.instructions:
                if isinstance(exercise.instructions, list):
                    instructions = exercise.instructions
                elif isinstance(exercise.instructions, str):
                    # Если инструкции - строка, пробуем распарсить как JSON
                    try:
                        import json
                        instructions = json.loads(exercise.instructions)
                    except:
                        instructions = [exercise.instructions]

            result.append(CategorizedExerciseResponse(
                id=exercise.id,
                name=exercise.name or "",
                category=exercise.category.title() if exercise.category else "",
                target_muscles=target_muscles,
                description=exercise.description,
                instructions=instructions,
                sets=exercise.default_sets,
                reps=exercise.default_reps,
                difficulty=exercise.difficulty,
                estimated_duration=exercise.estimated_duration,
                calories_burn=exercise.calories_burn,
                image_url=exercise.image_url
            ))

        return result
