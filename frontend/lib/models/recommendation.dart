import 'buyer.dart';

class SplitAllocation {
  final Buyer buyer;
  final String requirementId; // backend requirement_id, used when creating orders
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
    this.requirementId = '',
  });

  factory SplitAllocation.fromJson(Map<String, dynamic> json) {
    return SplitAllocation(
      buyer: Buyer.fromJson(json['buyer'] as Map<String, dynamic>),
      requirementId: json['requirementId']?.toString() ?? '',
      allocatedQtyKg: (json['allocatedQtyKg'] as num).toDouble(),
      pricePerKg: (json['pricePerKg'] as num).toDouble(),
      transportCost: (json['transportCost'] as num).toDouble(),
      spoilageRiskPercentage:
          (json['spoilageRiskPercentage'] as num).toDouble(),
      spoilageLossAmount: (json['spoilageLossAmount'] as num).toDouble(),
      grossRevenue: (json['grossRevenue'] as num).toDouble(),
      netValue: (json['netValue'] as num).toDouble(),
      allocationReason: json['allocationReason']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'buyer': buyer.toJson(),
        'requirementId': requirementId,
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
  // Extra fields populated from backend
  final double remainingQuantityKg;
  final double marketPricePerKg;
  final double bestBuyerPricePerKg;

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
    this.remainingQuantityKg = 0,
    this.marketPricePerKg = 0,
    this.bestBuyerPricePerKg = 0,
  });

  bool get isSplit => allocations.length > 1;
  bool get hasAllocations => allocations.isNotEmpty;
}
