from fitness_assistant.models.media import Media
from fitness_assistant.repositories.media_repo import MediaRepository
from fitness_assistant.schemas.media import MediaCreate


class MediaService:
    def __init__(self, media_repo: MediaRepository) -> None:
        self.media_repo = media_repo

    async def get_media(self, media_id: int) -> Media | None:

        return await self.media_repo.get_by_id(media_id)

    async def get_user_media(
        self,
        user_id: int,
        media_type: str | None = None,
        page: int = 1,
        size: int = 20,
    ) -> tuple[list[Media], int]:

        offset = (page - 1) * size
        media_list = await self.media_repo.get_list(
            user_id=user_id,
            media_type=media_type,
            limit=size,
            offset=offset,
        )
        total = await self.media_repo.count(user_id=user_id, media_type=media_type)
        return media_list, total

    async def get_exercise_media(
        self, exercise_id: int, page: int = 1, size: int = 20
    ) -> tuple[list[Media], int]:

        offset = (page - 1) * size
        media_list = await self.media_repo.get_list(
            exercise_id=exercise_id,
            limit=size,
            offset=offset,
        )
        total = await self.media_repo.count(exercise_id=exercise_id)
        return media_list, total

    async def create_media(self, user_id: int, data: MediaCreate) -> Media:

        media = Media(
            owner_user=user_id,
            media_type=data.media_type.value,
            s3_key=data.s3_key,
            exercise_id=data.exercise_id,
            meta=data.meta,
        )
        return await self.media_repo.create(media)

    async def delete_media(self, media: Media) -> None:
        """Delete media record."""
        await self.media_repo.delete(media)
