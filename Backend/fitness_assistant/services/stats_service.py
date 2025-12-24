from datetime import date, datetime, timedelta

from fitness_assistant.repositories.session_repo import SessionRepository
from fitness_assistant.repositories.stats_repo import StatsRepository
from fitness_assistant.schemas.stats import (
    DayAccuracy,
    RecentSessionResponse,
    WeeklyStatsResponse,
    WorkoutStatsResponse,
)


class StatsService:
    """Сервис для статистики тренировок"""

    def __init__(
        self,
        stats_repo: StatsRepository,
        session_repo: SessionRepository,
    ):
        self.stats_repo = stats_repo
        self.session_repo = session_repo

    async def get_workout_stats(self, user_id: int) -> WorkoutStatsResponse:
        """Получить общую статистику тренировок"""
        workouts_count = await self.stats_repo.get_workout_count(user_id)
        day_streak = await self.stats_repo.get_current_streak(user_id)
        accuracy = await self.stats_repo.get_average_accuracy(user_id)

        return WorkoutStatsResponse(
            workouts_count=workouts_count,
            day_streak=day_streak,
            accuracy=accuracy,
        )

    async def get_weekly_stats(self, user_id: int) -> WeeklyStatsResponse:
        """Получить статистику за неделю"""
   
        today = date.today()
        weekday = today.weekday()  # 0 = Monday
        start_of_week = today - timedelta(days=weekday)

       
        week_data = await self.stats_repo.get_weekly_accuracies(
            user_id, start_of_week
        )

   
        accuracy_by_date = {d: acc for d, acc in week_data}

     
        day_names = ["M", "T", "W", "Th", "F", "S", "Su"]
        daily_accuracies = []

        for i in range(7):
            current_date = start_of_week + timedelta(days=i)
            accuracy = accuracy_by_date.get(current_date, 0.0)

            daily_accuracies.append(
                DayAccuracy(day=day_names[i], accuracy=accuracy)
            )

        # Средняя точность
        accuracies = [acc for _, acc in week_data]
        average_accuracy = sum(accuracies) / len(accuracies) if accuracies else 0.0

        return WeeklyStatsResponse(
            week_label="This week",
            average_accuracy=average_accuracy,
            daily_accuracies=daily_accuracies,
        )

    async def get_recent_sessions(
        self, user_id: int, limit: int = 10
    ) -> list[RecentSessionResponse]:
        """Получить последние тренировки"""
        sessions = await self.stats_repo.get_recent_sessions(user_id, limit)

        results = []
        for session in sessions:
            # Количество упражнений
            exercise_count = len(session.exercise_runs)

            # Время тренировки
            total_time = 0
            if session.end_time and session.start_time:
                delta = session.end_time - session.start_time
                total_time = int(delta.total_seconds() / 60)

            results.append(
                RecentSessionResponse(
                    id=session.id,
                    date=session.start_time,
                    exercise_count=exercise_count,
                    total_time=total_time,
                    accuracy=session.accuracy or 0,
                    body_part=session.body_part or "General",
                )
            )

        return results