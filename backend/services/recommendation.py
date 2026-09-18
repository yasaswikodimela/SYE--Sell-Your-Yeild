def calculate_recommendation(produce, buyers, market_prices):
    quantity = produce["quantity_kg"]
    shelf_life = produce["shelf_life_days"]

    # Calculate average mandi modal price
    market_price = 0

    if market_prices:
        valid_prices = [
            float(row["Modal_Price"])
            for row in market_prices
            if row.get("Modal_Price") is not None
        ]

        if valid_prices:
            market_price = sum(valid_prices) / len(valid_prices) / 100

    if not buyers:
        return {
            "strategy": "no_buyers",
            "expected_net_value": 0,
            "allocations": [],
            "remaining_quantity_kg": quantity,
            "reasons": ["No suitable buyers found"]
        }

    # Estimate spoilage risk from shelf life
    if shelf_life <= 2:
        spoilage_rate = 0.10
    elif shelf_life <= 4:
        spoilage_rate = 0.05
    else:
        spoilage_rate = 0.02

    # Quality ranking
    # A = highest quality, C = lowest quality
    quality_rank = {
        "A": 3,
        "B": 2,
        "C": 1
    }

    farmer_quality = quality_rank.get(
        produce["quality"].upper(),
        0
    )

    # Find suitable buyers
    buyer_options = []

    for buyer in buyers:

        # Skip buyers who do not buy this crop
        if buyer.get("crop", "").lower() != produce["crop"].lower():
            continue

        # Check quality requirement
        required_quality = quality_rank.get(
            buyer.get("quality_required", "C").upper(),
            1
        )

        # Skip buyer if farmer's quality is not sufficient
        if farmer_quality < required_quality:
            continue

        value_per_kg = (
            buyer["price_per_kg"] * (1 - spoilage_rate)
        )

        # Compare buyer price with mandi market price
        if market_price > 0:
            market_difference = (
                buyer["price_per_kg"] - market_price
            )
        else:
            market_difference = 0

        buyer_options.append({
            "buyer": buyer["name"],
            "price_per_kg": buyer["price_per_kg"],
            "capacity_kg": buyer["capacity_kg"],
            "transport_cost": buyer.get("transport_cost", 0),
            "quality_required": buyer.get(
                "quality_required",
                "C"
            ),
            "value_per_kg": value_per_kg,
            "market_difference": market_difference
        })

    # No suitable buyers
    if not buyer_options:
        return {
            "strategy": "no_suitable_buyer",
            "expected_net_value": 0,
            "allocations": [],
            "remaining_quantity_kg": quantity,
            "reasons": [
                "No buyer accepts this crop and quality"
            ]
        }

    # Rank buyers using effective value and market comparison
    buyer_options.sort(
        key=lambda x: (
            x["value_per_kg"]
            + (x["market_difference"] * 0.5)
        ),
        reverse=True
    )

    # Allocate produce across buyers
    remaining_quantity = quantity
    allocations = []
    total_net_value = 0

    for buyer in buyer_options:

        if remaining_quantity <= 0:
            break

        allocated_quantity = min(
            remaining_quantity,
            buyer["capacity_kg"]
        )

        revenue = (
            allocated_quantity
            * buyer["price_per_kg"]
        )

        spoilage_loss = (
            revenue
            * spoilage_rate
        )

        net_value = (
            revenue
            - buyer["transport_cost"]
            - spoilage_loss
        )

        allocations.append({
            "buyer": buyer["buyer"],
            "quantity_kg": allocated_quantity,
            "price_per_kg": buyer["price_per_kg"],
            "revenue": round(revenue, 2),
            "transport_cost": buyer["transport_cost"],
            "spoilage_loss": round(spoilage_loss, 2),
            "net_value": round(net_value, 2)
        })

        total_net_value += net_value
        remaining_quantity -= allocated_quantity

    # Decide selling strategy
    if len(allocations) == 0:
        strategy = "no_buyers"
    elif len(allocations) == 1:
        strategy = "single_buyer"
    else:
        strategy = "split"

    # Explanation shown to farmer
    reasons = [
        "Buyer price compared with market price",
        "Transportation cost considered",
        "Spoilage risk considered",
        "Buyer capacity considered",
        "Buyer quality requirements considered",
        "Crop matching considered"
    ]

    if strategy == "split":
        reasons.append(
            "Harvest split across multiple buyers"
        )

    if remaining_quantity > 0:
        reasons.append(
            f"{remaining_quantity} kg has no available buyer capacity"
        )

    return {
        "strategy": strategy,
        "expected_net_value": round(total_net_value, 2),
        "market_price_per_kg": round(market_price, 2),
        "allocations": allocations,
        "remaining_quantity_kg": remaining_quantity,
        "reasons": reasons
    }