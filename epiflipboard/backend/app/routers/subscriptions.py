# app/routers/subscriptions.py
from fastapi import APIRouter, Body, Depends
from app.supabase_client import supabase
from app.routers.auth import get_current_user

router = APIRouter()

@router.get("/subscriptions")
def get_user_subscriptions(current_user: dict = Depends(get_current_user)):
    return supabase.table("subscriptions").select("*").eq("user_id", current_user["id"]).execute().data

@router.post("/subscribe")
def subscribe(theme: str = Body(...), current_user: dict = Depends(get_current_user)):
    return supabase.table("subscriptions").upsert({"user_id": current_user["id"], "theme": theme}).execute().data

@router.post("/unsubscribe")
def unsubscribe(theme: str = Body(...), current_user: dict = Depends(get_current_user)):
    return supabase.table("subscriptions").delete().eq("user_id", current_user["id"]).eq("theme", theme).execute().data
