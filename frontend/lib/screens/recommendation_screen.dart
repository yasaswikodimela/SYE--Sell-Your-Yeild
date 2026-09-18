import 'package:flutter/material.dart';
import '../models/recommendation.dart';
import '../services/app_state.dart';
import '../theme.dart';
import 'calculation_screen.dart';
import 'dynamic_recommendation_screen.dart';
import 'order_confirmation_screen.dart';
import 'split_sale_screen.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        final rec = _appState.currentRecommendation;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Smart Selling Recommendation'),
            actions: [
              IconButton(
                tooltip: 'Dynamic What-If Recalculator',
                icon: const Icon(Icons.tune_rounded, color: AppTheme.primaryGreen),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const DynamicRecommendationScreen()),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.darkGreen, Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.auto_awesome,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'AI OPTIMIZED PLAN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Harvest: ${rec.totalQuantityKg.toInt()} kg ${rec.crop}',
                            style: const TextStyle(
                              color: Color(0xFFC8E6C9),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Expected In-Hand Net Value',
                        style: TextStyle(
                          color: Color(0xFFE8F5E9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₹${rec.expectedNetValue.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(Gross: ₹${rec.expectedRevenue.toInt()})',
                            style: const TextStyle(
                              color: Color(0xFFC8E6C9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _MetricMini(
                            label: 'Freight Cost',
                            value: '-₹${rec.totalTransportCost.toInt()}',
                            isNegative: true,
                          ),
                          _MetricMini(
                            label: 'Spoilage Loss',
                            value: '-₹${rec.expectedSpoilageLoss.toInt()}',
                            isNegative: true,
                          ),
                          _MetricMini(
                            label: 'Extra Profit vs Highest Mandi',
                            value: '+₹${rec.netGainOverNaive.toInt()}',
                            isHighlight: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Critical Insight Callout: Why headline price is misleading
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined,
                          color: AppTheme.blueInfo, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Why Not Sell to the Highest Advertised Price?',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.blueInfo,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hyderabad Mandi offers ₹33.50/kg, but at 280km distance, transport costs ₹5,500 and 14% spoilage causes ₹4,690 loss. Your real net profit would be only ₹23,310. SYE Smart Allocation yields ₹${rec.expectedNetValue.toInt()} (+₹${rec.netGainOverNaive.toInt()} extra)!',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E3A8A),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Recommended Split Allocations Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Optimized Multi-Buyer Allocation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const SplitSaleScreen()),
                        );
                      },
                      child: const Text('Split Analysis →'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Allocation Cards
                ...rec.allocations.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final alloc = entry.value;
                  return _AllocationDetailCard(
                    allocation: alloc,
                    index: idx + 1,
                    totalQuantity: rec.totalQuantityKg,
                  );
                }).toList(),

                const SizedBox(height: 16),

                // "WHY THIS STRATEGY?" Section (Deep explanation)
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Color(0xFFC8E6C9), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.psychology_alt_outlined,
                                color: AppTheme.primaryGreen, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Why This Strategy?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          rec.whyThisStrategy,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textDark,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Color(0xFFE5E7EB)),
                        const SizedBox(height: 14),
                        const Text(
                          '8 Decision Factors Evaluated:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...rec.decisionFactors.map((factor) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle,
                                    color: AppTheme.primaryGreen, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '${factor.title}: ',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textDark,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: factor.description,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: AppTheme.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Quick Navigation Grid to other Core Feature Screens
                Row(
                  children: [
                    Expanded(
                      child: _FeatureNavButton(
                        icon: Icons.calculate_outlined,
                        title: 'Net Calculation',
                        subtitle: 'Step-by-step formula',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const CalculationScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _FeatureNavButton(
                        icon: Icons.alt_route_rounded,
                        title: 'Split Selling',
                        subtitle: 'Capacity distribution',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SplitSaleScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _FeatureNavButton(
                  icon: Icons.tune_rounded,
                  title: 'Dynamic What-If Recalculator',
                  subtitle: 'Simulate diesel rate spikes or buyer capacity changes',
                  isFullWidth: true,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) =>
                              const DynamicRecommendationScreen()),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Primary Execution CTA
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const OrderConfirmationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded),
                        SizedBox(width: 8),
                        Text(
                          'Confirm & Create Farmer Orders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricMini extends StatelessWidget {
  final String label;
  final String value;
  final bool isNegative;
  final bool isHighlight;

  const _MetricMini({
    required this.label,
    required this.value,
    this.isNegative = false,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFC8E6C9),
            fontSize: 10.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: isHighlight
                ? const Color(0xFFFFD54F)
                : isNegative
                    ? const Color(0xFFFFCDD2)
                    : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _AllocationDetailCard extends StatelessWidget {
  final SplitAllocation allocation;
  final int index;
  final double totalQuantity;

  const _AllocationDetailCard({
    required this.allocation,
    required this.index,
    required this.totalQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (allocation.allocatedQtyKg / totalQuantity) * 100;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB), width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Buyer Name, Quantity and Percent Share
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppTheme.paleGreen,
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allocation.buyer.buyerName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        '${allocation.buyer.location} (${allocation.buyer.distanceKm.toInt()}km)',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.paleGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${allocation.allocatedQtyKg.toInt()} kg (${pct.toInt()}%)',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 10),

            // Financial breakdown row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SubStat(
                    title: 'Price/kg',
                    value: '₹${allocation.pricePerKg.toStringAsFixed(1)}'),
                _SubStat(
                    title: 'Gross Revenue',
                    value: '₹${allocation.grossRevenue.toInt()}'),
                _SubStat(
                    title: 'Transport',
                    value: '-₹${allocation.transportCost.toInt()}'),
                _SubStat(
                    title: 'Net In-Hand',
                    value: '₹${allocation.netValue.toInt()}',
                    isGreen: true),
              ],
            ),
            const SizedBox(height: 10),

            // Reason Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FBF6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                '💡 ${allocation.allocationReason}',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppTheme.textDark,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubStat extends StatelessWidget {
  final String title;
  final String value;
  final bool isGreen;

  const _SubStat({
    required this.title,
    required this.value,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 10.5, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isGreen ? AppTheme.darkGreen : AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

class _FeatureNavButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isFullWidth;

  const _FeatureNavButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.paleGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 18, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
