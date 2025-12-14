from datetime import datetime, timedelta, timezone
from typing import Any, Dict
import hashlib
import base64

from jose import jwt, JWTError
from passlib.context import CryptContext

from fitness_assistant.config import get_settings
from fitness_assistant.exceptions import (
    InvalidTokenError,
    ExpiredTokenError,
    InvalidTokenFormatError,
)


pwd_context = CryptContext(schemes=["pbkdf2_sha256"], deprecated="auto")
settings = get_settings()


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(input_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(input_password, hashed_password)


def create_access_token(token_data: Dict[str, Any]) -> str:

    payload = token_data.copy()

    expire_time = datetime.now(timezone.utc) + timedelta(
        minutes=settings.jwt_access_token_expire_minutes
    )
    payload.update({
        "exp": int(expire_time.timestamp()),
        "iat": int(datetime.now(timezone.utc).timestamp())
    })

    token = jwt.encode(
        payload,
        settings.jwt_secret_key,
        algorithm=settings.jwt_algorithm
    )
    return token


def create_refresh_token(token_data: Dict[str, Any]) -> str:

    payload = token_data.copy()

    expire_time = datetime.now(timezone.utc) + timedelta(
        days=settings.jwt_refresh_token_expire_days
    )
    payload.update({
        "exp": int(expire_time.timestamp()),
        "iat": int(datetime.now(timezone.utc).timestamp())
    })

    token = jwt.encode(
        payload,
        settings.jwt_secret_key,
        algorithm=settings.jwt_algorithm
    )
    return token


def verify_token(token: str) -> Dict[str, Any]:

    try:
        token_data = jwt.decode(
            token,
            settings.jwt_secret_key,
            algorithms=[settings.jwt_algorithm]
        )
        return token_data  
    except jwt.ExpiredSignatureError:
        raise ExpiredTokenError("Token has expired")
    except jwt.JWTClaimsError:
        raise InvalidTokenError("Token claims are invalid")
    except jwt.JWTError:
        raise InvalidTokenError("Token is invalid or malformed")


def decode_token(token: str) -> Dict[str, Any]:

    try:
        token_data = jwt.get_unverified_claims(token)
        return token_data
    except jwt.JWTError:
        raise InvalidTokenFormatError("Token format is invalid")
