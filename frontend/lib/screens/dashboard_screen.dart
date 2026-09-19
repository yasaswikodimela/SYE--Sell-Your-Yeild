import 'package:flutter/material.dart';
import '../models/produce.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/market_price_card.dart';
import '../widgets/order_card.dart';
import '../widgets/recommendation_card.dart';
import 'add_produce_screen.dart';
import 'buyer_dashboard_screen.dart';
import 'farmer_profile_screen.dart';
import 'market_prices_screen.dart';
import 'order_confirmation_screen.dart';
import 'orders_screen.dart';
import 'recommendation_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;
  final _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        // Show loading while farmer data loads after login
        if (_appState.isLoadingProduce) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your farm data...'),
                ],
              ),
            ),
          );
        }

        final profile = _appState.farmerProfile;
        final produce = _appState.activeProduce;
        final rec = _appState.currentRecommendation;
        final recentPrices = _appState.marketPrices.take(3).toList();
        final recentOrders = _appState.orders.take(2).toList();

        Widget currentBody;
        switch (_navIndex) {
          case 0:
            currentBody = _buildHomeTab(
                context, profile, produce, rec, recentPrices, recentOrders);
            break;
          case 1:
            currentBody = _buildHarvestsTab(context);
            break;
          case 2:
            currentBody = const MarketPricesScreen();
            break;
          case 3:
            currentBody = const FarmerProfileScreen();
            break;
          default:
            currentBody = _buildHomeTab(
                context, profile, produce, rec, recentPrices, recentOrders);
        }

        return Scaffold(
          body: currentBody,
          bottomNavigationBar: SYEBottomNavBar(
            currentIndex: _navIndex,
            onTap: (idx) => setState(() => _navIndex = idx),
          ),
        );
      },
    );
  }

  Widget _buildHomeTab(
    BuildContext context,
    dynamic profile,
    Produce produce,
    dynamic rec,
    List recentPrices,
    List recentOrders,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with Greeting & Role Switch
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _navIndex = 3),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.paleGreen,
                          child: const Icon(Icons.person,
                              color: AppTheme.primaryGreen, size: 26),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Namaskaram 🙏',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            profile.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          _appState.isFarmerMode = false;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const BuyerDashboardScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFEFF6FF),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.storefront_outlined,
                            size: 16, color: AppTheme.blueInfo),
                        label: const Text(
                          'Buyer Portal',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.blueInfo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Stats Card (Location & Farm Size)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: AppTheme.primaryGreen, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.village}, ${profile.district}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${profile.landSizeAcres} Acres Farm',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Active Harvest Hero Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: Color(0xFFC8E6C9), width: 1.2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE8F5E9), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.eco_rounded,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Active Ready Harvest',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryGreen,
                                    ),
                                  ),
                                  Text(
                                    '${produce.quantityKg.toInt()} kg ${produce.crop}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppTheme.lightGreen, width: 0.8),
                            ),
                            child: Text(
                              produce.qualityGrade,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Shelf Life: ${produce.shelfLifeDays} days • ${produce.variety}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          Text(
                            '📍 ${produce.location}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RecommendationScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.auto_awesome, size: 18),
                              label: const Text('View Smart Selling Plan'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filledTonal(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddProduceScreen(),
                                ),
                              );
                            },
                            tooltip: 'Add New Harvest',
                            icon: const Icon(Icons.add,
                                color: AppTheme.darkGreen),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recommended Selling Plan Widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Smart Selling Recommendation',
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
                            builder: (_) => const RecommendationScreen()),
                      );
                    },
                    child: const Text('Details →'),
                  ),
                ],
              ),
            ),
            RecommendationCard(
              recommendation: rec,
              onExploreDetails: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const RecommendationScreen()),
                );
              },
              onConfirmOrder: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const OrderConfirmationScreen()),
                );
              },
            ),
            const SizedBox(height: 14),

            // Market Price Intelligence Summary Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Live Mandi Price Intelligence',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _navIndex = 2),
                    child: const Text('View All Mandis →'),
                  ),
                ],
              ),
            ),
            ...recentPrices.map((p) => MarketPriceCard(
                  price: p,
                  onTap: () => setState(() => _navIndex = 2),
                )),
            const SizedBox(height: 14),

            // Active Orders Summary Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Sales & Orders',
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
                            builder: (_) => const OrdersScreen()),
                      );
                    },
                    child: const Text('All Orders →'),
                  ),
                ],
              ),
            ),
            ...recentOrders.map((o) => OrderCard(
                  order: o,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const OrdersScreen()),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHarvestsTab(BuildContext context) {
    final produceList = _appState.produceList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Harvests & Produce'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: AppTheme.primaryGreen),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddProduceScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: produceList.length,
        itemBuilder: (context, index) {
          final prod = produceList[index];
          final isCurrent = prod.id == _appState.activeProduce.id;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isCurrent ? AppTheme.primaryGreen : const Color(0xFFE5E7EB),
                width: isCurrent ? 1.5 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${prod.quantityKg.toInt()} kg ${prod.crop}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? AppTheme.paleGreen
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isCurrent ? 'ACTIVE HARVEST' : 'LOGGED',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? AppTheme.darkGreen
                                : AppTheme.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Variety: ${prod.variety} • ${prod.qualityGrade}',
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📍 ${prod.location} • Shelf Life: ${prod.shelfLifeDays} days',
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _appState.activeProduce = prod;
                            // Re-fetch recommendation from backend for this produce
                            _appState.loadRecommendation();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RecommendationScreen(),
                              ),
                            );
                          },
                          child: const Text('Optimize Selling'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryGreen,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddProduceScreen()),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Produce',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
