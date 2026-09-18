import 'package:flutter/material.dart';
import '../models/recommendation.dart';
import '../theme.dart';

class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback? onExploreDetails;
  final VoidCallback? onRecalculate;
  final VoidCallback? onConfirmOrder;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.onExploreDetails,
    this.onRecalculate,
    this.onConfirmOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFC8E6C9), width: 1.2),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFF9FDF8)],
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge: Optimized Plan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.paleGreen,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.lightGreen, width: 0.8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome,
                          size: 14, color: AppTheme.primaryGreen),
                      SizedBox(width: 5),
                      Text(
                        'SYE OPTIMIZED SELLING PLAN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (recommendation.isSplit)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Split Sale Active',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE65100),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Harvest Summary Title
            Row(
              children: [
                const Icon(Icons.eco_rounded,
                    color: AppTheme.primaryGreen, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Harvest: ${recommendation.totalQuantityKg.toInt()} kg ${recommendation.crop}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Allocation Cards / Rows
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8F3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommended Distribution:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...recommendation.allocations.map((alloc) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${alloc.allocatedQtyKg.toInt()} kg → ${alloc.buyer.buyerName}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          Text(
                            '@ ₹${alloc.pricePerKg.toStringAsFixed(1)}/kg',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkGreen,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Net Value Metric Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.paleGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Expected Net In-Hand Value:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                      Text(
                        '₹${recommendation.expectedNetValue.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gross: ₹${recommendation.expectedRevenue.toInt()}  |  Transport: -₹${recommendation.totalTransportCost.toInt()}  |  Spoilage: -₹${recommendation.expectedSpoilageLoss.toInt()}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Advantage over naive single buyer
            if (recommendation.netGainOverNaive > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up_rounded,
                        color: AppTheme.blueInfo, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '+₹${recommendation.netGainOverNaive.toInt()} higher real profit vs highest advertised distant mandi!',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.blueInfo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),

            // Action Buttons
            Row(
              children: [
                if (onExploreDetails != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onExploreDetails,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('Why This Plan?'),
                    ),
                  ),
                if (onExploreDetails != null && onConfirmOrder != null)
                  const SizedBox(width: 10),
                if (onConfirmOrder != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConfirmOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('Execute Plan'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
