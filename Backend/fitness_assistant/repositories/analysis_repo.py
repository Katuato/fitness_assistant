from datetime import datetime

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from fitness_assistant.models.analysis import AnalysisResult, AnalysisTask


class AnalysisRepository:
    """Репозиторий для работы с моделью AnalysisTask и AnalysisResult"""

    def __init__(self, session: AsyncSession) -> None:
        self.session = session

    # Analysis Tasks
    async def get_task_by_id(self, task_id: int) -> AnalysisTask | None:

        result = await self.session.execute(
            select(AnalysisTask)
            .where(AnalysisTask.id == task_id)
            .options(selectinload(AnalysisTask.results))
        )
        return result.scalar_one_or_none()

    async def get_tasks_by_media(self, media_id: int) -> list[AnalysisTask]:

        result = await self.session.execute(
            select(AnalysisTask)
            .where(AnalysisTask.media_id == media_id)
            .options(selectinload(AnalysisTask.results))
            .order_by(AnalysisTask.id.desc())
        )
        return list(result.scalars().all())

    async def get_pending_tasks(self, limit: int = 10) -> list[AnalysisTask]:

        result = await self.session.execute(
            select(AnalysisTask)
            .where(AnalysisTask.status == "queued")
            .order_by(AnalysisTask.priority.desc(), AnalysisTask.id)
            .limit(limit)
        )
        return list(result.scalars().all())

    async def create_task(self, task: AnalysisTask) -> AnalysisTask:

        self.session.add(task)
        await self.session.flush()
        await self.session.refresh(task)
        return task

    async def update_task(
        self, task: AnalysisTask, **kwargs: str | int | float | datetime | dict | None
    ) -> AnalysisTask:

        for key, value in kwargs.items():
            if value is not None:
                setattr(task, key, value)
        await self.session.flush()
        await self.session.refresh(task)
        return task

    async def count_tasks_by_status(self, status: str) -> int:

        result = await self.session.execute(
            select(func.count()).select_from(AnalysisTask).where(AnalysisTask.status == status)
        )
        return result.scalar() or 0

    # Analysis Results
    async def get_result_by_id(self, result_id: int) -> AnalysisResult | None:

        result = await self.session.execute(
            select(AnalysisResult).where(AnalysisResult.id == result_id)
        )
        return result.scalar_one_or_none()

    async def get_results_by_task(self, task_id: int) -> list[AnalysisResult]:

        result = await self.session.execute(
            select(AnalysisResult)
            .where(AnalysisResult.task_id == task_id)
            .order_by(AnalysisResult.created_at)
        )
        return list(result.scalars().all())

    async def create_result(self, result: AnalysisResult) -> AnalysisResult:

        self.session.add(result)
        await self.session.flush()
        await self.session.refresh(result)
        return result
