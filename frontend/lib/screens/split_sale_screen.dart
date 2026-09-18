import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import 'dynamic_recommendation_screen.dart';
import 'order_confirmation_screen.dart';

class SplitSaleScreen extends StatelessWidget {
  const SplitSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final rec = appState.currentRecommendation;
    final produce = appState.activeProduce;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Split-Sale Optimization'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Callout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.paleGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC8E6C9)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.alt_route_rounded,
                      color: AppTheme.primaryGreen, size: 26),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Why Split Sale? Most farmers lose money forcing 100% of harvest to a single buyer. SYE splits quantity to match buyer capacity and eliminate distress discounts.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.darkGreen,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Visual Harvest Distribution Bar
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Harvest Allocation',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          '${produce.quantityKg.toInt()} kg ${produce.crop}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Stacked visual bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 24,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 60,
                              child: Container(
                                color: AppTheme.primaryGreen,
                                alignment: Alignment.center,
                                child: const Text(
                                  'FreshMart: 600 kg (60%)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 40,
                              child: Container(
                                color: const Color(0xFF10B981),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Tirupati Agro: 400 kg (40%)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _LegendItem(
                          color: AppTheme.primaryGreen,
                          label: 'FreshMart (600 kg)',
                        ),
                        _LegendItem(
                          color: const Color(0xFF10B981),
                          label: 'Tirupati Agro (400 kg)',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // The 4 Core Advantages of Splitting
            const Text(
              '4 Core Advantages of Split Selling:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 10),

            _AdvantageCard(
              icon: Icons.compress_rounded,
              title: '1. Overcomes Buyer Capacity Caps',
              description:
                  'FreshMart pays top rupee (₹30/kg) but caps purchase at 600kg. Splitting routes remaining 400kg immediately instead of leaving it stranded or rotting.',
              color: AppTheme.primaryGreen,
            ),
            const SizedBox(height: 10),

            _AdvantageCard(
              icon: Icons.shield_rounded,
              title: '2. De-Risks Payment & Single-Buyer Dependency',
              description:
                  'Dividing yield between modern retail (FreshMart) and industrial processing (Tirupati Agro) guarantees guaranteed payment and rapid settlement.',
              color: AppTheme.blueInfo,
            ),
            const SizedBox(height: 10),

            _AdvantageCard(
              icon: Icons.timer_outlined,
              title: '3. Zero Spoilage During Perishable Window',
              description:
                  'Both buyers are located within 25 km of Gannavaram. Harvest reaches crates in under 2 hours with under 3% transit spoilage.',
              color: const Color(0xFFE65100),
            ),
            const SizedBox(height: 10),

            _AdvantageCard(
              icon: Icons.currency_rupee_rounded,
              title: '4. Maximized Net Realization',
              description:
                  'Generates ₹${rec.expectedNetValue.toInt()} total in-hand cash vs ₹23,310 from single-destination long distance transit.',
              color: const Color(0xFF059669),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const DynamicRecommendationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.tune_rounded),
                    label: const Text('Simulate Changes'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const OrderConfirmationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text('Confirm Split'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

class _AdvantageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _AdvantageCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
