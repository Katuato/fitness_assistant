import pytest
from unittest.mock import AsyncMock, MagicMock, patch

from fitness_assistant.models.user import User
from fitness_assistant.services.auth_service import AuthService
from fitness_assistant.repositories.user_repo import UserRepository
from fitness_assistant.schemas.auth import (
    LoginRequest,
    RegisterRequest,
    TokenResponse,
    ForgotPasswordRequest,
    PasswordResetRequest,
)
from fitness_assistant.exceptions import (
    InvalidCredentialsError,
    InvalidRefreshTokenError,
    InvalidTokenError,
    UserAlreadyExistsError,
    UserNotFoundError,
)


class TestAuthService:

    @pytest.fixture
    def mock_user_repo(self) -> AsyncMock:
        return AsyncMock(spec=UserRepository)

    @pytest.fixture
    def auth_service(self, mock_user_repo: AsyncMock) -> AuthService:
        return AuthService(mock_user_repo)

    @pytest.fixture
    def sample_user(self) -> MagicMock:
        user = MagicMock(spec=User)
        user.id = 1
        user.email = "test@example.com"
        user.password_hash = "hashed_password"
        user.name = "Test User"
        user.role = "user"
        return user

    class TestRegister:

        async def test_register_success_creates_user_and_tokens(
            self,
            auth_service: AuthService,
            mock_user_repo: AsyncMock,
            sample_user: MagicMock
        ) -> None:
            # Arrange
            request_data = RegisterRequest(
                email="new@example.com",
                password="secure_password123",
                name="New User"
            )

            mock_user_repo.get_by_email.return_value = None

            created_user = MagicMock(spec=User)
            created_user.id = 2
            created_user.email = request_data.email
            created_user.name = request_data.name
            created_user.role = "user"
            mock_user_repo.create.return_value = created_user

            with patch('fitness_assistant.services.auth_service.hash_password') as mock_hash, \
                 patch('fitness_assistant.services.auth_service.create_access_token') as mock_access_token, \
                 patch('fitness_assistant.services.auth_service.create_refresh_token') as mock_refresh_token:

                mock_hash.return_value = "hashed_secure_password"
                mock_access_token.return_value = "generated_access_token"
                mock_refresh_token.return_value = "generated_refresh_token"

                # Act
                result = await auth_service.register(request_data)

                # Assert
                assert isinstance(result, TokenResponse)
                assert result.access_token == "generated_access_token"
                assert result.refresh_token == "generated_refresh_token"
                assert result.token_type == "bearer"

                mock_hash.assert_called_once_with(request_data.password)

                mock_user_repo.create.assert_called_once()
                created_user_arg = mock_user_repo.create.call_args[0][0]
                assert created_user_arg.email == request_data.email
                assert created_user_arg.password_hash == "hashed_secure_password"
                assert created_user_arg.name == request_data.name
                assert created_user_arg.role == "user"

                expected_token_payload = {
                    "user_id": str(created_user.id),
                    "email": created_user.email,
                    "role": created_user.role,
                }
                mock_access_token.assert_called_once_with(expected_token_payload)
                mock_refresh_token.assert_called_once_with(expected_token_payload)

        async def test_register_fails_when_user_already_exists(
            self,
            auth_service: AuthService,
            mock_user_repo: AsyncMock,
            sample_user: MagicMock
        ) -> None:
            # Arrange
            request_data = RegisterRequest(
                email="existing@example.com",
                password="password123",
                name="Existing User"
            )

            mock_user_repo.get_by_email.return_value = sample_user

            # Act & Assert
            with pytest.raises(UserAlreadyExistsError, match="User with this email already exists"):
                await auth_service.register(request_data)

            mock_user_repo.create.assert_not_called()

            mock_user_repo.get_by_email.assert_called_once_with(request_data.email)

    class TestLogin:

        async def test_login_success_updates_last_login_and_returns_tokens(
            self,
            auth_service: AuthService,
            mock_user_repo: AsyncMock,
            sample_user: MagicMock
        ) -> None:
            # Arrange
            request_data = LoginRequest(
                email="test@example.com",
                password="correct_password"
            )

            mock_user_repo.get_by_email.return_value = sample_user

            with patch('fitness_assistant.services.auth_service.verify_password') as mock_verify, \
                 patch('fitness_assistant.services.auth_service.create_access_token') as mock_access_token, \
                 patch('fitness_assistant.services.auth_service.create_refresh_token') as mock_refresh_token:

                mock_verify.return_value = True
                mock_access_token.return_value = "access_token_success"
                mock_refresh_token.return_value = "refresh_token_success"

                # Act
                result = await auth_service.login(request_data)

                # Assert
                assert isinstance(result, TokenResponse)
                assert result.access_token == "access_token_success"
                assert result.refresh_token == "refresh_token_success"
                assert result.token_type == "bearer"

                mock_verify.assert_called_once_with(request_data.password, sample_user.password_hash)
                mock_user_repo.update.assert_called_once_with(sample_user, last_login=True)
                mock_user_repo.get_by_email.assert_called_once_with(request_data.email)

        async def test_login_fails_with_invalid_credentials(
            self,
            auth_service: AuthService,
            mock_user_repo: AsyncMock
        ) -> None:
            # Arrange - пользователь не найден
            request_data = LoginRequest(
                email="nonexistent@example.com",
                password="password123"
            )
            mock_user_repo.get_by_email.return_value = None

            # Act & Assert
            with pytest.raises(InvalidCredentialsError, match="Invalid email or password"):
                await auth_service.login(request_data)

            # Проверяем что обновление не было вызвано
            mock_user_repo.update.assert_not_called()

        async def test_login_fails_with_wrong_password(
            self,
            auth_service: AuthService,
            mock_user_repo: AsyncMock,
            sample_user: MagicMock
        ) -> None:
            # Arrange
            request_data = LoginRequest(
                email="test@example.com",
                password="wrong_password"
            )

            mock_user_repo.get_by_email.return_value = sample_user

            with patch('fitness_assistant.services.auth_service.verify_password') as mock_verify:
                mock_verify.return_value = False

                # Act & Assert
                with pytest.raises(InvalidCredentialsError, match="Invalid email or password"):
                    await auth_service.login(request_data)

                # Проверяем что verify_password был вызван с правильными аргументами
                mock_verify.assert_called_once_with(request_data.password, sample_user.password_hash)

                # Проверяем что обновление last_login не было вызвано
                mock_user_repo.update.assert_not_called()

    class TestRefreshTokens:

        async def test_refresh_tokens_success_creates_new_tokens(
            self,
            auth_service: AuthService,
            mock_user_repo: AsyncMock,
            sample_user: MagicMock
        ) -> None:
            # Arrange
            refresh_token = "valid_refresh_token_123"

            mock_user_repo.get_by_id.return_value = sample_user

            with patch('fitness_assistant.services.auth_service.verify_token') as mock_verify_token, \
                 patch('fitness_assistant.services.auth_service.create_access_token') as mock_access_token, \
                 patch('fitness_assistant.services.auth_service.create_refresh_token') as mock_refresh_token:

                # Мокаем payload refresh токена
                token_payload = {
                    "user_id": str(sample_user.id),
                    "email": sample_user.email,
                    "role": sample_user.role
                }
                mock_verify_token.return_value = token_payload

                mock_access_token.return_value = "new_access_token"
                mock_refresh_token.return_value = "new_refresh_token"

                # Act
                result = await auth_service.refresh_tokens(refresh_token)

                # Assert
                assert isinstance(result, TokenResponse)
                assert result.access_token == "new_access_token"
                assert result.refresh_token == "new_refresh_token"
                assert result.token_type == "bearer"

                # Проверяем верификацию refresh токена
                mock_verify_token.assert_called_once_with(refresh_token)

                # Проверяем поиск пользователя по ID из токена
                mock_user_repo.get_by_id.assert_called_once_with(sample_user.id)

                # Проверяем генерацию новых токенов с правильным payload
                expected_payload = {
                    "user_id": str(sample_user.id),
                    "email": sample_user.email,
                    "role": sample_user.role,
                }
                mock_access_token.assert_called_once_with(expected_payload)
                mock_refresh_token.assert_called_once_with(expected_payload)

        async def test_refresh_tokens_fails_with_invalid_token_payload(
            self,
            auth_service: AuthService,
            mock_user_repo: AsyncMock
        ) -> None:
            # Arrange
            refresh_token = "invalid_refresh_token"

            with patch('fitness_assistant.services.auth_service.verify_token') as mock_verify_token:
                # Мокаем payload без обязательного поля user_id
                mock_verify_token.return_value = {"email": "test@example.com"}

                # Act & Assert
                with pytest.raises(InvalidRefreshTokenError, match="Invalid refresh token"):
                    await auth_service.refresh_tokens(refresh_token)

                # Проверяем что поиск пользователя не был вызван
                mock_user_repo.get_by_id.assert_not_called()

    class TestGetCurrentUser:

        async def test_get_current_user_success_returns_user(
            self,
            auth_service: AuthService,
            mock_user_repo: AsyncMock,
            sample_user: MagicMock
        ) -> None:
            # Arrange
            access_token = "valid_access_token"

            mock_user_repo.get_by_id.return_value = sample_user

            with patch('fitness_assistant.services.auth_service.verify_token') as mock_verify_token:
                token_payload = {
                    "user_id": str(sample_user.id),
                    "email": sample_user.email,
                    "role": sample_user.role
                }
                mock_verify_token.return_value = token_payload

                # Act
                result = await auth_service.get_current_user(access_token)

                # Assert
                assert result == sample_user

                # Проверяем верификацию токена
                mock_verify_token.assert_called_once_with(access_token)

                # Проверяем поиск пользователя по ID
                mock_user_repo.get_by_id.assert_called_once_with(sample_user.id)

        async def test_get_current_user_fails_with_invalid_token(
            self,
            auth_service: AuthService,
            mock_user_repo: AsyncMock
        ) -> None:
            # Arrange
            access_token = "invalid_access_token"

            with patch('fitness_assistant.services.auth_service.verify_token') as mock_verify_token:
                # Мокаем payload без user_id
                mock_verify_token.return_value = {"email": "test@example.com"}

                # Act & Assert
                with pytest.raises(InvalidTokenError, match="Invalid token payload"):
                    await auth_service.get_current_user(access_token)

                # Проверяем что поиск пользователя не был вызван
                mock_user_repo.get_by_id.assert_not_called()

    class TestCreateTokenResponse:

        def test_create_token_response_generates_tokens_with_correct_payload(
            self,
            auth_service: AuthService,
            sample_user: MagicMock
        ) -> None:
            # Arrange
            with patch('fitness_assistant.services.auth_service.create_access_token') as mock_access_token, \
                 patch('fitness_assistant.services.auth_service.create_refresh_token') as mock_refresh_token:

                mock_access_token.return_value = "access_token_final"
                mock_refresh_token.return_value = "refresh_token_final"

                # Act
                result = auth_service._create_token_response(sample_user)

                # Assert
                assert isinstance(result, TokenResponse)
                assert result.access_token == "access_token_final"
                assert result.refresh_token == "refresh_token_final"
                assert result.token_type == "bearer"

                expected_payload = {
                    "user_id": str(sample_user.id),
                    "email": sample_user.email,
                    "role": sample_user.role,
                }

                mock_access_token.assert_called_once_with(expected_payload)
                mock_refresh_token.assert_called_once_with(expected_payload)