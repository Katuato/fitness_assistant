from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from fitness_assistant.models.media import Media


class MediaRepository:

    def __init__(self, session: AsyncSession) -> None:
        self.session = session

    async def get_by_id(self, media_id: int) -> Media | None:

        result = await self.session.execute(select(Media).where(Media.id == media_id))
        return result.scalar_one_or_none()

    async def get_by_s3_key(self, s3_key: str) -> Media | None:

        result = await self.session.execute(select(Media).where(Media.s3_key == s3_key))
        return result.scalar_one_or_none()

    async def get_list(
        self,
        user_id: int | None = None,
        exercise_id: int | None = None,
        media_type: str | None = None,
        limit: int = 20,
        offset: int = 0,
    ) -> list[Media]:

        query = select(Media)

        if user_id:
            query = query.where(Media.owner_user == user_id)
        if exercise_id:
            query = query.where(Media.exercise_id == exercise_id)
        if media_type:
            query = query.where(Media.media_type == media_type)

        query = query.order_by(Media.created_at.desc()).limit(limit).offset(offset)
        result = await self.session.execute(query)
        return list(result.scalars().all())

    async def count(
        self,
        user_id: int | None = None,
        exercise_id: int | None = None,
        media_type: str | None = None,
    ) -> int:

        query = select(func.count()).select_from(Media)

        if user_id:
            query = query.where(Media.owner_user == user_id)
        if exercise_id:
            query = query.where(Media.exercise_id == exercise_id)
        if media_type:
            query = query.where(Media.media_type == media_type)

        result = await self.session.execute(query)
        return result.scalar() or 0

    async def create(self, media: Media) -> Media:

        self.session.add(media)
        await self.session.flush()
        await self.session.refresh(media)
        return media

    async def delete(self, media: Media) -> None:

        await self.session.delete(media)
        await self.session.flush()
