from services.recommendation import calculate_recommendation

produce = {
    "crop": "Tomato",
    "quantity_kg": 1000,
    "quality": "Grade A",
    "shelf_life_days": 4,
    "location": "Vijayawada"
}

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

result = calculate_recommendation(produce, buyers)

print(result)