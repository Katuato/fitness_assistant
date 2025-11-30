from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI

from fitness_assistant.config import get_settings
from fitness_assistant.web.routers import api_router

settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    print("Starting Fitness Assistant API")
    yield
    print("Shutting down...")


def create_app() -> FastAPI:
    app = FastAPI(
        title="Fitness Assistant API",
        docs_url="/api/docs",
        redoc_url="/api/redoc",
        openapi_url="/api/openapi.json",
        lifespan=lifespan,
    )

    app.include_router(api_router, prefix="/api/v1")

    @app.get("/health")
    async def health_check() -> dict:
        return {"status": "healthy"}

    return app


app = create_app()
