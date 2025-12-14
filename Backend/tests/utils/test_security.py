import pytest
from unittest.mock import patch

from fitness_assistant.utils.security import (
    hash_password,
    verify_password,
    create_access_token,
    create_refresh_token,
    verify_token,
    decode_token,
)
from fitness_assistant.exceptions import (
    InvalidTokenError,
    InvalidTokenFormatError,
)
import hashlib
import base64


class TestPasswordSecurity:

    def test_hash_password_success(self):
        # Arrange
        password = "test123"

        # Act
        hashed = hash_password(password)

        # Assert
        assert isinstance(hashed, str)
        assert len(hashed) > 0
        assert hashed != password

    def test_verify_password_success(self):
        # Arrange
        original_password = "test123"
        hashed = hash_password(original_password)

        # Act
        is_valid = verify_password(original_password, hashed)

        # Assert
        assert is_valid is True


    def test_verify_password_failure(self):
 
        # Arrange
        original_password = "test123"
        wrong_input_password = "wrong123"
        hashed = hash_password(original_password)

        # Act
        is_valid = verify_password(wrong_input_password, hashed)

        # Assert
        assert is_valid is False

    def test_password_length_logic(self):


        # Arrange
        short_password = "test123"  # 7 байт
        long_password = "a" * 80    # 80 байт > 72

        # Act - проверяем логику определения длины
        short_bytes = short_password.encode('utf-8')
        long_bytes = long_password.encode('utf-8')

        # Assert
        assert len(short_bytes) <= 72  # Короткий пароль - хешируется напрямую
        assert len(long_bytes) > 72    # Длинный пароль - нужен pre-hashing

        # Проверяем, что pre-hashing дает безопасную длину
        sha256_hash = hashlib.sha256(long_bytes).digest()
        encoded = base64.b64encode(sha256_hash).decode('utf-8')
        assert len(encoded) <= 72  # base64 от SHA256 всегда <= 44 символов


class TestJWTToken:


    def test_create_access_token_success(self):

        # Arrange
        data = {"user_id": "123", "role": "user"}

        # Act
        token = create_access_token(data)

        # Assert
        assert isinstance(token, str)
        assert len(token) > 0
        assert token.count(".") == 2  # JWT формат: header.payload.signature

    def test_create_refresh_token_success(self):

        # Arrange
        data = {"user_id": "123", "role": "user"}

        # Act
        token = create_refresh_token(data)

        # Assert
        assert isinstance(token, str)
        assert len(token) > 0
        assert token.count(".") == 2  

    def test_verify_token_success(self):

        # Arrange
        data = {"user_id": "123", "role": "user"}
        token = create_access_token(data)

        # Act
        payload = verify_token(token)

        # Assert
        assert isinstance(payload, dict)
        assert payload["user_id"] == "123"
        assert payload["role"] == "user"
        assert "exp" in payload  
        assert "iat" in payload  

    def test_verify_token_invalid(self):

        # Arrange
        invalid_token = "invalid.jwt.token"

        # Act & Assert
        with pytest.raises(InvalidTokenError, match="Token is invalid or malformed"):
            verify_token(invalid_token)

    def test_decode_token_success(self):
     
        # Arrange
        data = {"user_id": "123", "role": "user"}
        token = create_access_token(data)

        # Act
        payload = decode_token(token)

        # Assert
        assert isinstance(payload, dict)
        assert payload["user_id"] == "123"
        assert payload["role"] == "user"

    def test_decode_token_invalid(self):

        # Arrange
        invalid_token = "invalid.jwt.token"

        # Act & Assert
        with pytest.raises(InvalidTokenFormatError, match="Token format is invalid"):
            decode_token(invalid_token)

    @patch("fitness_assistant.utils.security.settings")
    def test_access_token_expiration(self, mock_settings):

        # Arrange
        mock_settings.jwt_access_token_expire_minutes = 30
        mock_settings.jwt_secret_key = "test_key"
        mock_settings.jwt_algorithm = "HS256"

        data = {"user_id": "123"}
        token = create_access_token(data)

        # Act
        payload = verify_token(token)

        # Assert
        assert "exp" in payload
    

    @patch("fitness_assistant.utils.security.settings")
    def test_refresh_token_expiration(self, mock_settings):
    
        # Arrange
        mock_settings.jwt_refresh_token_expire_days = 7
        mock_settings.jwt_secret_key = "test_key"
        mock_settings.jwt_algorithm = "HS256"

        data = {"user_id": "123"}
        token = create_refresh_token(data)

        # Act
        payload = verify_token(token)

        # Assert
        assert "exp" in payload
