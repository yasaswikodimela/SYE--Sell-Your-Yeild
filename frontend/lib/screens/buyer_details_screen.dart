import 'package:flutter/material.dart';
import '../models/buyer.dart';
import '../services/app_state.dart';
import '../theme.dart';
import 'recommendation_screen.dart';

class BuyerDetailsScreen extends StatelessWidget {
  final Buyer buyer;

  const BuyerDetailsScreen({super.key, required this.buyer});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final produce = appState.activeProduce;

    final double grossRevenue = produce.quantityKg * buyer.pricePerKg;
    final double estimatedTransport = produce.quantityKg * buyer.transportCostPerKg;
    final double estimatedNet = grossRevenue - estimatedTransport;

    return Scaffold(
      appBar: AppBar(
        title: Text(buyer.buyerName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile Card
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFC8E6C9), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppTheme.paleGreen,
                          child: Text(
                            buyer.buyerName.substring(0, 1),
                            style: const TextStyle(
                              color: AppTheme.darkGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      buyer.buyerName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                  ),
                                  if (buyer.isVerified) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified,
                                        color: Color(0xFF10B981), size: 18),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${buyer.businessType} • ⭐ ${buyer.rating} Rating',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '📍 ${buyer.location} (${buyer.distanceKm.toInt()} km away)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    const SizedBox(height: 14),

                    // Price & Capacity highlight box
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.paleGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Offered Price',
                                  style: TextStyle(
                                      fontSize: 11, color: AppTheme.darkGreen),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹${buyer.pricePerKg.toStringAsFixed(1)}/kg',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Max Daily Capacity',
                                  style: TextStyle(
                                      fontSize: 11, color: AppTheme.blueInfo),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${buyer.capacityKg} kg',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.blueInfo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Requirements & Terms
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Procurement Requirements & Terms',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _BuyerSpecRow(
                      icon: Icons.eco_outlined,
                      label: 'Target Commodity',
                      value: buyer.crop,
                    ),
                    _BuyerSpecRow(
                      icon: Icons.verified_outlined,
                      label: 'Required Quality Grade',
                      value: buyer.requiredQuality,
                    ),
                    _BuyerSpecRow(
                      icon: Icons.local_shipping_outlined,
                      label: 'Estimated Freight Cost',
                      value: '₹${buyer.transportCostPerKg}/kg (~₹${(buyer.transportCostPerKg * produce.quantityKg).toInt()} total)',
                    ),
                    _BuyerSpecRow(
                      icon: Icons.payments_outlined,
                      label: 'Payment Terms',
                      value: buyer.paymentTerms,
                    ),
                    _BuyerSpecRow(
                      icon: Icons.phone_in_talk_outlined,
                      label: 'Procurement Desk Phone',
                      value: buyer.contactPhone,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Standalone single-buyer net evaluation
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'If you sell your full 1,000 kg harvest here:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (buyer.capacityKg < produce.quantityKg)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Color(0xFFE65100), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Capacity Bottleneck: This buyer can only take ${buyer.capacityKg} kg. Remaining ${(produce.quantityKg - buyer.capacityKg).toInt()} kg would remain unsold!',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFE65100),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Gross Value at Offered Price:',
                            style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        Text('₹${grossRevenue.toInt()}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Transit & Handling Cost:',
                            style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        Text('-₹${estimatedTransport.toInt()}',
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.dangerRed)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Approximate Direct Net:',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text(
                          '₹${estimatedNet.toInt()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Call to Action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const RecommendationScreen()),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('View SYE Optimized Smart Selling Plan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _BuyerSpecRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _BuyerSpecRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
