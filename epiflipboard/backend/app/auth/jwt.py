import os
from jose import jwt
from datetime import datetime, timedelta, timezone

JWT_SECRET = os.getenv("JWT_SECRET", "dev-secret")
JWT_ALGO = "HS256"
JWT_EXPIRE_DAYS = 7

def create_access_token(data: dict) -> str:
    payload = data.copy()
    now = datetime.now(timezone.utc)

    payload["iat"] = now
    payload["exp"] = now + timedelta(days=JWT_EXPIRE_DAYS)

    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGO)

def verify_access_token(token: str) -> dict:
    return jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGO])