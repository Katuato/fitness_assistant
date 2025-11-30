from fastapi import APIRouter, HTTPException, status

from fitness_assistant.schemas.analysis import (
    AnalysisResultResponse,
    AnalysisTaskCreate,
    AnalysisTaskResponse,
    AnalysisTaskWithResultResponse,
)
from fitness_assistant.web.deps import AnalysisSvc

router = APIRouter()


@router.post("/tasks", response_model=AnalysisTaskResponse, status_code=status.HTTP_201_CREATED)
async def create_analysis_task(
    data: AnalysisTaskCreate,
    analysis_service: AnalysisSvc,
) -> AnalysisTaskResponse:

    task = await analysis_service.create_task(data)
    return AnalysisTaskResponse.model_validate(task)


@router.get("/tasks/{task_id}", response_model=AnalysisTaskWithResultResponse)
async def get_analysis_task(
    task_id: int,
    analysis_service: AnalysisSvc,
) -> AnalysisTaskWithResultResponse:

    task = await analysis_service.get_task(task_id)
    if not task:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Task not found")

    results = [AnalysisResultResponse.model_validate(r) for r in task.results]
    return AnalysisTaskWithResultResponse(
        id=task.id,
        media_id=task.media_id,
        priority=task.priority,
        status=task.status,
        attempts=task.attempts,
        error_text=task.error_text,
        started_at=task.started_at,
        finished_at=task.finished_at,
        results=results,
    )


@router.get("/results/{result_id}", response_model=AnalysisResultResponse)
async def get_analysis_result(
    result_id: int,
    analysis_service: AnalysisSvc,
) -> AnalysisResultResponse:

    result = await analysis_service.get_result(result_id)
    if not result:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Result not found")
    return AnalysisResultResponse.model_validate(result)
