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

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      id: json['id'] as String,
      commodity: json['commodity'] as String,
      variety: json['variety'] as String,
      grade: json['grade'] as String,
      market: json['market'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      date: json['date'] as String,
      minPrice: (json['minPrice'] as num).toDouble(),
      maxPrice: (json['maxPrice'] as num).toDouble(),
      modalPrice: (json['modalPrice'] as num).toDouble(),
      priceChangePercent: (json['priceChangePercent'] as num?)?.toDouble() ?? 0.0,
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
