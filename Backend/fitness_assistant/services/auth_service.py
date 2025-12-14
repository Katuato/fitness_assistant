from fitness_assistant.models.user import User, UserMeasurement
from fitness_assistant.repositories.user_repo import UserRepository
from fitness_assistant.schemas.auth import (
    LoginRequest,
    RegisterRequest,
    TokenResponse,
    ForgotPasswordRequest,
    PasswordResetRequest,
)
from fitness_assistant.utils.security import (
    hash_password,
    verify_password,
    create_access_token,
    create_refresh_token,
    verify_token,
)
from fitness_assistant.exceptions import (
    InvalidCredentialsError,
    InvalidRefreshTokenError,
    InvalidTokenError,
    UserAlreadyExistsError,
    UserNotFoundError,
)


class AuthService:
    """Сервис для работы с аутентификацией пользователей."""

    def __init__(self, user_repo: UserRepository) -> None:
        self.user_repo = user_repo


    async def register(self, data: RegisterRequest) -> TokenResponse:
        existing_user = await self.user_repo.get_by_email(data.email)
        if existing_user:
            raise UserAlreadyExistsError("User with this email already exists")

        user = User(
            email=data.email,
            password_hash=hash_password(data.password),
            name=data.name,
            birth_date=data.birth_date,
            gender=data.gender,
            locale=data.locale,
            role="user",  # По умолчанию обычный пользователь
        )
        user = await self.user_repo.create(user)
        
        if data.height or data.weight:
            measurement = UserMeasurement(
                user_id=user.id,
                height=data.height,
                weight=data.weight,
            )
            await self.user_repo.create_measurement(measurement)
        
        return self._create_token_response(user)


    async def login(self, data: LoginRequest) -> TokenResponse:
        # Пытаемся найти пользователя по email или name
        user = await self.user_repo.get_by_email_or_name(data.email)
        if not user:
            raise InvalidCredentialsError("Invalid email/username or password")
        if not verify_password(data.password, user.password_hash):
            raise InvalidCredentialsError("Invalid email/username or password")
        await self.user_repo.update(user, last_login=True)

        return self._create_token_response(user)


    async def refresh_tokens(self, refresh_token: str) -> TokenResponse:
        payload = verify_token(refresh_token)

        user_id = payload.get("user_id")
        if not user_id:
            raise InvalidRefreshTokenError("Invalid refresh token")

        user = await self.user_repo.get_by_id(int(user_id))
        if not user:
            raise UserNotFoundError("User not found")
        return self._create_token_response(user)


    async def get_current_user(self, token: str) -> User:

        payload = verify_token(token)
        user_id = payload.get("user_id")
        if not user_id:
            raise InvalidTokenError("Invalid token payload")
        user = await self.user_repo.get_by_id(int(user_id))
        if not user:
            raise UserNotFoundError("User not found")
        return user


    async def forgot_password(self, data: ForgotPasswordRequest) -> str:
        """
        Инициирует процесс сброса пароля
        """
        user = await self.user_repo.get_by_email(data.email)
        if not user:
            return "If email exists, reset link was sent"

        # TODO: Сгенерировать токен сброса, сохранить в БД с expiry
        # TODO: Отправить email через Resend/SendGrid

        # Пока просто возвращаем сообщение
        return "If email exists, reset link was sent"

    async def reset_password(self, data: PasswordResetRequest) -> str:
        """
        Сбрасывает пароль по токену восстановления
        Проверяет токен, обновляет пароль пользователя.
        """
        # TODO: Проверить токен в БД (существует и не истек)
        # TODO: Найти пользователя по токену
        # TODO: Обновить пароль
        # TODO: Удалить токен сброса

        # Пока просто заглушка
        return "Password reset successful"


    def _create_token_response(self, user: User) -> TokenResponse:
        token_data = {
            "user_id": str(user.id),
            "email": user.email,
            "role": user.role or "user",
        }

        access_token = create_access_token(token_data)
        refresh_token = create_refresh_token(token_data)

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            token_type="bearer",
        )
