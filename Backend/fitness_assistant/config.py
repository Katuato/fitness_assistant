from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    # Database
    database_url: str = "postgresql+asyncpg://postgres:postgres@localhost:5433/fitness_db"

    # Debug mode
    debug: bool = False

    # JWT Settings
    jwt_secret_key: str = "52A5285215296C067EDF6F8A052F52152"
    jwt_algorithm: str = "HS256"
    jwt_access_token_expire_minutes: int = 20  
    jwt_refresh_token_expire_days: int = 7  


@lru_cache
def get_settings() -> Settings:
    return Settings()
