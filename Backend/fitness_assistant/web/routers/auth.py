"""Эндпоинты аутентификации."""

from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

from fitness_assistant.exceptions import (
    InvalidCredentialsError,
    InvalidRefreshTokenError,
    InvalidTokenError,
    ExpiredTokenError,
    UserAlreadyExistsError,
    UserNotFoundError,
)
from fitness_assistant.schemas.auth import (
    LoginRequest,
    MessageResponse,
    RefreshTokenRequest,
    RegisterRequest,
    TokenResponse,
)
from fitness_assistant.schemas.user import UserResponse
from fitness_assistant.web.deps import AuthSvc

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login", auto_error=False)
OptionalToken = Annotated[str | None, Depends(oauth2_scheme)]


@router.post(
    "/register",
    response_model=TokenResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Регистрация нового пользователя",
    description="Создаёт нового пользователя и возвращает токены аутентификации.",
)
async def register(
    data: RegisterRequest,
    auth_service: AuthSvc,
) -> TokenResponse:
    """
    Регистрация нового пользователя.

    - **email**: Email пользователя (уникальный)
    - **password**: Пароль (минимум 6 символов)
    - **name**: Имя пользователя
    """
    try:
        return await auth_service.register(data)
    except UserAlreadyExistsError:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="User with this email already exists",
        )


@router.post(
    "/login",
    response_model=TokenResponse,
    summary="Вход в систему",
    description="Аутентифицирует пользователя по email или имени (логину) и возвращает access и refresh токены.",
)
async def login(
    data: LoginRequest,
    auth_service: AuthSvc,
) -> TokenResponse:
    """
    Вход в систему.
    
    Можно войти используя:
    - **email**: Email пользователя (например: user@example.com)
    - **username**: Имя пользователя (логин, например: JohnDoe)
    """
    try:
        return await auth_service.login(data)
    except InvalidCredentialsError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email/username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )


@router.post(
    "/refresh",
    response_model=TokenResponse,
    summary="Обновление токенов",
    description="Обновляет access токен с помощью refresh токена.",
)
async def refresh_tokens(
    data: RefreshTokenRequest,
    auth_service: AuthSvc,
) -> TokenResponse:
    """
    Обновление токенов.

    - **refresh_token**: Действующий refresh токен
    """
    try:
        return await auth_service.refresh_tokens(data.refresh_token)
    except (InvalidRefreshTokenError, InvalidTokenError, ExpiredTokenError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired refresh token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except UserNotFoundError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )


@router.get(
    "/me",
    response_model=UserResponse,
    summary="Получение текущего пользователя",
    description="Возвращает данные аутентифицированного пользователя.",
)
async def get_current_user(
    auth_service: AuthSvc,
    token: OptionalToken,
) -> UserResponse:
    """
    Получение данных текущего пользователя.

    Требует валидный access токен в заголовке Authorization: Bearer <token>
    """
    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated",
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        user = await auth_service.get_current_user(token)
        return UserResponse.model_validate(user)
    except (InvalidTokenError, ExpiredTokenError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except UserNotFoundError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )


@router.post(
    "/logout",
    response_model=MessageResponse,
    summary="Выход из системы",
    description="Выход из системы. В текущей реализации просто возвращает успех.",
)
async def logout() -> MessageResponse:
    """
    Выход из системы.

    Примечание: В текущей реализации без хранения refresh токенов в БД,
    logout на бэкенде не инвалидирует токены. iOS клиент должен
    удалить токены из Keychain.

    В будущем можно добавить blacklist токенов или хранить refresh токены в БД.
    """
    return MessageResponse(message="Successfully logged out")

