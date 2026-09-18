import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/buyer_card.dart';
import 'buyer_details_screen.dart';
import 'recommendation_screen.dart';

class BuyerMarketplaceScreen extends StatefulWidget {
  const BuyerMarketplaceScreen({super.key});

  @override
  State<BuyerMarketplaceScreen> createState() => _BuyerMarketplaceScreenState();
}

class _BuyerMarketplaceScreenState extends State<BuyerMarketplaceScreen> {
  final _appState = AppState();
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All Buyers',
    'Verified Only',
    'Nearest (<30km)',
    'Retail Chains',
    'Food Processors',
  ];

  @override
  Widget build(BuildContext context) {
    final buyers = _appState.buyers.where((b) {
      if (_selectedFilter == 'Verified Only' && !b.isVerified) return false;
      if (_selectedFilter == 'Nearest (<30km)' && b.distanceKm > 30) return false;
      if (_selectedFilter == 'Retail Chains' && !b.businessType.contains('Retail')) return false;
      if (_selectedFilter == 'Food Processors' && !b.businessType.contains('Processor')) return false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Marketplace'),
      ),
      body: Column(
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppTheme.paleGreen,
            child: Row(
              children: [
                const Icon(Icons.handshake_outlined,
                    color: AppTheme.primaryGreen, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verified Direct Buyers & Processors',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                      Text(
                        'Matches for ${_appState.activeProduce.quantityKg.toInt()} kg ${_appState.activeProduce.crop} (${_appState.activeProduce.qualityGrade})',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.darkGreen.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: AppTheme.paleGreen,
                    checkmarkColor: AppTheme.primaryGreen,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppTheme.darkGreen : AppTheme.textDark,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primaryGreen : const Color(0xFFE5E7EB),
                      ),
                    ),
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                  ),
                );
              }).toList(),
            ),
          ),

          // Buyer List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 90, top: 2),
              itemCount: buyers.length,
              itemBuilder: (context, index) {
                final buyer = buyers[index];
                return BuyerCard(
                  buyer: buyer,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BuyerDetailsScreen(buyer: buyer),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const RecommendationScreen()),
              );
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate Smart Split Selling Strategy'),
          ),
        ),
      ),
    );
  }
}
