class Buyer {
  final String id;
  final String buyerName;
  final String businessType;
  final String crop;
  final double pricePerKg;
  final int capacityKg;
  final String location;
  final double distanceKm;
  final String requiredQuality;
  final double transportCostPerKg;
  final double rating;
  final String paymentTerms;
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
    this.contactPhone = '',
  });

  /// Parse a real Supabase buyers row (snake_case columns).
  /// buyers table: id, phone, business_name, contact_person,
  ///               location, business_type, verification_status
  /// Combined with buyer_requirements fields when available:
  ///   crop, quantity_kg, price_per_kg, quality_required, transport_cost
  factory Buyer.fromBackendJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id']?.toString() ?? '',
      buyerName: json['business_name']?.toString() ?? '',
      businessType: json['business_type']?.toString() ?? 'Wholesaler',
      crop: json['crop']?.toString() ?? '',
      pricePerKg: (json['price_per_kg'] as num?)?.toDouble() ?? 0.0,
      capacityKg: (json['quantity_kg'] as num?)?.toInt() ??
          (json['capacity_kg'] as num?)?.toInt() ??
          0,
      location: json['location']?.toString() ?? '',
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      requiredQuality: json['quality_required']?.toString() ?? 'C',
      transportCostPerKg:
          (json['transport_cost'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      paymentTerms:
          json['payment_terms']?.toString() ?? 'Instant Bank Transfer',
      isVerified:
          json['verification_status']?.toString() == 'verified',
      contactPhone: json['phone']?.toString() ?? '',
    );
  }

  /// Legacy fromJson kept for backward compatibility.
  /// Detects backend snake_case keys automatically.
  factory Buyer.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('business_name')) {
      return Buyer.fromBackendJson(json);
    }
    return Buyer(
      id: json['id']?.toString() ?? '',
      buyerName: json['buyerName']?.toString() ?? '',
      businessType: json['businessType']?.toString() ?? 'Wholesaler',
      crop: json['crop']?.toString() ?? '',
      pricePerKg: (json['pricePerKg'] as num?)?.toDouble() ?? 0.0,
      capacityKg: (json['capacityKg'] as num?)?.toInt() ?? 0,
      location: json['location']?.toString() ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      requiredQuality: json['requiredQuality']?.toString() ?? 'C',
      transportCostPerKg:
          (json['transportCostPerKg'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      paymentTerms:
          json['paymentTerms']?.toString() ?? 'Instant Bank Transfer',
      isVerified: json['isVerified'] as bool? ?? true,
      contactPhone: json['contactPhone']?.toString() ?? '',
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
