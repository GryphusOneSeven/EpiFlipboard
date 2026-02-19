from fastapi import APIRouter, HTTPException
from app.supabase_client import supabase

router = APIRouter()

@router.delete("/magazine/{magazine_id}")
def delete_magazine(magazine_id: int):
    # Vérifie si le magazine existe
    response = supabase.table("magazine").select("*").eq("id", magazine_id).execute()
    if not response.data:
        raise HTTPException(status_code=404, detail="Magazine non trouvé")
    
    # Supprime les liens dans magazine_article
    supabase.table("magazine_article").delete().eq("magazine_id", magazine_id).execute()
    
    # Supprime le magazine
    supabase.table("magazine").delete().eq("id", magazine_id).execute()
    
    return {"message": "Magazine supprimé"}
