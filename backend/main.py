from backend.database import supabase
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

from backend.services.recommendation import calculate_recommendation

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ProduceRequest(BaseModel):
    farmer_id: str
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
class BuyerRegisterRequest(BaseModel):
    phone: str
    password: str
    business_name: str
    contact_person: str
    location: str
    business_type: str
class BuyerLoginRequest(BaseModel):
    phone: str
    password: str
class BuyerVerificationRequest(BaseModel):
    verification_status: str
class AdminLoginRequest(BaseModel):
    phone: str
    password: str
class BuyerRequirementRequest(BaseModel):
    buyer_id: str
    crop: str
    quantity_kg: float
    price_per_kg: float
    quality_required: str
    required_by: str
    transport_cost: float = 0
class OrderRequest(BaseModel):
    farmer_id: str
    buyer_id: str
    requirement_id: str
    crop: str
    quantity_kg: float
    price_per_kg: float
class OrderStatusRequest(BaseModel):
    status: str


def _quality_rank(quality: str) -> int:
    normalized = quality.strip().upper().replace("GRADE ", "")
    return {"A": 3, "B": 2, "C": 1}.get(normalized[:1], 0)

@app.get("/")
def home():
    return {"message": "SYE backend is running!"}


@app.post("/recommendation")
def recommendation(produce: ProduceRequest):

    # Get active buyer requirements
    requirements_response = (
        supabase
        .table("buyer_requirements")
        .select("*")
        .eq("status", "active")
        .eq("crop", produce.crop)
        .execute()
    )

    requirements = requirements_response.data

    if not requirements:
        return {
            "strategy": "no_buyers",
            "expected_net_value": 0,
            "allocations": [],
            "remaining_quantity_kg": produce.quantity_kg,
            "reasons": [
                "No active buyer requirements found for this crop"
            ]
        }

    # Get verified buyers
    buyers_response = (
        supabase
        .table("buyers")
        .select(
            "id, business_name, contact_person, location, "
            "verification_status"
        )
        .eq("verification_status", "verified")
        .execute()
    )

    verified_buyers = buyers_response.data

    # Keep only requirements belonging to verified buyers
    verified_ids = {
        buyer["id"] for buyer in verified_buyers
    }

    valid_requirements = [
        requirement
        for requirement in requirements
        if requirement["buyer_id"] in verified_ids
    ]

    # Convert requirements into the format expected
    # by our recommendation engine
    buyers = []

    for requirement in valid_requirements:

        buyer = next(
            buyer for buyer in verified_buyers
            if buyer["id"] == requirement["buyer_id"]
        )

        buyers.append({
            "id": buyer["id"],
            "requirement_id": requirement["id"],
            "name": buyer["business_name"],
            "location": buyer["location"],
            "crop": requirement["crop"],
            "price_per_kg": float(requirement["price_per_kg"]),
            "capacity_kg": float(requirement["quantity_kg"]),
            "quality_required": requirement["quality_required"],
            "transport_cost": float(requirement["transport_cost"])
        })

    # Get market prices
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
    response = (
        supabase
        .table("buyers")
        .select("*")
        .eq("verification_status", "verified")
        .execute()
    )

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
from postgrest.exceptions import APIError
from fastapi import HTTPException

@app.post("/farmers/register")
def register_farmer(farmer: FarmerRegisterRequest):
    try:
        response = (
            supabase
            .table("farmers")
            .insert(farmer.model_dump())
            .execute()
        )
        return response.data
    except APIError as e:
        if e.code == '23505' or "duplicate key" in e.message.lower():
            raise HTTPException(status_code=400, detail="Phone number already registered")
        raise HTTPException(status_code=500, detail=str(e))
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
@app.post("/buyers/register")
def register_buyer(buyer: BuyerRegisterRequest):
    response = (
        supabase
        .table("buyers")
        .insert({
            "phone": buyer.phone,
            "password": buyer.password,
            "business_name": buyer.business_name,
            "contact_person": buyer.contact_person,
            "location": buyer.location,
            "business_type": buyer.business_type,
            "verification_status": "pending"
        })
        .execute()
    )

    return {
        "success": True,
        "message": "Buyer registered. Verification pending.",
        "buyer": response.data[0]
    }
@app.post("/buyers/login")
def login_buyer(buyer: BuyerLoginRequest):
    response = (
        supabase
        .table("buyers")
        .select("*")
        .eq("phone", buyer.phone)
        .eq("password", buyer.password)
        .execute()
    )

    if not response.data:
        return {
            "success": False,
            "message": "Invalid phone number or password"
        }

    buyer_data = response.data[0]

    return {
        "success": True,
        "verification_status": buyer_data["verification_status"],
        "buyer": buyer_data
    }
@app.patch("/buyers/{buyer_id}/verify")
def verify_buyer(
    buyer_id: str,
    verification: BuyerVerificationRequest
):
    response = (
        supabase
        .table("buyers")
        .update({
            "verification_status": verification.verification_status
        })
        .eq("id", buyer_id)
        .execute()
    )

    if not response.data:
        return {
            "success": False,
            "message": "Buyer not found"
        }

    return {
        "success": True,
        "message": "Buyer verification status updated",
        "buyer": response.data[0]
    }
@app.post("/admin/login")
def login_admin(admin: AdminLoginRequest):
    response = (
        supabase
        .table("admins")
        .select("*")
        .eq("phone", admin.phone)
        .eq("password", admin.password)
        .execute()
    )

    if not response.data:
        return {
            "success": False,
            "message": "Invalid admin phone number or password"
        }

    return {
        "success": True,
        "admin": response.data[0]
    }
@app.post("/buyers/requirements")
def add_buyer_requirement(requirement: BuyerRequirementRequest):

    # Check whether buyer is verified
    buyer_response = (
        supabase
        .table("buyers")
        .select("id, business_name, verification_status")
        .eq("id", requirement.buyer_id)
        .execute()
    )

    if not buyer_response.data:
        return {
            "success": False,
            "message": "Buyer not found"
        }

    buyer = buyer_response.data[0]

    if buyer["verification_status"] != "verified":
        return {
            "success": False,
            "message": "Only verified buyers can add requirements"
        }

    response = (
        supabase
        .table("buyer_requirements")
        .insert({
            "buyer_id": requirement.buyer_id,
            "crop": requirement.crop,
            "quantity_kg": requirement.quantity_kg,
            "price_per_kg": requirement.price_per_kg,
            "quality_required": requirement.quality_required,
            "required_by": requirement.required_by,
            "transport_cost": requirement.transport_cost,
            "status": "active"
        })
        .execute()
    )

    return {
        "success": True,
        "message": "Buyer requirement added",
        "requirement": response.data[0]
    }
@app.get("/buyer-requirements")
def get_buyer_requirements(buyer_id: str | None = None):

    # Get only verified buyers
    buyers_response = (
        supabase
        .table("buyers")
        .select("id, business_name, contact_person, location, verification_status")
        .eq("verification_status", "verified")
        .execute()
    )

    verified_buyers = buyers_response.data

    if not verified_buyers:
        return []

    verified_ids = [buyer["id"] for buyer in verified_buyers]
    if buyer_id is not None and buyer_id not in verified_ids:
        return []

    # Get only active requirements
    requirements_response = (
        supabase
        .table("buyer_requirements")
        .select("*")
        .eq("status", "active")
        .eq("buyer_id", buyer_id) if buyer_id is not None else
        supabase.table("buyer_requirements").select("*").eq("status", "active")
    )

    requirements_response = requirements_response.execute()

    requirements = requirements_response.data

    # Combine requirement + buyer information
    result = []

    for requirement in requirements:
        if requirement["buyer_id"] in verified_ids:

            buyer = next(
                buyer for buyer in verified_buyers
                if buyer["id"] == requirement["buyer_id"]
            )

            result.append({
                "requirement_id": requirement["id"],
                "buyer_id": buyer["id"],
                "business_name": buyer["business_name"],
                "contact_person": buyer["contact_person"],
                "location": buyer["location"],
                "crop": requirement["crop"],
                "quantity_kg": requirement["quantity_kg"],
                "price_per_kg": requirement["price_per_kg"],
                "quality_required": requirement["quality_required"],
                "required_by": requirement["required_by"],
                "transport_cost": requirement.get("transport_cost", 0),
                "status": requirement["status"]
            })

    return result
@app.delete("/buyers/requirements/{requirement_id}")
def delete_buyer_requirement(requirement_id: str):

    response = (
        supabase
        .table("buyer_requirements")
        .update({
            "status": "inactive"
        })
        .eq("id", requirement_id)
        .execute()
    )

    if not response.data:
        return {
            "success": False,
            "message": "Requirement not found"
        }

    return {
        "success": True,
        "message": "Buyer requirement removed",
        "requirement": response.data[0]
    }
class BuyerRequirementUpdateRequest(BaseModel):
    crop: str
    quantity_kg: float
    price_per_kg: float
    quality_required: str
    required_by: str
    transport_cost: float = 0
@app.patch("/buyers/requirements/{requirement_id}")
def update_buyer_requirement(
    requirement_id: str,
    requirement: BuyerRequirementUpdateRequest
):

    # Check that the requirement exists
    existing_response = (
        supabase
        .table("buyer_requirements")
        .select("*")
        .eq("id", requirement_id)
        .execute()
    )

    if not existing_response.data:
        return {
            "success": False,
            "message": "Requirement not found"
        }

    # Update the requirement
    response = (
        supabase
        .table("buyer_requirements")
        .update({
            "crop": requirement.crop,
            "quantity_kg": requirement.quantity_kg,
            "price_per_kg": requirement.price_per_kg,
            "quality_required": requirement.quality_required,
            "required_by": requirement.required_by,
            "transport_cost": requirement.transport_cost,
            "status": "active"
        })
        .eq("id", requirement_id)
        .execute()
    )

    return {
        "success": True,
        "message": "Buyer requirement updated",
        "requirement": response.data[0]
    }
@app.post("/orders")
def create_order(order: OrderRequest):

    requirement_response = (
        supabase.table("buyer_requirements").select("id, buyer_id, status")
        .eq("id", order.requirement_id).execute()
    )
    if (not requirement_response.data or
            requirement_response.data[0]["buyer_id"] != order.buyer_id or
            requirement_response.data[0]["status"] != "active"):
        return {
            "success": False,
            "message": "The selected buyer requirement is no longer active"
        }

    total_amount = order.quantity_kg * order.price_per_kg

    response = (
        supabase
        .table("orders")
        .insert({
            "farmer_id": order.farmer_id,
            "buyer_id": order.buyer_id,
            "requirement_id": order.requirement_id,
            "crop": order.crop,
            "quantity_kg": order.quantity_kg,
            "price_per_kg": order.price_per_kg,
            "total_amount": total_amount,
            "status": "pending"
        })
        .execute()
    )

    return {
        "success": True,
        "message": "Order created successfully",
        "order": response.data[0]
    }
@app.patch("/orders/{order_id}/status")
def update_order_status(
    order_id: str,
    order_status: OrderStatusRequest,
    buyer_id: str
):

    status = order_status.status.strip().lower()

    if status not in ["accepted", "rejected"]:
        return {
            "success": False,
            "message": "Status must be accepted or rejected"
        }

    existing = (
        supabase
        .table("orders")
        .select("id, buyer_id, status")
        .eq("id", order_id)
        .execute()
    )

    if not existing.data:
        return {"success": False, "message": "Order not found"}

    if existing.data[0]["buyer_id"] != buyer_id:
        return {"success": False, "message": "This order belongs to another buyer"}

    if existing.data[0]["status"] != "pending":
        return {"success": False, "message": "Only pending orders can be updated"}

    response = (
        supabase
        .table("orders")
        .update({
            "status": status
        })
        .eq("id", order_id)
        .execute()
    )

    if not response.data:
        return {
            "success": False,
            "message": "Order not found"
        }

    return {
        "success": True,
        "message": f"Order {status}",
        "order": response.data[0]
    }


@app.get("/buyers/{buyer_id}/matching-produce")
def get_matching_produce_for_buyer(buyer_id: str):
    """Return only real, active farmer produce that matches this buyer's
    verified requirements.  No client-side hardcoded offer data is used."""
    buyer_response = (
        supabase.table("buyers").select("id, verification_status")
        .eq("id", buyer_id).execute()
    )
    if not buyer_response.data or buyer_response.data[0]["verification_status"] != "verified":
        return []

    requirements = (
        supabase.table("buyer_requirements").select("*")
        .eq("buyer_id", buyer_id).eq("status", "active").execute().data
    )
    if not requirements:
        return []

    produce_rows = supabase.table("produce").select("*").execute().data
    farmer_rows = supabase.table("farmers").select("id, name, location").execute().data
    farmers = {farmer["id"]: farmer for farmer in farmer_rows}
    matches = []
    for produce in produce_rows:
        for requirement in requirements:
            if produce.get("crop", "").lower() != requirement.get("crop", "").lower():
                continue
            if _quality_rank(str(produce.get("quality", ""))) < _quality_rank(str(requirement.get("quality_required", "C"))):
                continue
            farmer = farmers.get(produce.get("farmer_id"), {})
            matches.append({
                **produce,
                "farmer_name": farmer.get("name", "Farmer"),
                "farmer_location": farmer.get("location", produce.get("location", "")),
                "requirement_id": requirement["id"],
                "offered_price_per_kg": requirement.get("price_per_kg", 0),
            })
            break
    return matches
@app.get("/orders/farmer/{farmer_id}")
def get_farmer_orders(farmer_id: str):

    response = (
        supabase
        .table("orders")
        .select("*")
        .eq("farmer_id", farmer_id)
        .order("created_at", desc=True)
        .execute()
    )

    return response.data
@app.get("/orders/buyer/{buyer_id}")
def get_buyer_orders(buyer_id: str):

    response = (
        supabase
        .table("orders")
        .select("*")
        .eq("buyer_id", buyer_id)
        .order("created_at", desc=True)
        .execute()
    )

    return response.data
@app.get("/produce/farmer/{farmer_id}")
def get_farmer_produce(farmer_id: str):

    response = (
        supabase
        .table("produce")
        .select("*")
        .eq("farmer_id", farmer_id)
        .order("id", desc=True)
        .execute()
    )

    return response.data
@app.get("/admin/buyers/pending")
def get_pending_buyers():

    response = (
        supabase
        .table("buyers")
        .select("*")
        .eq("verification_status", "pending")
        .not_.is_("phone", "null")
        .execute()
    )

    return response.data
