# app/routers/articles.py
from fastapi import APIRouter, Body, Depends
from app.supabase_client import supabase
from app.routers.users import get_current_user

router = APIRouter()

@router.get("/articles")
def get_all_articles():
    return supabase.table("articles").select("*").execute().data

@router.get("/articles_by_topic/{topic}")
def get_articles_by_topic(topic: str):
    return supabase.table("articles").select("*").eq("topic", topic).execute().data

@router.get("/search_articles")
def search_articles(query: str):
    return supabase.table("articles").select("*").ilike("title", f"%{query}%").execute().data

# @router.post("/add_article")
# def add_article(article: dict = Body(...), current_user: dict = Depends(get_current_user)):
#     article["author_id"] = current_user["id"]
#     return supabase.table("articles").insert(article).execute().data

@router.post("/add_article")
def add_article(article: dict = Body(...)):

    existing = supabase.table("articles").select("id").eq("url", article["url"]).execute()

    if not existing.data:
        return supabase.table("articles").insert(article).execute().data
    else:
        print("article already in DB")
        return existing.data
