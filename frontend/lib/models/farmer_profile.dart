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
    return FarmerProfile(
      name: json['name'] as String,
      phone: json['phone'] as String,
      village: json['village'] as String,
      district: json['district'] as String,
      state: json['state'] as String,
      landSizeAcres: (json['landSizeAcres'] as num).toDouble(),
      primaryCrops: List<String>.from(json['primaryCrops'] as List),
      memberSince: json['memberSince'] as String? ?? 'March 2024',
      kisanId: json['kisanId'] as String? ?? 'AP-KRA-2024-8921',
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
