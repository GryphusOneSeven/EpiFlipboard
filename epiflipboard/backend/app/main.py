import os

from app.routers import articles, auth, interactions, subscriptions, users, magazines
from .models import models
from fastapi import FastAPI, HTTPException, Depends, Header, Query
from fastapi.middleware.cors import CORSMiddleware
from .supabase_client import supabase
from . import crud
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

app.include_router(auth.router)
app.include_router(users.router)
app.include_router(articles.router)
app.include_router(subscriptions.router)
app.include_router(interactions.router)
app.include_router(magazines.router)

@app.get("/")
async def root():
    return {"status": "ok"}


@app.get("/test-db")
def test_db():
    try:
        result = supabase.table("User").select("*").execute()
        return {"status": "ok", "data": result.data}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.get("/magazine")
def get_magazines(owner: int = Query(...)):
    response = (
        supabase
        .table("magazine")
        .select("*")
        .eq("owner", owner)
        .execute()
    )

    return response.data

@app.post("/magazine")
def create_magazine(mag: dict):
    response = supabase.table("magazine").insert(mag).execute()
    return response.data
