class FarmerProfile {
  final String name;
  final String phone;
  final String village;
  final String district;
  final String state;
  final double landSizeAcres;
  final List<String> primaryCrops;
  final String memberSince;
  final String kisanId;

  const FarmerProfile({
    required this.name,
    required this.phone,
    required this.village,
    required this.district,
    required this.state,
    required this.landSizeAcres,
    required this.primaryCrops,
    this.memberSince = 'March 2024',
    this.kisanId = 'AP-KRA-2024-8921',
  });

  factory FarmerProfile.fromJson(Map<String, dynamic> json) {
  final location = json['location']?.toString() ?? '';

  return FarmerProfile(
    name: json['name']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    village: location,
    district: location,
    state: 'Andhra Pradesh',
    landSizeAcres: (json['farm_size'] as num?)?.toDouble() ?? 0.0,
    primaryCrops: (json['main_crops']?.toString() ?? '')
        .split(',')
        .map((crop) => crop.trim())
        .where((crop) => crop.isNotEmpty)
        .toList(),
    memberSince: 'September 2026',
    kisanId: json['id']?.toString() ?? '',
  );
}
  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'village': village,
        'district': district,
        'state': state,
        'landSizeAcres': landSizeAcres,
        'primaryCrops': primaryCrops,
        'memberSince': memberSince,
        'kisanId': kisanId,
      };

  FarmerProfile copyWith({
    String? name,
    String? phone,
    String? village,
    String? district,
    String? state,
    double? landSizeAcres,
    List<String>? primaryCrops,
    String? memberSince,
    String? kisanId,
  }) {
    return FarmerProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      village: village ?? this.village,
      district: district ?? this.district,
      state: state ?? this.state,
      landSizeAcres: landSizeAcres ?? this.landSizeAcres,
      primaryCrops: primaryCrops ?? this.primaryCrops,
      memberSince: memberSince ?? this.memberSince,
      kisanId: kisanId ?? this.kisanId,
    );
  }
}
