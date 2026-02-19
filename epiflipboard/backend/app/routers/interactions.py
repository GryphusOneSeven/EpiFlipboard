# app/routers/interactions.py
from fastapi import APIRouter, Body, Depends
from app.supabase_client import supabase
from app.routers.users import get_current_user

router = APIRouter()

@router.post("/like_article")
def like_article(article_id: int = Body(...), current_user: dict = Depends(get_current_user)):
    return supabase.table("likes").upsert({"user_id": current_user["id"], "article_id": article_id}).execute().data

@router.post("/add_to_magazine")
def add_to_magazine(article_id: int = Body(...), magazine_name: str = Body(...), current_user: dict = Depends(get_current_user)):
    return supabase.table("magazine_articles").insert({
        "user_id": current_user["id"],
        "magazine_name": magazine_name,
        "article_id": article_id
    }).execute().data

@router.post("/add_comment")
def add_comment(article_id: int = Body(...), content: str = Body(...), current_user: dict = Depends(get_current_user)):
    return supabase.table("comments").insert({
        "user_id": current_user["id"],
        "article_id": article_id,
        "content": content
    }).execute().data

@router.get("/comments/{article_id}")
def get_comments(article_id: int):
    return supabase.table("comments").select("*").eq("article_id", article_id).execute().data
