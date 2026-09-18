class Buyer {
  final String id;
  final String buyerName;
  final String businessType; // e.g., 'Retail Chain', 'Mandi Wholesaler', 'Food Processor', 'Local Exporter'
  final String crop;
  final double pricePerKg;
  final int capacityKg;
  final String location;
  final double distanceKm;
  final String requiredQuality; // 'Grade A', 'Grade B', 'Grade C'
  final double transportCostPerKg;
  final double rating;
  final String paymentTerms; // 'Instant UPI / Cash', '24h Bank Transfer'
  final bool isVerified;
  final String contactPhone;

  const Buyer({
    required this.id,
    required this.buyerName,
    required this.businessType,
    required this.crop,
    required this.pricePerKg,
    required this.capacityKg,
    required this.location,
    required this.distanceKm,
    required this.requiredQuality,
    required this.transportCostPerKg,
    this.rating = 4.5,
    this.paymentTerms = 'Instant Bank Transfer',
    this.isVerified = true,
    this.contactPhone = '+91 98765 43210',
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'] as String,
      buyerName: json['buyerName'] as String,
      businessType: json['businessType'] as String? ?? 'Wholesaler',
      crop: json['crop'] as String,
      pricePerKg: (json['pricePerKg'] as num).toDouble(),
      capacityKg: (json['capacityKg'] as num).toInt(),
      location: json['location'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      requiredQuality: json['requiredQuality'] as String,
      transportCostPerKg: (json['transportCostPerKg'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      paymentTerms: json['paymentTerms'] as String? ?? 'Instant Bank Transfer',
      isVerified: json['isVerified'] as bool? ?? true,
      contactPhone: json['contactPhone'] as String? ?? '+91 98765 43210',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'buyerName': buyerName,
        'businessType': businessType,
        'crop': crop,
        'pricePerKg': pricePerKg,
        'capacityKg': capacityKg,
        'location': location,
        'distanceKm': distanceKm,
        'requiredQuality': requiredQuality,
        'transportCostPerKg': transportCostPerKg,
        'rating': rating,
        'paymentTerms': paymentTerms,
        'isVerified': isVerified,
        'contactPhone': contactPhone,
      };

  Buyer copyWith({
    String? id,
    String? buyerName,
    String? businessType,
    String? crop,
    double? pricePerKg,
    int? capacityKg,
    String? location,
    double? distanceKm,
    String? requiredQuality,
    double? transportCostPerKg,
    double? rating,
    String? paymentTerms,
    bool? isVerified,
    String? contactPhone,
  }) {
    return Buyer(
      id: id ?? this.id,
      buyerName: buyerName ?? this.buyerName,
      businessType: businessType ?? this.businessType,
      crop: crop ?? this.crop,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      capacityKg: capacityKg ?? this.capacityKg,
      location: location ?? this.location,
      distanceKm: distanceKm ?? this.distanceKm,
      requiredQuality: requiredQuality ?? this.requiredQuality,
      transportCostPerKg: transportCostPerKg ?? this.transportCostPerKg,
      rating: rating ?? this.rating,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      isVerified: isVerified ?? this.isVerified,
      contactPhone: contactPhone ?? this.contactPhone,
    );
  }
}
