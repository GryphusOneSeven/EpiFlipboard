# app/routers/auth.py
import os
from fastapi import APIRouter, HTTPException, Depends, Body
from pydantic import BaseModel
from google.oauth2 import id_token
from google.auth.transport import requests
from app.supabase_client import supabase
from app.auth.jwt import create_access_token
from fastapi import Header
import bcrypt

router = APIRouter()

class TokenSchema(BaseModel):
    token: str

@router.post("/auth/google/mobile")
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



class RegisterSchema(BaseModel):
    email: str
    password: str
    name: str

@router.post("/auth/register")
async def register_user(data: RegisterSchema):
    # Vérifier si l'utilisateur existe déjà
    existing = supabase.table("User").select("*").eq("email", data.email).execute()
    if existing.data:
        raise HTTPException(status_code=400, detail="Email déjà utilisé")

    # 🔐 Hasher le mot de passe
    hashed_password = bcrypt.hashpw(
        data.password.encode("utf-8"),
        bcrypt.gensalt()
    ).decode("utf-8")

    user_data = {
        "email": data.email,
        "password": hashed_password,
        "name": data.name,
        "auth_provider": "local",
        "profile_picture": None
    }

    response = supabase.table("User").insert(user_data).execute()
    user = response.data[0]

    token = create_access_token({
        "sub": user["email"],
        "user_id": user["id"]
    })

    return {
        "message": "Utilisateur créé",
        "token": token,
        "user": user
    }



class LoginSchema(BaseModel):
    email: str
    password: str

@router.post("/auth/login")
async def login_user(data: LoginSchema):
    response = supabase.table("User").select("*").eq("email", data.email).execute()

    if not response.data:
        raise HTTPException(status_code=401, detail="Utilisateur non trouvé")

    user = response.data[0]

    # 🔎 Vérifier le mot de passe hashé
    if not user["password"]:
        raise HTTPException(status_code=401, detail="Compte invalide")

    password_match = bcrypt.checkpw(
        data.password.encode("utf-8"),
        user["password"].encode("utf-8")
    )

    if not password_match:
        raise HTTPException(status_code=401, detail="Mot de passe incorrect")

    token = create_access_token({
        "sub": user["email"],
        "user_id": user["id"]
    })

    return {
        "message": "Connexion réussie",
        "token": token,
        "user": user
    }