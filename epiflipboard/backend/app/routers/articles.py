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

@router.post("/add_article")
def add_article(article: dict = Body(...), current_user: dict = Depends(get_current_user)):
    article["author_id"] = current_user["id"]
    return supabase.table("articles").insert(article).execute().data

@router.get("/magazine/{magazine_id}/articles")
def get_articles_by_magazine(magazine_id: int):
    # On récupère les relations dans magazine_article
    link_response = (
        supabase.table("magazine_article")
        .select("article_id")
        .eq("magazine_id", magazine_id)
        .execute()
    )
    article_links = link_response.data
    print(article_links)

    if not article_links:
        return []

    # On récupère tous les articles correspondants
    article_ids = [link["article_id"] for link in article_links]
    articles_response = (
        supabase.table("articles")
        .select("*")
        .in_("id", article_ids)
        .execute()
    )

    # Transformation pour correspondre au format attendu par le frontend
    transformed_articles = []
    for art in articles_response.data:
        transformed_articles.append({
            "title": art.get("title", ""),
            "source": {"name": art.get("source", "")},  # <- ici la transformation
            "urlToImage": art.get("urlToImage", ""),
            "url": art.get("url", ""),
            "description": art.get("description", ""),
            "content": art.get("content", ""),
            "author": art.get("author", ""),
            "publishedAt": art.get("publishedAt", ""),
        })

    return transformed_articles