from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import BigInteger, DateTime, ForeignKey, Text, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from fitness_assistant.db.base import Base

if TYPE_CHECKING:
    from fitness_assistant.models.media import Media
    from fitness_assistant.models.session import Session


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(Text, nullable=False)
    password_hash: Mapped[str] = mapped_column(Text, nullable=False)
    name: Mapped[str | None] = mapped_column(Text)
    birth_date: Mapped[str | None] = mapped_column(Text)
    gender: Mapped[str | None] = mapped_column(Text)
    created_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    last_login: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    role: Mapped[str | None] = mapped_column(Text)
    locale: Mapped[str | None] = mapped_column(Text)

    # Relationships
    sessions: Mapped[list["Session"]] = relationship(back_populates="user")
    media_files: Mapped[list["Media"]] = relationship(back_populates="owner")
    measurements: Mapped[list["UserMeasurement"]] = relationship(back_populates="user")


class UserMeasurement(Base):
    __tablename__ = "user_mesurments"

    id: Mapped[int] = mapped_column(primary_key=True)
    user_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("users.id"), nullable=False)
    measured_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    weight: Mapped[str | None] = mapped_column(Text)
    height: Mapped[str | None] = mapped_column(Text)

    # Relationships
    user: Mapped["User"] = relationship(back_populates="measurements")
