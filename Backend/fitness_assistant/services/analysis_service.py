from datetime import UTC, datetime

from fitness_assistant.models.analysis import AnalysisResult, AnalysisTask
from fitness_assistant.repositories.analysis_repo import AnalysisRepository
from fitness_assistant.schemas.analysis import AnalysisTaskCreate


class AnalysisService:

    def __init__(self, analysis_repo: AnalysisRepository) -> None:
        self.analysis_repo = analysis_repo

    async def get_task(self, task_id: int) -> AnalysisTask | None:

        return await self.analysis_repo.get_task_by_id(task_id)

    async def get_tasks_for_media(self, media_id: int) -> list[AnalysisTask]:

        return await self.analysis_repo.get_tasks_by_media(media_id)

    async def create_task(self, data: AnalysisTaskCreate) -> AnalysisTask:

        task = AnalysisTask(
            media_id=data.media_id,
            priority=data.priority,
            status="queued",
        )
        return await self.analysis_repo.create_task(task)

    async def start_task(self, task: AnalysisTask) -> AnalysisTask:

        return await self.analysis_repo.update_task(
            task,
            status="processing",
            started_at=datetime.now(UTC),
            attempts=task.attempts + 1,
        )

    async def complete_task(
        self,
        task: AnalysisTask,
        result: dict,
        summary: str | None = None,
        score: float | None = None,
    ) -> AnalysisTask:

        # Save result
        analysis_result = AnalysisResult(
            task_id=task.id,
            result=result,
            summary_text=summary,
            score=score,
        )
        await self.analysis_repo.create_result(analysis_result)

        # Update task status
        return await self.analysis_repo.update_task(
            task,
            status="completed",
            finished_at=datetime.now(UTC),
        )

    async def fail_task(self, task: AnalysisTask, error: str) -> AnalysisTask:

        return await self.analysis_repo.update_task(
            task,
            status="failed",
            finished_at=datetime.now(UTC),
            error_text=error,
        )

    async def get_pending_tasks(self, limit: int = 10) -> list[AnalysisTask]:
        return await self.analysis_repo.get_pending_tasks(limit)

    async def get_result(self, result_id: int) -> AnalysisResult | None:
        return await self.analysis_repo.get_result_by_id(result_id)
