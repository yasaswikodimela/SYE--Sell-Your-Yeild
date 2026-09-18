import 'buyer.dart';

class SplitAllocation {
  final Buyer buyer;
  final double allocatedQtyKg;
  final double pricePerKg;
  final double transportCost;
  final double spoilageRiskPercentage;
  final double spoilageLossAmount;
  final double grossRevenue;
  final double netValue;
  final String allocationReason;

  const SplitAllocation({
    required this.buyer,
    required this.allocatedQtyKg,
    required this.pricePerKg,
    required this.transportCost,
    required this.spoilageRiskPercentage,
    required this.spoilageLossAmount,
    required this.grossRevenue,
    required this.netValue,
    required this.allocationReason,
  });

  factory SplitAllocation.fromJson(Map<String, dynamic> json) {
    return SplitAllocation(
      buyer: Buyer.fromJson(json['buyer'] as Map<String, dynamic>),
      allocatedQtyKg: (json['allocatedQtyKg'] as num).toDouble(),
      pricePerKg: (json['pricePerKg'] as num).toDouble(),
      transportCost: (json['transportCost'] as num).toDouble(),
      spoilageRiskPercentage: (json['spoilageRiskPercentage'] as num).toDouble(),
      spoilageLossAmount: (json['spoilageLossAmount'] as num).toDouble(),
      grossRevenue: (json['grossRevenue'] as num).toDouble(),
      netValue: (json['netValue'] as num).toDouble(),
      allocationReason: json['allocationReason'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'buyer': buyer.toJson(),
        'allocatedQtyKg': allocatedQtyKg,
        'pricePerKg': pricePerKg,
        'transportCost': transportCost,
        'spoilageRiskPercentage': spoilageRiskPercentage,
        'spoilageLossAmount': spoilageLossAmount,
        'grossRevenue': grossRevenue,
        'netValue': netValue,
        'allocationReason': allocationReason,
      };
}

class DecisionFactor {
  final String title;
  final String impact; // 'Positive', 'Warning', 'Optimal'
  final String description;

  const DecisionFactor({
    required this.title,
    required this.impact,
    required this.description,
  });
}

class Recommendation {
  final String id;
  final String crop;
  final double totalQuantityKg;
  final List<SplitAllocation> allocations;
  final double expectedRevenue;
  final double totalTransportCost;
  final double expectedSpoilageLoss;
  final double expectedNetValue;
  final String strategySummary;
  final String whyThisStrategy;
  final double naiveSingleBuyerNetValue;
  final double netGainOverNaive;
  final List<DecisionFactor> decisionFactors;

  const Recommendation({
    required this.id,
    required this.crop,
    required this.totalQuantityKg,
    required this.allocations,
    required this.expectedRevenue,
    required this.totalTransportCost,
    required this.expectedSpoilageLoss,
    required this.expectedNetValue,
    required this.strategySummary,
    required this.whyThisStrategy,
    required this.naiveSingleBuyerNetValue,
    required this.netGainOverNaive,
    required this.decisionFactors,
  });

  bool get isSplit => allocations.length > 1;
}
