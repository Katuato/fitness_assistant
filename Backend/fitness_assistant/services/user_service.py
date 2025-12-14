from fitness_assistant.models.user import User, UserMeasurement
from fitness_assistant.repositories.user_repo import UserRepository
from fitness_assistant.schemas.user import UserMeasurementCreate, UserUpdate


class UserService:
    def __init__(self, user_repo: UserRepository) -> None:
        self.user_repo = user_repo

    async def get_user(self, user_id: int) -> User | None:
        return await self.user_repo.get_by_id(user_id)

    async def update_user(self, user: User, data: UserUpdate) -> User:
        return await self.user_repo.update(
            user,
            name=data.name,
            birth_date=data.birth_date,
            gender=data.gender,
            locale=data.locale
        )

    async def delete_user(self, user: User) -> None:
        await self.user_repo.delete(user)

    # Measurements
    async def get_measurements(
        self, user_id: int, page: int = 1, size: int = 20
    ) -> tuple[list[UserMeasurement], int]:
        offset = (page - 1) * size
        measurements = await self.user_repo.get_measurements(user_id, limit=size, offset=offset)
        total = await self.user_repo.count_measurements(user_id)
        return measurements, total

    async def add_measurement(self, user_id: int, data: UserMeasurementCreate) -> UserMeasurement:
        measurement = UserMeasurement(
            user_id=user_id,
            weight=data.weight,
            height=data.height,
        )
        return await self.user_repo.create_measurement(measurement)
