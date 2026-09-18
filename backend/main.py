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
class FarmerRegisterRequest(BaseModel):
    phone: str
    password: str
    name: str
    location: str
    farm_name: str
    farm_size: float
    main_crops: str
class FarmerLoginRequest(BaseModel):
    phone: str
    password: str


@app.get("/")
def home():
    return {"message": "SYE backend is running!"}


@app.post("/recommendation")
def recommendation(produce: ProduceRequest):
    buyers_response = supabase.table("buyers").select("*").execute()
    buyers = buyers_response.data

    market_response = (
        supabase
        .table("market_prices")
        .select("*")
        .eq("Commodity", produce.crop)
        .limit(20)
        .execute()
    )

    market_prices = market_response.data

    return calculate_recommendation(
        produce.model_dump(),
        buyers,
        market_prices
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
@app.post("/produce")
def add_produce(produce: ProduceRequest):
    response = (
        supabase
        .table("produce")
        .insert(produce.model_dump())
        .execute()
    )

    return response.data
@app.get("/produce")
def get_produce():
    response = (
        supabase
        .table("produce")
        .select("*")
        .execute()
    )

    return response.data
@app.post("/farmers/register")
def register_farmer(farmer: FarmerRegisterRequest):
    response = (
        supabase
        .table("farmers")
        .insert(farmer.model_dump())
        .execute()
    )

    return response.data
@app.post("/farmers/login")
def login_farmer(farmer: FarmerLoginRequest):
    response = (
        supabase
        .table("farmers")
        .select("*")
        .eq("phone", farmer.phone)
        .eq("password", farmer.password)
        .execute()
    )

    if not response.data:
        return {
            "success": False,
            "message": "Invalid phone number or password"
        }

    return {
        "success": True,
        "farmer": response.data[0]
    }