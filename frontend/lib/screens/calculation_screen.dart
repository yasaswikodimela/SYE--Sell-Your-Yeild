import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import 'split_sale_screen.dart';

class CalculationScreen extends StatelessWidget {
  const CalculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final rec = appState.currentRecommendation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Net-Value Calculation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Educational Formula Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.paleGreen,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFC8E6C9), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.functions_rounded,
                          color: AppTheme.primaryGreen, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'SYE Net-Value Formula',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Net In-Hand Value =\nExpected Revenue  −  Transport Freight  −  Spoilage Loss',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGreen,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Traditional mandi sales ignore transit degradation and freight surcharges. SYE maximizes the actual cash you take home.',
                    style: TextStyle(fontSize: 12, color: AppTheme.darkGreen),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Step-by-Step Value Cards (Equation Walkthrough)
            _CalculationStepCard(
              stepNumber: 1,
              title: 'Expected Gross Revenue',
              formulaDesc: 'Total harvest kg × negotiated price/kg',
              amount: '₹${rec.expectedRevenue.toStringAsFixed(0)}',
              isAdd: true,
              color: AppTheme.primaryGreen,
              details: [
                ...rec.allocations.map((a) =>
                    '${a.buyer.buyerName}: ${a.allocatedQtyKg.toInt()} kg @ ₹${a.pricePerKg.toStringAsFixed(1)} = ₹${a.grossRevenue.toInt()}'),
              ],
            ),
            const SizedBox(height: 10),

            _CalculationStepCard(
              stepNumber: 2,
              title: 'Transportation & Logistics Cost',
              formulaDesc: 'Distance km × vehicle rate per kg',
              amount: '- ₹${rec.totalTransportCost.toStringAsFixed(0)}',
              isSubtract: true,
              color: const Color(0xFFE65100),
              details: [
                ...rec.allocations.map((a) =>
                    '${a.buyer.buyerName} (${a.buyer.distanceKm.toInt()} km): ₹${a.buyer.transportCostPerKg}/kg = ₹${a.transportCost.toInt()}'),
              ],
            ),
            const SizedBox(height: 10),

            _CalculationStepCard(
              stepNumber: 3,
              title: 'Expected Transit Spoilage Loss',
              formulaDesc: 'Transit duration vs perishable shelf-life decay',
              amount: '- ₹${rec.expectedSpoilageLoss.toStringAsFixed(0)}',
              isSubtract: true,
              color: AppTheme.dangerRed,
              details: [
                ...rec.allocations.map((a) =>
                    '${a.buyer.buyerName}: ~${a.spoilageRiskPercentage.toStringAsFixed(1)}% estimated transit loss = ₹${a.spoilageLossAmount.toInt()}'),
              ],
            ),
            const SizedBox(height: 14),

            // Final Result Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Expected Net Value',
                        style: TextStyle(
                          color: Color(0xFFC8E6C9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Final In-Pocket Payout',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '₹${rec.expectedNetValue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Comparison Table: SYE Split Plan vs Distant Highest Mandi
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
                      'Strategy Comparison Breakdown',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.4),
                        1: FlexColumnWidth(1.2),
                        2: FlexColumnWidth(1.2),
                      },
                      border: TableBorder(
                        horizontalInside:
                            BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(color: Color(0xFFF9FAFB)),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('Metric',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('Distant Mandi',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text('SYE Plan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppTheme.primaryGreen)),
                            ),
                          ],
                        ),
                        _tableRow('Advertised Rate', '₹33.50/kg', '₹29.40/kg (Avg)'),
                        _tableRow('Gross Sales', '₹33,500', '₹${rec.expectedRevenue.toInt()}'),
                        _tableRow('Transport Cost', '- ₹5,500', '- ₹${rec.totalTransportCost.toInt()}'),
                        _tableRow('Transit Spoilage', '- ₹4,690 (14%)', '- ₹${rec.expectedSpoilageLoss.toInt()} (2.4%)'),
                        _tableRow('Net Take Home', '₹23,310', '₹${rec.expectedNetValue.toInt()}', isBold: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Button to Split Sale Screen
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const SplitSaleScreen()),
                  );
                },
                icon: const Icon(Icons.alt_route_rounded),
                label: const Text('View Split Selling Allocation Breakdown'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  TableRow _tableRow(String label, String naive, String sye, {bool isBold = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(naive,
              style: TextStyle(
                  fontSize: 12,
                  color: isBold ? AppTheme.dangerRed : AppTheme.textMuted,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(sye,
              style: TextStyle(
                  fontSize: 12,
                  color: isBold ? AppTheme.darkGreen : AppTheme.textDark,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600)),
        ),
      ],
    );
  }
}

class _CalculationStepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String formulaDesc;
  final String amount;
  final bool isAdd;
  final bool isSubtract;
  final Color color;
  final List<String> details;

  const _CalculationStepCard({
    required this.stepNumber,
    required this.title,
    required this.formulaDesc,
    required this.amount,
    this.isAdd = false,
    this.isSubtract = false,
    required this.color,
    required this.details,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: color.withOpacity(0.12),
                  child: Text(
                    '$stepNumber',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              formulaDesc,
              style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details.map((d) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_right_rounded,
                            size: 16, color: AppTheme.textMuted),
                        Expanded(
                          child: Text(
                            d,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
