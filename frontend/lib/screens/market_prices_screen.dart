import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/market_price_card.dart';
import 'buyer_marketplace_screen.dart';
import 'recommendation_screen.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final _appState = AppState();
  String _selectedCropFilter = 'All';
  String _searchQuery = '';

  final List<String> _filterChips = [
    'All',
    'Tomato',
    'Green Chilli',
    'Andhra Pradesh',
    'Telangana',
  ];

  @override
  Widget build(BuildContext context) {
    final prices = _appState.marketPrices.where((p) {
      if (_selectedCropFilter == 'Tomato' && p.commodity != 'Tomato') return false;
      if (_selectedCropFilter == 'Green Chilli' && p.commodity != 'Green Chilli') return false;
      if (_selectedCropFilter == 'Andhra Pradesh' && p.state != 'Andhra Pradesh') return false;
      if (_selectedCropFilter == 'Telangana' && p.state != 'Telangana') return false;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return p.market.toLowerCase().contains(query) ||
            p.commodity.toLowerCase().contains(query) ||
            p.district.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Price Intelligence'),
      ),
      body: Column(
        children: [
          // Intelligence Header Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppTheme.paleGreen,
            child: Row(
              children: [
                const Icon(Icons.analytics_outlined, color: AppTheme.primaryGreen, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Agmarknet & APMC Mandi Intelligence',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                      Text(
                        'Live wholesale mandi arrivals & modal prices in AP & TS',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.darkGreen.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.lightGreen),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Color(0xFF10B981), size: 8),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryGreen),
                hintText: 'Search mandi name, district, or crop...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: _filterChips.map((chip) {
                final isSelected = _selectedCropFilter == chip;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(chip),
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
                    onSelected: (selected) {
                      setState(() {
                        _selectedCropFilter = chip;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),

          // Mandi List
          Expanded(
            child: prices.isEmpty
                ? const Center(
                    child: Text(
                      'No mandi records found matching criteria',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 90, top: 4),
                    itemCount: prices.length,
                    itemBuilder: (context, index) {
                      final price = prices[index];
                      return MarketPriceCard(
                        price: price,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Selected ${price.market}: Modal ₹${price.modalPrice}/kg. Comparing buyers...'),
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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const BuyerMarketplaceScreen()),
                  );
                },
                icon: const Icon(Icons.store_mall_directory_outlined, size: 18),
                label: const Text('View Buyers'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const RecommendationScreen()),
                  );
                },
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('Smart Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
