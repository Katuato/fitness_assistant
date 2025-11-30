from enum import Enum


class UserGender(str, Enum):
    """Пол пользователя"""

    MALE = "male"
    FEMALE = "female"
    OTHER = "other"


class UserRole(str, Enum):
    """Роль пользователя в системе"""

    USER = "user"
    ADMIN = "admin"
