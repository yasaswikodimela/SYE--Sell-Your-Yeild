class MarketPrice {
  final String id;
  final String commodity;
  final String variety;
  final String grade;
  final String market;
  final String district;
  final String state;
  final String date;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;
  final double priceChangePercent;
  final int arrivalsTons;

  const MarketPrice({
    required this.id,
    required this.commodity,
    required this.variety,
    required this.grade,
    required this.market,
    required this.district,
    required this.state,
    required this.date,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    this.priceChangePercent = 0.0,
    this.arrivalsTons = 50,
  });

  /// Parse a real Supabase market_prices row.
  /// The Agmarknet data dump uses PascalCase / underscore column names:
  ///   id, Commodity, Variety, Grade, Market, District, State,
  ///   Arrival_Date, Min_Price, Max_Price, Modal_Price, Arrivals_Tonnes
  /// Prices in the table are stored as paise (×100), so divide by 100
  /// to get ₹/kg.
  factory MarketPrice.fromBackendJson(Map<String, dynamic> json) {
    double parsePrice(dynamic raw) {
      final v = (raw as num?)?.toDouble() ?? 0.0;
      // Agmarknet stores prices as paise; divide by 100 → ₹/kg
      return v / 100.0;
    }

    return MarketPrice(
      id: json['id']?.toString() ?? '',
      commodity: json['Commodity']?.toString() ?? '',
      variety: json['Variety']?.toString() ?? '',
      grade: json['Grade']?.toString() ?? '',
      market: json['Market']?.toString() ?? '',
      district: json['District']?.toString() ?? '',
      state: json['State']?.toString() ?? '',
      date: json['Arrival_Date']?.toString() ?? '',
      minPrice: parsePrice(json['Min_Price']),
      maxPrice: parsePrice(json['Max_Price']),
      modalPrice: parsePrice(json['Modal_Price']),
      priceChangePercent: 0.0,
      arrivalsTons: (json['Arrivals_Tonnes'] as num?)?.toInt() ?? 0,
    );
  }

  /// Legacy fromJson kept for backward compatibility.
  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    // Try backend PascalCase keys first, fall back to camelCase
    if (json.containsKey('Commodity')) {
      return MarketPrice.fromBackendJson(json);
    }
    return MarketPrice(
      id: json['id']?.toString() ?? '',
      commodity: json['commodity']?.toString() ?? '',
      variety: json['variety']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
      market: json['market']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 0.0,
      modalPrice: (json['modalPrice'] as num?)?.toDouble() ?? 0.0,
      priceChangePercent:
          (json['priceChangePercent'] as num?)?.toDouble() ?? 0.0,
      arrivalsTons: (json['arrivalsTons'] as num?)?.toInt() ?? 50,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'commodity': commodity,
        'variety': variety,
        'grade': grade,
        'market': market,
        'district': district,
        'state': state,
        'date': date,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'modalPrice': modalPrice,
        'priceChangePercent': priceChangePercent,
        'arrivalsTons': arrivalsTons,
      };
}
