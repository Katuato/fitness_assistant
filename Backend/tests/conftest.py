from collections.abc import AsyncGenerator

from httpx import ASGITransport, AsyncClient
import pytest

from fitness_assistant.main import app


@pytest.fixture
async def client() -> AsyncGenerator[AsyncClient, None]:
    async with AsyncClient(
        transport=ASGITransport(app=app),
        base_url="http://test",
    ) as ac:
        yield ac


@pytest.fixture
def anyio_backend() -> str:
    return "asyncio"
