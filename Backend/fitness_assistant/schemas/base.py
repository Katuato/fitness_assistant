"""Общие Pydantic схемы для всего приложения."""

from typing import Generic, TypeVar

from pydantic import BaseModel, Field

T = TypeVar("T")


class PaginationParams(BaseModel):
    """
    Параметры пагинации для списковых эндпоинтов.
    Используется для управления постраничным выводом данных в API.
    """

    page: int = Field(default=1, ge=1, description="Номер страницы")
    size: int = Field(default=20, ge=1, le=100, description="Количество элементов на странице")

    @property
    def offset(self) -> int:
        """Вычисляет смещение для запроса к базе данных."""
        return (self.page - 1) * self.size


class PaginatedResponse(BaseModel, Generic[T]):
    """Универсальная обёртка для ответа с пагинацией"""

    items: list[T]
    total: int
    page: int
    size: int

    @property
    def pages(self) -> int:
        """Вычисляет общее количество страниц"""
        return (self.total + self.size - 1) // self.size if self.size > 0 else 0
