class AuthError(Exception):
    """Базовое исключение для ошибок аутентификации/авторизации"""
    pass


class UserAlreadyExistsError(AuthError):
    """Пользователь с таким email уже существует"""
    pass


class InvalidCredentialsError(AuthError):
    """Неверный email или пароль"""
    pass


class UserNotFoundError(AuthError):
    """Пользователь не найден"""
    pass


class InvalidRefreshTokenError(AuthError):
    """Refresh токен недействителен или поврежден"""
    pass

