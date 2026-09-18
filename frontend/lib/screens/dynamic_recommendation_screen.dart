import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import 'order_confirmation_screen.dart';

class DynamicRecommendationScreen extends StatefulWidget {
  const DynamicRecommendationScreen({super.key});

  @override
  State<DynamicRecommendationScreen> createState() =>
      _DynamicRecommendationScreenState();
}

class _DynamicRecommendationScreenState
    extends State<DynamicRecommendationScreen> {
  final _appState = AppState();

  late double _transportFactor;
  late double _freshMartCap;
  late double _tirupatiCap;
  late double _shelfLifeDays;

  bool _hasRecalculated = false;

  @override
  void initState() {
    super.initState();
    _transportFactor = _appState.simTransportMultiplier;
    _freshMartCap = _appState.simFreshMartCapacity.toDouble();
    _tirupatiCap = _appState.simTirupatiCapacity.toDouble();
    _shelfLifeDays = _appState.simShelfLifeDays.toDouble();
  }

  void _triggerRecalculation() {
    setState(() {
      _appState.recalculateRecommendation(
        transportFactor: _transportFactor,
        freshMartCap: _freshMartCap.toInt(),
        tirupatiCap: _tirupatiCap.toInt(),
        shelfDays: _shelfLifeDays.toInt(),
      );
      _hasRecalculated = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Strategy dynamically recalculated with updated constraints!'),
        backgroundColor: AppTheme.primaryGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _resetDefaults() {
    setState(() {
      _transportFactor = 1.0;
      _freshMartCap = 600.0;
      _tirupatiCap = 800.0;
      _shelfLifeDays = 4.0;
      _appState.recalculateRecommendation(
        transportFactor: 1.0,
        freshMartCap: 600,
        tirupatiCap: 800,
        shelfDays: 4,
      );
      _hasRecalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rec = _appState.currentRecommendation;
    final totalHarvest = _appState.activeProduce.quantityKg;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic What-If Recalculator'),
        actions: [
          IconButton(
            tooltip: 'Reset to Defaults',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _resetDefaults,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.paleGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC8E6C9)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tune_rounded, color: AppTheme.primaryGreen, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Simulate real-time supply chain shifts (diesel rate spikes, buyer capacity cuts, or shelf-life decay). Watch SYE dynamically re-route kilograms in real time.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.darkGreen,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Simulation Sliders Card
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
                      'Interactive Simulation Parameters',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Slider 1: FreshMart Buyer Capacity
                    _SliderControl(
                      title: 'FreshMart Capacity Limit',
                      valueText: '${_freshMartCap.toInt()} kg',
                      min: 200,
                      max: 1000,
                      divisions: 16,
                      value: _freshMartCap,
                      icon: Icons.inventory_2_outlined,
                      subtitle: 'Simulates buyer reducing or expanding procurement',
                      onChanged: (v) => setState(() => _freshMartCap = v),
                    ),
                    const Divider(height: 24),

                    // Slider 2: Freight & Transport Rate Multiplier
                    _SliderControl(
                      title: 'Diesel / Freight Rate Multiplier',
                      valueText: '${_transportFactor.toStringAsFixed(1)}x (~₹${(1620 * _transportFactor).toInt()})',
                      min: 0.8,
                      max: 2.5,
                      divisions: 17,
                      value: _transportFactor,
                      icon: Icons.local_shipping_outlined,
                      subtitle: 'Simulates fuel price hike or urgent toll charges',
                      onChanged: (v) => setState(() => _transportFactor = v),
                    ),
                    const Divider(height: 24),

                    // Slider 3: Shelf Life Remaining
                    _SliderControl(
                      title: 'Produce Shelf Life Remaining',
                      valueText: '${_shelfLifeDays.toInt()} Days',
                      min: 1,
                      max: 7,
                      divisions: 6,
                      value: _shelfLifeDays,
                      icon: Icons.hourglass_top_outlined,
                      subtitle: 'Lower shelf-life penalizes distant travel',
                      onChanged: (v) => setState(() => _shelfLifeDays = v),
                    ),
                    const SizedBox(height: 16),

                    // Recalculate Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _triggerRecalculation,
                        icon: const Icon(Icons.bolt_rounded, size: 20),
                        label: const Text(
                          'Recalculate Strategy Now',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dynamic Result Display Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _hasRecalculated
                      ? AppTheme.primaryGreen
                      : const Color(0xFFE5E7EB),
                  width: _hasRecalculated ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _hasRecalculated
                                ? Icons.check_circle_rounded
                                : Icons.lightbulb_rounded,
                            color: AppTheme.primaryGreen,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Dynamic Recalculation Result',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.paleGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${totalHarvest.toInt()} kg Harvest',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Updated Dynamic Allocations
                  ...rec.allocations.map((alloc) {
                    final share = (alloc.allocatedQtyKg / totalHarvest) * 100;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                alloc.buyer.buyerName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              Text(
                                '${alloc.allocatedQtyKg.toInt()} kg (${share.toInt()}%)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@ ₹${alloc.pricePerKg.toStringAsFixed(1)}/kg • Freight: ₹${alloc.transportCost.toInt()} • Net: ₹${alloc.netValue.toInt()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 10),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 12),

                  // Net Payout summary
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recalculated Net Take-Home:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                      Text(
                        '₹${rec.expectedNetValue.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Confirm Order from recalculated state
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OrderConfirmationScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Proceed with this Dynamic Plan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SliderControl extends StatelessWidget {
  final String title;
  final String valueText;
  final String subtitle;
  final double min;
  final double max;
  final int divisions;
  final double value;
  final IconData icon;
  final ValueChanged<double> onChanged;

  const _SliderControl({
    required this.title,
    required this.valueText,
    required this.subtitle,
    required this.min,
    required this.max,
    required this.divisions,
    required this.value,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppTheme.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            Text(
              valueText,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppTheme.darkGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.primaryGreen,
            thumbColor: AppTheme.primaryGreen,
            inactiveTrackColor: AppTheme.paleGreen,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
