class Produce {
  final String id;
  final String crop;
  final String variety;
  final double quantityKg;
  final String qualityGrade; // 'Grade A', 'Grade B', 'Grade C'
  final DateTime harvestDate;
  final int shelfLifeDays;
  final String location;
  final String notes;

  const Produce({
    required this.id,
    required this.crop,
    required this.variety,
    required this.quantityKg,
    required this.qualityGrade,
    required this.harvestDate,
    required this.shelfLifeDays,
    required this.location,
    this.notes = '',
  });

  factory Produce.fromJson(Map<String, dynamic> json) {
  return Produce(
    id: json['id']?.toString() ?? '',
    crop: json['crop']?.toString() ?? '',
    variety: json['variety']?.toString() ?? 'Standard',
    quantityKg: (json['quantity_kg'] as num?)?.toDouble() ?? 0.0,
    qualityGrade: json['quality']?.toString() ?? 'Grade C',
    harvestDate: json['harvest_date'] != null
        ? DateTime.parse(json['harvest_date'].toString())
        : DateTime.now(),
    shelfLifeDays: (json['shelf_life_days'] as num?)?.toInt() ?? 0,
    location: json['location']?.toString() ?? '',
    notes: json['notes']?.toString() ?? '',
  );
}

  Map<String, dynamic> toJson() => {
        'id': id,
        'crop': crop,
        'variety': variety,
        'quantityKg': quantityKg,
        'qualityGrade': qualityGrade,
        'harvestDate': harvestDate.toIso8601String(),
        'shelfLifeDays': shelfLifeDays,
        'location': location,
        'notes': notes,
      };

  Produce copyWith({
    String? id,
    String? crop,
    String? variety,
    double? quantityKg,
    String? qualityGrade,
    DateTime? harvestDate,
    int? shelfLifeDays,
    String? location,
    String? notes,
  }) {
    return Produce(
      id: id ?? this.id,
      crop: crop ?? this.crop,
      variety: variety ?? this.variety,
      quantityKg: quantityKg ?? this.quantityKg,
      qualityGrade: qualityGrade ?? this.qualityGrade,
      harvestDate: harvestDate ?? this.harvestDate,
      shelfLifeDays: shelfLifeDays ?? this.shelfLifeDays,
      location: location ?? this.location,
      notes: notes ?? this.notes,
    );
  }
}
