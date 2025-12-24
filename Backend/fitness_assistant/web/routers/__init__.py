from fastapi import APIRouter

from fitness_assistant.web.routers import (
    analysis,
    auth,
    exercises,
    media,
    sessions,
    stats,
    users,
    workout_plans,
)

__all__ = [
    "auth",
    "users",
    "exercises",
    "sessions",
    "media",
    "analysis",
    "workout_plans",
    "stats",
]

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(exercises.router, prefix="/exercises", tags=["exercises"])
api_router.include_router(sessions.router, prefix="/sessions", tags=["sessions"])
api_router.include_router(media.router, prefix="/media", tags=["media"])
api_router.include_router(analysis.router, prefix="/analysis", tags=["analysis"])

# Новые роутеры
api_router.include_router(
    workout_plans.router, prefix="/workout-plans", tags=["Workout Plans"]
)
api_router.include_router(stats.router, prefix="/stats", tags=["Statistics"])
