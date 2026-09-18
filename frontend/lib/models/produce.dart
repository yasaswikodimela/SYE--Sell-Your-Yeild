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
      id: json['id'] as String,
      crop: json['crop'] as String,
      variety: json['variety'] as String? ?? 'Standard',
      quantityKg: (json['quantityKg'] as num).toDouble(),
      qualityGrade: json['qualityGrade'] as String,
      harvestDate: DateTime.parse(json['harvestDate'] as String),
      shelfLifeDays: (json['shelfLifeDays'] as num).toInt(),
      location: json['location'] as String,
      notes: json['notes'] as String? ?? '',
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
