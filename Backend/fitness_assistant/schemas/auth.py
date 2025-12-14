from pydantic import BaseModel, Field, EmailStr


class LoginRequest(BaseModel):
    """Схема запроса для входа в систему."""

    email: str = Field(description="Email или имя пользователя (логин)")
    password: str = Field(min_length=1, description="Пароль пользователя")


class RegisterRequest(BaseModel):
    """Схема запроса для регистрации нового пользователя."""

    email: EmailStr = Field(description="Email пользователя")
    password: str = Field(min_length=6, description="Пароль пользователя (минимум 6 символов)")
    name: str = Field(min_length=1, max_length=100, description="Имя пользователя")
    birth_date: str | None = Field(default=None, description="Дата рождения (YYYY-MM-DD)")
    gender: str | None = Field(default=None, description="Пол пользователя")
    height: str | None = Field(default=None, description="Рост")
    weight: str | None = Field(default=None, description="Вес")
    locale: str | None = Field(default=None, description="Местоположение пользователя")



class TokenResponse(BaseModel):
    """Схема ответа с токенами аутентификации."""

    access_token: str = Field(description="Access токен для аутентификации")
    refresh_token: str = Field(description="Refresh токен для обновления access токена")
    token_type: str = Field(default="bearer", description="Тип токена")


class ForgotPasswordRequest(BaseModel):
    """Схема запроса для восстановления пароля."""

    email: EmailStr = Field(description="Email пользователя для отправки ссылки восстановления")


class PasswordResetRequest(BaseModel):
    """Схема запроса для сброса пароля."""

    token: str = Field(min_length=1, description="Токен восстановления пароля")
    new_password: str = Field(min_length=6, description="Новый пароль пользователя (минимум 6 символов)")


class RefreshTokenRequest(BaseModel):
    """Схема запроса для обновления токенов."""
    refresh_token: str = Field(description="Refresh токен для обновления access токена")


class MessageResponse(BaseModel):
    """Схема для простых текстовых ответов."""

    message: str = Field(description="Сообщение ответа")
