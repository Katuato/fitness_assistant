# Fitness Assistant Backend

Backend API для iOS приложения фитнес-ассистента.



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



