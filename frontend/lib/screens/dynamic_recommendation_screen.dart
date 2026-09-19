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

  // Simulation parameters (displayed only — what-if simulation shown
  // in this screen uses local variables; the real recommendation
  // is always fetched from the backend via _appState.loadRecommendation())
  double _shelfLifeDays = 4.0;
  bool _hasRecalculated = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _shelfLifeDays =
        _appState.activeProduce.shelfLifeDays.toDouble();
  }

  Future<void> _triggerRecalculation() async {
    setState(() {
      _isLoading = true;
      _hasRecalculated = false;
    });

    // Re-fetch recommendation from backend with current produce data
    await _appState.loadRecommendation();

    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasRecalculated = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recommendation refreshed from backend!'),
          backgroundColor: AppTheme.primaryGreen,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetDefaults() {
    setState(() {
      _shelfLifeDays =
          _appState.activeProduce.shelfLifeDays.toDouble();
      _hasRecalculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        final rec = _appState.currentRecommendation;
        final totalHarvest = _appState.activeProduce.quantityKg;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dynamic What-If Recalculator'),
            actions: [
              IconButton(
                tooltip: 'Reset',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: _resetDefaults,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      Icon(Icons.tune_rounded,
                          color: AppTheme.primaryGreen, size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Refresh the SYE recommendation from the backend engine. The recommendation engine considers buyer capacity, transport costs, spoilage risk, market prices and quality.',
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

                // Simulation info Card
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
                          'Current Produce Parameters',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 14),

                        _InfoRow(
                          label: 'Crop',
                          value: _appState.activeProduce.crop.isEmpty
                              ? 'N/A'
                              : _appState.activeProduce.crop,
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Quantity',
                          value:
                              '${_appState.activeProduce.quantityKg.toInt()} kg',
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Quality',
                          value: _appState.activeProduce.qualityGrade,
                        ),
                        const SizedBox(height: 8),

                        // Shelf life slider (display only; actual shelf life
                        // comes from the produce record)
                        _SliderControl(
                          title: 'Shelf Life Remaining',
                          valueText: '${_shelfLifeDays.toInt()} Days',
                          min: 1,
                          max: 14,
                          divisions: 13,
                          value: _shelfLifeDays,
                          icon: Icons.hourglass_top_outlined,
                          subtitle:
                              'Lower shelf-life → higher spoilage risk in engine',
                          onChanged: (v) =>
                              setState(() => _shelfLifeDays = v),
                        ),

                        const SizedBox(height: 16),

                        // Refresh Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                _isLoading ? null : _triggerRecalculation,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                                  )
                                : const Icon(Icons.bolt_rounded, size: 20),
                            label: Text(
                              _isLoading
                                  ? 'Fetching from backend...'
                                  : 'Refresh Recommendation',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Result Display Card
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
                                'Recommendation Result',
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

                      if (rec.allocations.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'No buyer allocations available. Tap "Refresh Recommendation" to fetch the latest.',
                            style: TextStyle(color: AppTheme.textMuted),
                          ),
                        )
                      else
                        ...rec.allocations.map((alloc) {
                          final share = totalHarvest > 0
                              ? (alloc.allocatedQtyKg / totalHarvest) * 100
                              : 0.0;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFFE5E7EB)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                        }),

                      const SizedBox(height: 10),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Expected Net Take-Home:',
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
                    label: const Text('Proceed with this Plan'),
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
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark)),
      ],
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
