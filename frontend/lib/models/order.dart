class Order {
  final String orderId;
  final String buyerName;
  final String crop;
  final double quantityKg;
  final double pricePerKg;
  final double totalAmount;
  final double transportCost;
  final double netAmount;
  final String status; // 'Confirmed', 'Pending', 'In-Transit', 'Completed'
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
    this.contactPhone = '+91 98765 43210',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] as String,
      buyerName: json['buyerName'] as String,
      crop: json['crop'] as String,
      quantityKg: (json['quantityKg'] as num).toDouble(),
      pricePerKg: (json['pricePerKg'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      transportCost: (json['transportCost'] as num).toDouble(),
      netAmount: (json['netAmount'] as num).toDouble(),
      status: json['status'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      deliveryLocation: json['deliveryLocation'] as String,
      pickupLocation: json['pickupLocation'] as String,
      contactPhone: json['contactPhone'] as String? ?? '+91 98765 43210',
    );
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
