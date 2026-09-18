from database import supabase
from fastapi import FastAPI
from pydantic import BaseModel

from services.recommendation import calculate_recommendation

app = FastAPI()


class ProduceRequest(BaseModel):
    crop: str
    quantity_kg: float
    quality: str
    shelf_life_days: int
    location: str


@app.get("/")
def home():
    return {"message": "SYE backend is running!"}


@app.post("/recommendation")
def recommendation(produce: ProduceRequest):
    buyers_response = supabase.table("buyers").select("*").execute()
    buyers = buyers_response.data

    return calculate_recommendation(
        produce.model_dump(),
        buyers
    )
@app.get("/buyers")
def get_buyers():
    response = supabase.table("buyers").select("*").execute()
    return response.data
@app.get("/market-prices/{crop}")
def get_market_prices(crop: str):
    response = (
        supabase
        .table("market_prices")
        .select("*")
        .eq("Commodity", crop)
        .limit(20)
        .execute()
    )

    return response.data