from datetime import date, datetime, time, timedelta

from sqlalchemy import and_, func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import joinedload, selectinload

from fitness_assistant.models.exercise import Exercise, ExerciseMuscle
from fitness_assistant.models.session import Session, SessionExerciseRun
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

            if completed:
                # Отмечаем время выполнения
                completed_at = datetime.utcnow()
                plan_exercise.completed_at = completed_at

                # Создаем запись в сессии
                try:
                    # Получаем план для определения даты
                    stmt = select(UserDailyPlan).where(UserDailyPlan.id == plan_exercise.plan_id)
                    result = await self.session.execute(stmt)
                    daily_plan = result.scalar_one_or_none()

                    if daily_plan:
                        print(f"DEBUG: Found daily plan {daily_plan.id} for date {daily_plan.plan_date}")
                        # Создаем/получаем сессию на эту дату
                        session = await self.get_or_create_daily_session(daily_plan.user_id, daily_plan.plan_date)
                        print(f"DEBUG: Using session {session.id} for user {daily_plan.user_id} on {daily_plan.plan_date}")

                        # Добавляем упражнение в сессию
                        exercise_run = await self.add_exercise_to_session(session.id, plan_exercise.exercise_id, completed_at)
                        print(f"DEBUG: Added exercise {plan_exercise.exercise_id} to session {session.id}")

                        # Обновляем статистику сессии
                        await self.update_session_stats(session.id)
                        print(f"DEBUG: Updated session stats for session {session.id}")

                    else:
                        print(f"Warning: Daily plan not found for plan_exercise {plan_exercise.id}")

                except Exception as e:
                    # Логируем ошибку, но не прерываем основную операцию
                    print(f"ERROR: Failed to create session record: {e}")
                    import traceback
                    traceback.print_exc()
            else:
                plan_exercise.completed_at = None

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

    async def get_or_create_daily_session(self, user_id: int, session_date: date) -> Session:
        """Получить или создать сессию на указанную дату"""
        # Ищем сессию на эту дату (сравниваем только дату, без времени)
        start_of_day = datetime.combine(session_date, datetime.min.time())
        end_of_day = datetime.combine(session_date, datetime.max.time())

        stmt = select(Session).where(
            Session.user_id == user_id,
            Session.start_time >= start_of_day,
            Session.start_time <= end_of_day
        )
        result = await self.session.execute(stmt)
        session = result.scalar_one_or_none()

        if not session:
            print(f"DEBUG: Creating new session for user {user_id} on {session_date}")
            # Создаем новую сессию
            session = Session(
                user_id=user_id,
                start_time=datetime.combine(session_date, time(9, 0)),  # 9:00 утра
                body_part="Mixed",  # Определим позже по упражнениям
                device_info={"device": "iOS App", "app_version": "1.0.0"}
            )
            self.session.add(session)
            await self.session.flush()
            print(f"DEBUG: Created session {session.id}")
        else:
            print(f"DEBUG: Found existing session {session.id} for user {user_id} on {session_date}")

        return session

    async def add_exercise_to_session(self, session_id: int, exercise_id: int, completed_at: datetime) -> SessionExerciseRun:
        """Добавить упражнение в сессию"""
        exercise_run = SessionExerciseRun(
            session_id=session_id,
            exercise_id=exercise_id,
            start_time=completed_at - timedelta(minutes=5),  # Предполагаем 5 минут на упражнение
            end_time=completed_at
        )
        self.session.add(exercise_run)
        await self.session.flush()
        return exercise_run

    async def update_session_stats(self, session_id: int) -> None:
        """Обновить статистику сессии на основе выполненных упражнений"""
        # Подсчитываем упражнения и обновляем end_time
        stmt = select(SessionExerciseRun).where(SessionExerciseRun.session_id == session_id)
        result = await self.session.execute(stmt)
        exercise_runs = result.scalars().all()

        if exercise_runs:
            # Обновляем end_time на время последнего упражнения
            latest_end_time = max(run.end_time for run in exercise_runs)

            stmt = select(Session).where(Session.id == session_id)
            result = await self.session.execute(stmt)
            session = result.scalar_one()

            session.end_time = latest_end_time
            # Для простоты ставим точность 85% для завершенных упражнений
            session.accuracy = 85

            await self.session.flush()