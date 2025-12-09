import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from .supabase_client import supabase
from . import crud, models

app = FastAPI()

# Autoriser ton front (REMPLACE par l'URL front)
origins = ["https://ton-front.onrender.com", "http://localhost:3000"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"status": "ok"}


# Endpoint pour récupérer tous les utilisateurs
# @app.get("/users")
# def get_users():
#     response = supabase.table("users").select("*").execute()
#     if response.error:
#         raise HTTPException(status_code=500, detail=str(response.error))
#    return response.data

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