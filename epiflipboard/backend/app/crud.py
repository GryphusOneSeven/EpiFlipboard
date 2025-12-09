from .supabase_client import supabase

# USERS
# def get_users(limit: int = 10):
#     response = supabase.table("users").select("*").limit(limit).execute()
#     return response.data

def create_user(user: dict):
    response = supabase.table("users").insert(user).execute()
    return response.data

# POSTS
def get_posts(limit: int = 10):
    response = supabase.table("posts").select("*").limit(limit).execute()
    return response.data

def create_post(post: dict):
    response = supabase.table("posts").insert(post).execute()
    return response.data

# LIKES
def get_likes(limit: int = 10):
    response = supabase.table("likes").select("*").limit(limit).execute()
    return response.data

def create_like(like: dict):
    response = supabase.table("likes").insert(like).execute()
    return response.data
