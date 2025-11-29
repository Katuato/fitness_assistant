# Fitness Assistant Backend

Backend API для iOS приложения фитнес-ассистента.

## Стек

- **Python 3.11** + **FastAPI**
- **SQLAlchemy 2.0** (async)
- **PostgreSQL 17**
- **Poetry**

## Быстрый старт

### 1. Запуск PostgreSQL

```bash
cd Backend
docker compose up -d db
```

БД автоматически заполнится данными из `DB/fitness_backup.sql`.

### 2. Установка зависимостей

```bash
poetry install
cp env.example .env
```

### 3. Запуск сервера

```bash
poetry run uvicorn fitness_assistant.main:app --reload --port 8000
```

## API

- **Swagger UI**: http://localhost:8000/api/docs
- **Health check**: http://localhost:8000/health

### Endpoints

- `GET /api/v1/exercises` — список упражнений
- `GET /api/v1/exercises/{id}` — упражнение по ID
- `GET /api/v1/exercises/muscles` — список мышц
- `GET /api/v1/users/{id}` — пользователь
- `GET /api/v1/sessions?user_id=1` — сессии пользователя
- `POST /api/v1/analysis/tasks` — создать задачу на анализ

## Команды

```bash
# Остановить БД
docker compose down

# Форматирование
poetry run black .

# Миграции
poetry run alembic upgrade head
```

