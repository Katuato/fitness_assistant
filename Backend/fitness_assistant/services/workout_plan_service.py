from datetime import date

from fitness_assistant.repositories.exercise_repo import ExerciseRepository
from fitness_assistant.repositories.workout_plan_repo import WorkoutPlanRepository
from fitness_assistant.schemas.workout_plan import (
    PlanExerciseCreate,
    PlanExerciseResponse,
    TodaysPlanExercise,
    TodaysPlanResponse,
    UserDailyPlanCreate,
    UserDailyPlanResponse,
)


class WorkoutPlanService:
    """Сервис для работы с планами тренировок"""

    def __init__(
        self,
        workout_plan_repo: WorkoutPlanRepository,
        exercise_repo: ExerciseRepository,
    ):
        self.workout_plan_repo = workout_plan_repo
        self.exercise_repo = exercise_repo


    async def get_todays_plan(self, user_id: int) -> TodaysPlanResponse:
        """Получить план на сегодня"""
        today = date.today()
        plan = await self.workout_plan_repo.get_user_plan_by_date(user_id, today)

        if not plan:

            return TodaysPlanResponse(
                exercises=[],
                total_exercises=0,
                completed_exercises=0,
            )

 
        exercises = []
        completed = 0

        for plan_ex in sorted(plan.exercises, key=lambda x: x.order_index):
            if plan_ex.is_completed:
                completed += 1

            target_muscles = [
                em.muscle.name for em in plan_ex.exercise.muscles
            ] if plan_ex.exercise.muscles else []

            exercises.append(
                TodaysPlanExercise(
                    id=plan_ex.id,
                    exercise_id=plan_ex.exercise_id,  # Добавлено
                    name=plan_ex.exercise.name or "Unknown",
                    sets=plan_ex.sets,
                    reps=plan_ex.reps,
                    is_completed=plan_ex.is_completed,
                    description=plan_ex.exercise.description,
                    difficulty=plan_ex.exercise.difficulty,
                    target_muscles=target_muscles,
                    image_url=plan_ex.exercise.image_url,
                )
            )

        return TodaysPlanResponse(
            exercises=exercises,
            total_exercises=len(exercises),
            completed_exercises=completed,
        )

    async def create_or_update_plan(
        self, user_id: int, data: UserDailyPlanCreate
    ) -> UserDailyPlanResponse:
        """Создать или обновить план"""
        plan_date = data.plan_date or date.today()

        plan = await self.workout_plan_repo.get_user_plan_by_date(user_id, plan_date)

        if not plan:
            plan = await self.workout_plan_repo.create_plan(user_id, plan_date)


        for idx, exercise_data in enumerate(data.exercises):
            await self.workout_plan_repo.add_exercise_to_plan(
                plan_id=plan.id,
                exercise_id=exercise_data.exercise_id,
                sets=exercise_data.sets,
                reps=exercise_data.reps,
                order_index=exercise_data.order_index or idx,
            )

        # Commit changes and refresh the plan with all relationships
        await self.workout_plan_repo.session.commit()
        plan = await self.workout_plan_repo.get_user_plan_by_date(user_id, plan_date)

        # Build response manually to avoid detached session issues
        exercises_response = []
        for plan_ex in plan.exercises:
            target_muscles = [
                em.muscle.name for em in plan_ex.exercise.muscles
            ] if plan_ex.exercise.muscles else []

            exercises_response.append(
                PlanExerciseResponse(
                    id=plan_ex.id,
                    plan_id=plan_ex.plan_id,
                    exercise_id=plan_ex.exercise_id,
                    sets=plan_ex.sets,
                    reps=plan_ex.reps,
                    order_index=plan_ex.order_index,
                    is_completed=plan_ex.is_completed,
                    completed_at=plan_ex.completed_at,
                    exercise_name=plan_ex.exercise.name if plan_ex.exercise else "Unknown",
                    exercise_description=plan_ex.exercise.description if plan_ex.exercise else None,
                    exercise_difficulty=plan_ex.exercise.difficulty if plan_ex.exercise else None,
                    exercise_image_url=plan_ex.exercise.image_url if plan_ex.exercise else None,
                    target_muscles=target_muscles,
                )
            )

        return UserDailyPlanResponse(
            id=plan.id,
            user_id=plan.user_id,
            plan_date=plan.plan_date,
            created_at=plan.created_at,
            updated_at=plan.updated_at,
            exercises=exercises_response,
        )

    async def add_exercise_to_todays_plan(
        self, user_id: int, exercise_data: PlanExerciseCreate
    ) -> TodaysPlanResponse:
        """Добавить упражнение в план на сегодня"""
        today = date.today()
        plan = await self.workout_plan_repo.get_user_plan_by_date(user_id, today)

        if not plan:
            plan = await self.workout_plan_repo.create_plan(user_id, today)
            # После создания перезагружаем план с отношениями
            plan = await self.workout_plan_repo.get_user_plan_by_date(user_id, today)

        max_order = max(
            [ex.order_index for ex in plan.exercises], default=-1
        )

        await self.workout_plan_repo.add_exercise_to_plan(
            plan_id=plan.id,
            exercise_id=exercise_data.exercise_id,
            sets=exercise_data.sets,
            reps=exercise_data.reps,
            order_index=max_order + 1,
        )

        return await self.get_todays_plan(user_id)

    async def remove_exercise_from_plan(
        self, user_id: int, plan_exercise_id: int
    ) -> TodaysPlanResponse:
        """Удалить упражнение из плана"""
        await self.workout_plan_repo.delete_plan_exercise(plan_exercise_id)
        return await self.get_todays_plan(user_id)

    async def mark_exercise_completed(
        self, user_id: int, plan_exercise_id: int, completed: bool = True
    ) -> TodaysPlanResponse:
        """Отметить упражнение как выполненное"""
        await self.workout_plan_repo.mark_exercise_completed(
            plan_exercise_id, completed
        )
        return await self.get_todays_plan(user_id)

    async def get_plan_by_date(self, user_id: int, plan_date: date) -> TodaysPlanResponse:
        """Получить план на указанную дату"""
        plan = await self.workout_plan_repo.get_user_plan_by_date(user_id, plan_date)

        if not plan:
            return TodaysPlanResponse(
                exercises=[],
                total_exercises=0,
                completed_exercises=0,
            )

        exercises = []
        completed = 0

        for plan_ex in sorted(plan.exercises, key=lambda x: x.order_index):
            if plan_ex.is_completed:
                completed += 1

            target_muscles = [
                em.muscle.name for em in plan_ex.exercise.muscles
            ] if plan_ex.exercise.muscles else []

            exercises.append(
                TodaysPlanExercise(
                    id=plan_ex.id,
                    exercise_id=plan_ex.exercise_id,
                    name=plan_ex.exercise.name or "Unknown",
                    sets=plan_ex.sets,
                    reps=plan_ex.reps,
                    is_completed=plan_ex.is_completed,
                    description=plan_ex.exercise.description,
                    difficulty=plan_ex.exercise.difficulty,
                    target_muscles=target_muscles,
                    image_url=plan_ex.exercise.image_url,
                )
            )

        return TodaysPlanResponse(
            exercises=exercises,
            total_exercises=len(exercises),
            completed_exercises=completed,
        )

    async def get_user_plans(self, user_id: int) -> list[UserDailyPlanResponse]:
        """Получить все планы пользователя"""
        plans = await self.workout_plan_repo.get_user_plans(user_id)

        result = []
        for plan in plans:
            exercises = []
            for plan_ex in sorted(plan.exercises, key=lambda x: x.order_index):
                target_muscles = [
                em.muscle.name for em in plan_ex.exercise.muscles
            ] if plan_ex.exercise.muscles else []

                exercises.append(
                    PlanExerciseResponse(
                        exercise_id=plan_ex.exercise_id,
                        sets=plan_ex.sets,
                        reps=plan_ex.reps,
                        order_index=plan_ex.order_index,
                        id=plan_ex.id,
                        plan_id=plan_ex.plan_id,
                        is_completed=plan_ex.is_completed,
                        completed_at=plan_ex.completed_at,
                        exercise_name=plan_ex.exercise.name or "Unknown",
                        exercise_description=plan_ex.exercise.description,
                        exercise_difficulty=plan_ex.exercise.difficulty,
                        exercise_image_url=plan_ex.exercise.image_url,
                        target_muscles=target_muscles
                    )
                )

            result.append(
                UserDailyPlanResponse(
                    id=plan.id,
                    user_id=plan.user_id,
                    plan_date=plan.plan_date,
                    created_at=plan.created_at,
                    updated_at=plan.updated_at,
                    exercises=exercises
                )
            )

        return result