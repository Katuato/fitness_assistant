class JWTError(Exception):
    """Базовое исключение для JWT ошибок"""
    pass


class InvalidTokenError(JWTError):
    """Токен недействителен или поврежден"""
    pass


class ExpiredTokenError(JWTError):
    """Токен истек"""
    pass


class InvalidTokenFormatError(JWTError):
    """Неправильный формат токена"""
    pass
