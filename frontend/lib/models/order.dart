class Order {
  final String orderId;
  final String buyerName;
  final String crop;
  final double quantityKg;
  final double pricePerKg;
  final double totalAmount;
  final double transportCost;
  final double netAmount;
  final String status; // 'pending', 'accepted', 'rejected', 'Confirmed', 'Completed'
  final DateTime orderDate;
  final String deliveryLocation;
  final String pickupLocation;
  final String contactPhone;

  const Order({
    required this.orderId,
    required this.buyerName,
    required this.crop,
    required this.quantityKg,
    required this.pricePerKg,
    required this.totalAmount,
    required this.transportCost,
    required this.netAmount,
    required this.status,
    required this.orderDate,
    required this.deliveryLocation,
    required this.pickupLocation,
    this.contactPhone = '',
  });

  /// Parse a real Supabase orders row (snake_case columns).
  /// The orders table columns are:
  ///   id, farmer_id, buyer_id, requirement_id, crop,
  ///   quantity_kg, price_per_kg, total_amount, status, created_at
  /// buyerName / locations are not stored in the orders table; they are
  /// populated by the caller from the recommendation context where available.
  factory Order.fromBackendJson(
    Map<String, dynamic> json, {
    String buyerName = '',
    String deliveryLocation = '',
    String pickupLocation = '',
    String contactPhone = '',
    double transportCost = 0.0,
  }) {
    final qty = (json['quantity_kg'] as num?)?.toDouble() ?? 0.0;
    final price = (json['price_per_kg'] as num?)?.toDouble() ?? 0.0;
    final total = (json['total_amount'] as num?)?.toDouble() ?? (qty * price);
    final net = total - transportCost;

    return Order(
      orderId: json['id']?.toString() ?? '',
      buyerName: buyerName,
      crop: json['crop']?.toString() ?? '',
      quantityKg: qty,
      pricePerKg: price,
      totalAmount: total,
      transportCost: transportCost,
      netAmount: net,
      status: _normaliseStatus(json['status']?.toString() ?? 'pending'),
      orderDate: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      deliveryLocation: deliveryLocation,
      pickupLocation: pickupLocation,
      contactPhone: contactPhone,
    );
  }

  /// Legacy fromJson kept for compatibility with any screen that still uses it.
  /// New code should use fromBackendJson.
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId']?.toString() ?? json['id']?.toString() ?? '',
      buyerName: json['buyerName']?.toString() ?? '',
      crop: json['crop']?.toString() ?? '',
      quantityKg: (json['quantityKg'] ?? json['quantity_kg'] as num?)
              ?.toDouble() ??
          0.0,
      pricePerKg: (json['pricePerKg'] ?? json['price_per_kg'] as num?)
              ?.toDouble() ??
          0.0,
      totalAmount: (json['totalAmount'] ?? json['total_amount'] as num?)
              ?.toDouble() ??
          0.0,
      transportCost:
          (json['transportCost'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['netAmount'] as num?)?.toDouble() ?? 0.0,
      status: _normaliseStatus(json['status']?.toString() ?? 'pending'),
      orderDate: json['orderDate'] != null
          ? DateTime.tryParse(json['orderDate'].toString()) ?? DateTime.now()
          : json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString()) ??
                  DateTime.now()
              : DateTime.now(),
      deliveryLocation: json['deliveryLocation']?.toString() ?? '',
      pickupLocation: json['pickupLocation']?.toString() ?? '',
      contactPhone: json['contactPhone']?.toString() ?? '',
    );
  }

  static String _normaliseStatus(String raw) {
    switch (raw.toLowerCase()) {
      case 'accepted':
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      case 'in-transit':
      case 'in_transit':
        return 'In-Transit';
      default:
        return 'Pending';
    }
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'buyerName': buyerName,
        'crop': crop,
        'quantityKg': quantityKg,
        'pricePerKg': pricePerKg,
        'totalAmount': totalAmount,
        'transportCost': transportCost,
        'netAmount': netAmount,
        'status': status,
        'orderDate': orderDate.toIso8601String(),
        'deliveryLocation': deliveryLocation,
        'pickupLocation': pickupLocation,
        'contactPhone': contactPhone,
      };
}
