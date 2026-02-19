# app/routers/users.py
from app.auth.jwt import verify_access_token
from fastapi import APIRouter, Depends, HTTPException, Header
from app.supabase_client import supabase

router = APIRouter()

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

@router.post("/add_user")
def create_user(user: dict):
    response = supabase.table("users").insert(user).execute()
    if response.error:
        raise HTTPException(status_code=500, detail=str(response.error))
    return response.data

# Endpoint pour récupérer un utilisateur par id
@router.get("/user_by_id/{user_id}")
def get_user(user_id: int):
    response = supabase.table("users").select("*").eq("id", user_id).execute()
    if response.error:
        raise HTTPException(status_code=500, detail=str(response.error))
    if not response.data:
        raise HTTPException(status_code=404, detail="User not found")
    return response.data[0]

@router.get("/profile")
def get_profile(current_user: dict = Depends(get_current_user)):
    return current_user

@router.get("/profile_stats")
def profile_stats(current_user: dict = Depends(get_current_user)):
    likes = supabase.table("likes").select("*").eq("user_id", current_user["id"]).execute().data
    adds = supabase.table("magazine_articles").select("*").eq("user_id", current_user["id"]).execute().data
    magazines = supabase.table("magazines").select("*").eq("user_id", current_user["id"]).execute().data
    return {
        "likes_count": len(likes),
        "adds_count": len(adds),
        "magazines_count": len(magazines)
    }

@router.post("/add_history")
def add_history(article_id: int, current_user: dict = Depends(get_current_user)):
    response = supabase.table("history").insert({"user_id": current_user["id"], "article_id": article_id}).execute()
    return response.data

@router.get("/history")
def get_history(current_user: dict = Depends(get_current_user)):
    response = supabase.table("history").select("*").eq("user_id", current_user["id"]).execute()
    return response.data
