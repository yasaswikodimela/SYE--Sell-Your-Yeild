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
    buyers = [
        {
            "name": "FreshMart",
            "price_per_kg": 30,
            "capacity_kg": 600,
            "transport_cost": 1200
        },
        {
            "name": "Krishna Wholesale",
            "price_per_kg": 27,
            "capacity_kg": 500,
            "transport_cost": 600
        },
        {
            "name": "Local Market",
            "price_per_kg": 25,
            "capacity_kg": 1000,
            "transport_cost": 300
        }
    ]

    return calculate_recommendation(
        produce.model_dump(),
        buyers
    )