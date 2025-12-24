from datetime import date, datetime

from sqlalchemy import and_, func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload, selectinload

from fitness_assistant.models.exercise import Exercise, ExerciseMuscle
from fitness_assistant.models.workout_plan import PlanExercise, UserDailyPlan


class WorkoutPlanRepository:

    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_user_plan_by_date(
        self, user_id: int, plan_date: date
    ) -> UserDailyPlan | None:
        stmt = (
            select(UserDailyPlan)
            .where(
                and_(
                    UserDailyPlan.user_id == user_id,
                    UserDailyPlan.plan_date == plan_date,
                )
            )
            .options(
                selectinload(UserDailyPlan.exercises)
                .selectinload(PlanExercise.exercise)
                .selectinload(Exercise.muscles)
                .selectinload(ExerciseMuscle.muscle)
            )
        )
        result = await self.session.execute(stmt)
        return result.scalar_one_or_none()

    async def create_plan(self, user_id: int, plan_date: date) -> UserDailyPlan:
        plan = UserDailyPlan(user_id=user_id, plan_date=plan_date)
        self.session.add(plan)
        await self.session.flush()
        await self.session.refresh(plan)
        return plan

    async def add_exercise_to_plan(
        self, plan_id: int, exercise_id: int, sets: int, reps: int, order_index: int
    ) -> PlanExercise:
        plan_exercise = PlanExercise(
            plan_id=plan_id,
            exercise_id=exercise_id,
            sets=sets,
            reps=reps,
            order_index=order_index,
        )
        self.session.add(plan_exercise)
        await self.session.flush()
        await self.session.refresh(
            plan_exercise,
            attribute_names=["exercise"]
        )
        return plan_exercise

    async def delete_plan_exercise(self, plan_exercise_id: int) -> None:
        stmt = select(PlanExercise).where(PlanExercise.id == plan_exercise_id)
        result = await self.session.execute(stmt)
        plan_exercise = result.scalar_one_or_none()
        if plan_exercise:
            await self.session.delete(plan_exercise)
            await self.session.flush()

    async def mark_exercise_completed(
        self, plan_exercise_id: int, completed: bool = True
    ) -> PlanExercise | None:
        stmt = select(PlanExercise).where(PlanExercise.id == plan_exercise_id)
        result = await self.session.execute(stmt)
        plan_exercise = result.scalar_one_or_none()

        if plan_exercise:
            plan_exercise.is_completed = completed
            plan_exercise.completed_at = datetime.utcnow() if completed else None
            await self.session.flush()
            await self.session.refresh(plan_exercise)

        return plan_exercise

    async def get_user_plans(self, user_id: int) -> list[UserDailyPlan]:
        """Получить все планы пользователя"""
        stmt = (
            select(UserDailyPlan)
            .where(UserDailyPlan.user_id == user_id)
            .order_by(UserDailyPlan.plan_date.desc())
            .options(
                selectinload(UserDailyPlan.exercises)
                .selectinload(PlanExercise.exercise)
                .selectinload(Exercise.muscles)
                .selectinload(ExerciseMuscle.muscle)
            )
        )
        result = await self.session.execute(stmt)
        return list(result.scalars().all())