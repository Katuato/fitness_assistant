from fastapi import APIRouter, HTTPException, Query, status

from fitness_assistant.schemas.media import MediaListResponse, MediaResponse
from fitness_assistant.web.deps import MediaSvc

router = APIRouter()


@router.get("", response_model=MediaListResponse)
async def list_media(
    media_service: MediaSvc,
    user_id: int | None = Query(None, description="Filter by user ID"),
    exercise_id: int | None = Query(None, description="Filter by exercise ID"),
    media_type: str | None = Query(None),
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
) -> MediaListResponse:

    if user_id:
        media_list, total = await media_service.get_user_media(
            user_id, media_type=media_type, page=page, size=size
        )
    elif exercise_id:
        media_list, total = await media_service.get_exercise_media(
            exercise_id, page=page, size=size
        )
    else:
        media_list, total = [], 0

    items = [MediaResponse.model_validate(m) for m in media_list]
    return MediaListResponse(items=items, total=total, page=page, size=size)


@router.get("/{media_id}", response_model=MediaResponse)
async def get_media(media_id: int, media_service: MediaSvc) -> MediaResponse:

    media = await media_service.get_media(media_id)
    if not media:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Media not found")
    return MediaResponse.model_validate(media)


@router.delete("/{media_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_media(media_id: int, media_service: MediaSvc) -> None:

    media = await media_service.get_media(media_id)
    if not media:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Media not found")
    await media_service.delete_media(media)
