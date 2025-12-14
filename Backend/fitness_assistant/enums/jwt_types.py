from typing import TypedDict, Optional, Union, List

class JWTClaimNames:
    """Стандартные имена JWT claims"""
    ISSUER = "iss"                    
    SUBJECT = "sub"                   
    AUDIENCE = "aud"                  
    EXPIRATION_TIME = "exp"           
    NOT_BEFORE = "nbf"               
    ISSUED_AT = "iat"                
    JWT_ID = "jti"                   


class JWTClaims(TypedDict, total=False):
    """
    Типизация JWT claims (payload).

    total=False означает, что все поля опциональны,
    но можно указать какие поля обязательны для нашего приложения.
    """

    # Registered Claims 
    iss: str                         
    sub: str                          
    aud: Union[str, List[str]]        
    exp: int                          
    nbf: int                         
    iat: int                          
    jti: str                         

    # Custom Claims (наши поля)
    user_id: str                      # ID пользователя
    role: str                         # Роль пользователя
    permissions: Optional[List[str]]  # Разрешения пользователя


class AccessTokenClaims(JWTClaims, total=False):
    """Claims для access токена"""
    user_id: str      # Обязательно для access токена
    role: str         # Обязательно для access токена
    exp: int          # Обязательно (время жизни)


class RefreshTokenClaims(JWTClaims, total=False):
    """Claims для refresh токена"""
    user_id: str      # Обязательно для refresh токена
    exp: int          # Обязательно (время жизни)
