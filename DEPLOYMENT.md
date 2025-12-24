# Настройка среды разработки Fitness Assistant

Это руководство по настройке локальной среды разработки для проекта Fitness Assistant.

## 🚀 Быстрый старт

### Backend (FastAPI)

**Требования:** Python 3.13+, PostgreSQL 17+, Docker

```bash
# 1. Клонируйте репозиторий
git clone <repository-url>
cd fitness_assistant/Backend

# 2. Запустите через Docker (рекомендуется)
docker compose up --build

# Или установите локально
poetry install
cp env.example .env
# Настройте .env файл
poetry run uvicorn fitness_assistant.main:app --reload --port 8000
```

**Проверка:** Откройте http://localhost:8000/api/docs

### iOS приложение

**Требования:** macOS 12.0+, Xcode 15.0+

```bash
# 1. Откройте проект
cd IOS
open fitness_assistant.xcodeproj

# 2. Запустите на симуляторе
# Выберите симулятор → Run (⌘R)
```

**Для устройства:** Настройте Apple Developer аккаунт и provisioning profile.

## 🔧 Настройка среды разработки

### Переменные окружения

Создайте `.env` файл в папке `Backend/`:

```bash
# Копируйте из примера
cp env.example .env

# Отредактируйте значения
DATABASE_URL=postgresql+asyncpg://postgres:postgres@localhost:5433/fitness_db
DEBUG=true
JWT_SECRET_KEY=your-development-secret-key-here
```

### Работа с базой данных

```bash
# Локальная разработка с Docker
docker compose up -d db

# Или установите PostgreSQL локально
# brew install postgresql@17
# brew services start postgresql@17
```

### Тестирование

```bash
cd Backend

# Запуск всех тестов
poetry run pytest

# С покрытием кода
poetry run pytest --cov=fitness_assistant

# Линтинг
poetry run ruff check .

# Типизация
poetry run mypy .
```

## 🐛 Troubleshooting

### Backend Issues

**База данных не подключается:**
```bash
# Проверить статус контейнера
docker compose ps db

# Посмотреть логи
docker compose logs db

# Перезапустить БД
docker compose restart db
```

**Порт занят:**
```bash
# Найти процесс
lsof -i :8000

# Или сменить порт
poetry run uvicorn fitness_assistant.main:app --port 8001
```

**Миграции не применяются:**
```bash
cd Backend
alembic upgrade head
```

### iOS Issues

**Build errors:**
```bash
# Очистить кэш
rm -rf ~/Library/Developer/Xcode/DerivedData

# В Xcode: Product → Clean Build Folder (⇧⌘K)
```

**Симулятор не запускается:**
```bash
# Сбросить симулятор
xcrun simctl erase all

# Или переустановить
xcrun simctl delete unavailable
```

## 🛠️ Полезные команды

### Backend Development
```bash
# Тестирование
poetry run pytest --cov=fitness_assistant

# Линтинг и типизация
poetry run ruff check . && poetry run mypy .

# Миграции БД
alembic revision --autogenerate -m "Add new table"
alembic upgrade head

# Создание суперпользователя
poetry run python -c "from fitness_assistant.utils import create_superuser; create_superuser()"
```

### iOS Development
```bash
# Очистка кэша
rm -rf ~/Library/Developer/Xcode/DerivedData

# Управление симуляторами
xcrun simctl list devices
xcrun simctl boot <device-uuid>
xcrun simctl shutdown <device-uuid>
```

---

## 📞 Поддержка

При проблемах:
1. Проверьте логи приложения (`docker compose logs`)
2. Убедитесь что все зависимости установлены
3. Проверьте конфигурацию окружения