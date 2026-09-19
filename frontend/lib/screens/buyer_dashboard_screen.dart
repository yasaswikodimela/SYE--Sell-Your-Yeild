import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import 'dashboard_screen.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
  final _appState = AppState();
  double _myCapacity = 600.0;
  double _offeredRate = 30.0;
  String _selectedCrop = 'Tomato';
  String _selectedGrade = 'Grade A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SYE Buyer Procurement Desk'),
        actions: [
          TextButton.icon(
            onPressed: () {
              _appState.isFarmerMode = true;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
            icon: const Icon(Icons.swap_horiz_rounded,
                color: AppTheme.primaryGreen),
            label: const Text(
              'Farmer Mode',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buyer Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.storefront_rounded,
                              color: Color(0xFF38BDF8), size: 24),
                          SizedBox(width: 8),
                          Text(
                            'FreshMart Superstores',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Verified Buyer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Procurement Hub: Auto Nagar, Vijayawada • Operating Capacity: 600 kg/day',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Purchasing Capacity Management Card
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Procurement Capacity',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          '${_myCapacity.toInt()} kg / day',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppTheme.primaryGreen,
                        thumbColor: AppTheme.primaryGreen,
                      ),
                      child: Slider(
                        value: _myCapacity,
                        min: 200,
                        max: 2000,
                        divisions: 18,
                        onChanged: (v) {
                          setState(() => _myCapacity = v);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Min: 200 kg',
                            style: TextStyle(
                                fontSize: 11, color: AppTheme.textMuted)),
                        const Text('Max: 2000 kg',
                            style: TextStyle(
                                fontSize: 11, color: AppTheme.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Publish Buying Request Card
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
                      'Post Procurement Demand / Rate',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCrop,
                            decoration: const InputDecoration(
                              labelText: 'Commodity',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'Tomato', child: Text('Tomato')),
                              DropdownMenuItem(
                                  value: 'Chilli', child: Text('Chilli')),
                              DropdownMenuItem(
                                  value: 'Onion', child: Text('Onion')),
                            ],
                            onChanged: (v) =>
                                setState(() => _selectedCrop = v!),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedGrade,
                            decoration: const InputDecoration(
                              labelText: 'Grade',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  value: 'Grade A', child: Text('Grade A')),
                              DropdownMenuItem(
                                  value: 'Grade B', child: Text('Grade B')),
                            ],
                            onChanged: (v) =>
                                setState(() => _selectedGrade = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _offeredRate.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Buying Rate Offered',
                              prefixText: '₹',
                              suffixText: '/kg',
                            ),
                            onChanged: (v) {
                              final d = double.tryParse(v);
                              if (d != null) _offeredRate = d;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Demand posted: ${_myCapacity.toInt()} kg $_selectedCrop @ ₹$_offeredRate/kg'),
                                  backgroundColor: AppTheme.primaryGreen,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Update Demand'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Live Farmer Harvests Matching Demand
            const Text(
              'Available Farmer Harvests Nearby:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            ..._appState.produceList.map((prod) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.paleGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.eco_rounded,
                            color: AppTheme.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${prod.quantityKg.toInt()} kg ${prod.crop} (${prod.qualityGrade})',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '📍 ${prod.location} • Shelf Life: ${prod.shelfLifeDays} days',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Offer sent to farmer for ${prod.crop}!'),
                              backgroundColor: AppTheme.primaryGreen,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Make Offer',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
