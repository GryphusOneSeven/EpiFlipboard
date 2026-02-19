import os
from fastapi import FastAPI, HTTPException, Depends, Header
from fastapi.middleware.cors import CORSMiddleware
from .supabase_client import supabase
from . import crud, models
from pydantic import BaseModel
from google.oauth2 import id_token
from google.auth.transport import requests
from app.auth.jwt import create_access_token
from app.auth.jwt import verify_access_token

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"status": "ok"}

# Endpoint pour ajouter un utilisateur
@app.post("/users")
def create_user(user: dict):
    response = supabase.table("users").insert(user).execute()
    if response.error:
        raise HTTPException(status_code=500, detail=str(response.error))
    return response.data

# Endpoint pour récupérer un utilisateur par id
@app.get("/users/{user_id}")
def get_user(user_id: int):
    response = supabase.table("users").select("*").eq("id", user_id).execute()
    if response.error:
        raise HTTPException(status_code=500, detail=str(response.error))
    if not response.data:
        raise HTTPException(status_code=404, detail="User not found")
    return response.data[0]




# USERS
# @app.get("/users")
# def list_users():
#     return crud.get_users()

# @app.post("/users")
# def add_user(user: models.User):
#     return crud.create_user(user.dict())

# # POSTS
# @app.get("/posts")
# def list_posts():
#     return crud.get_posts()

# @app.post("/posts")
# def add_post(post: models.Post):
#     return crud.create_post(post.dict())

# # LIKES
# @app.get("/likes")
# def list_likes():
#     return crud.get_likes()

# @app.post("/likes")
# def add_like(like: models.Like):
#     return crud.create_like(like.dict())



@app.get("/test-db")
def test_db():
    try:
        result = supabase.table("User").select("*").execute()
        return {"status": "ok", "data": result.data}
    except Exception as e:
        return {"status": "error", "message": str(e)}


class TokenSchema(BaseModel):
    token: str

@app.post("/auth/google/mobile")
async def login_google(data: TokenSchema):
    try:
        # 1. Vérifier le token auprès de Google
        # Cela garantit que le token vient bien de Google et n'est pas falsifié
        idinfo = id_token.verify_oauth2_token(
            data.token,
            requests.Request(), 
            audience=os.getenv("GOOGLE_CLIENT_ID"),  # serverClientId Flutter
            clock_skew_in_seconds=10  # Tolère 10 secondes de décalage
        )
        print(idinfo["aud"])

        # Informations récupérées
        email = idinfo['email']
        name = idinfo.get('name', '')
        picture = idinfo.get('picture', '')

        # 2. Insérer ou mettre à jour l'utilisateur dans Supabase (Table 'users')
        user_data = {
            "email": email,
            "name": name,
            "profile_picture": picture,
            "auth_provider": "google",
            "provider_user_id": idinfo['sub'],  # L'ID unique de l'utilisateur chez Google
            "password": None  # Pas de mot de passe pour les utilisateurs Google
        }
        
        # Upsert: Met à jour si l'email existe, sinon crée
        response = supabase.table('User').upsert(user_data, on_conflict='email').execute()
        print(response)

        db_user = response.data[0]

        token = create_access_token({
            "sub": db_user["email"],
            "user_id": db_user["id"]
        })

        # 3. Retourner une réponse au Front
        return {
            "message": "Authentification réussie",
            "token": token,
            "user": db_user,
        }

    except ValueError as e:
        print(f"Erreur ValueError: {e}")
        raise HTTPException(status_code=401, detail=f"Token invalide: {str(e)}")
    except Exception as e:
        print(f"Erreur: {e}")
        raise HTTPException(status_code=500, detail=f"Erreur serveur: {str(e)}")

def get_current_user(authorization: str = Header(None)):
    if not authorization:
        raise HTTPException(status_code=401, detail="Missing token")

    try:
        token = authorization.split(" ")[1] # remove "Bearer "
        payload = verify_access_token(token)

        user_id = payload.get("user_id")
        if not user_id:
            raise HTTPException(status_code=401, detail="Invalid token")

        response = supabase.table("User").select("*").eq("id", user_id).execute()

        if not response.data:
            raise HTTPException(status_code=404, detail="User not found")

        return response.data[0]

    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")

@app.get("/profile")
def get_profile(current_user: dict = Depends(get_current_user)):
    return current_user

@app.get("/articles")
def get_articles(limit: int = 10):
    response = (
        supabase
        .table("articles")
        .select("id, title, description, source, publishedAt")
        .order("publishedAt", desc=True)
        .limit(limit)
        .execute()
    )

    return response.data

@app.get("/magazine")
def get_magazine():
    response = (
        supabase
        .table("magazine")
        .select("id, name, description, private")
        .execute()
    )

    return response.data

@app.post("/magazine")
def create_magazine(mag: dict):
    response = supabase.table("magazine").insert(mag).execute()
    return response.data
