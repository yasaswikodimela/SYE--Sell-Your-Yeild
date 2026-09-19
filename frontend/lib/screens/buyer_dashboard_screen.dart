import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../models/order.dart';
import 'login_screen.dart';

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
  String? _updatingOrderId;

  @override
  void initState() {
    super.initState();
    _appState.addListener(_refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appState.loadBuyerOrders();
    });
  }

  @override
  void dispose() {
    _appState.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _updateOrderStatus(Order order, String status) async {
    setState(() => _updatingOrderId = order.orderId);
    try {
      final message = await _appState.updateBuyerOrderStatus(
        order.orderId,
        status,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: status == 'accepted'
              ? AppTheme.primaryGreen
              : Colors.red.shade700,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not update order: $e')));
    } finally {
      if (mounted) setState(() => _updatingOrderId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SYE Buyer Procurement Desk'),
        actions: [
          IconButton(
            tooltip: 'Refresh orders',
            onPressed: _appState.isLoadingOrders
                ? null
                : () => _appState.loadBuyerOrders(),
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              _appState.reset();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_rounded),
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
                      Row(
                        children: [
                          Icon(
                            Icons.storefront_rounded,
                            color: Color(0xFF38BDF8),
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            _appState.buyerName,
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
                          horizontal: 8,
                          vertical: 3,
                        ),
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

            if (_appState.buyerOffers.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.paleGreen,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.notifications_active_outlined,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'New Farmer Offers Available\n${_appState.buyerOffers.length} real farmer offer${_appState.buyerOffers.length == 1 ? '' : 's'} match your active requirements.',
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            _buildPendingOrders(),
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
                        const Text(
                          'Min: 200 kg',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const Text(
                          'Max: 2000 kg',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
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
                                horizontal: 10,
                                vertical: 8,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Tomato',
                                child: Text('Tomato'),
                              ),
                              DropdownMenuItem(
                                value: 'Chilli',
                                child: Text('Chilli'),
                              ),
                              DropdownMenuItem(
                                value: 'Onion',
                                child: Text('Onion'),
                              ),
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
                                horizontal: 10,
                                vertical: 8,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Grade A',
                                child: Text('Grade A'),
                              ),
                              DropdownMenuItem(
                                value: 'Grade B',
                                child: Text('Grade B'),
                              ),
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
                            onPressed: () async {
                              try {
                                final message = await _appState
                                    .saveBuyerRequirement(
                                  crop: _selectedCrop,
                                  quantityKg: _myCapacity,
                                  pricePerKg: _offeredRate,
                                  qualityRequired: _selectedGrade
                                      .replaceFirst('Grade ', ''),
                                );
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    backgroundColor: AppTheme.primaryGreen,
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Could not save demand: $e')),
                                );
                              }
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
            ..._appState.buyerOffers.map((offer) {
              final crop = offer['crop']?.toString() ?? '';
              final quantity = (offer['quantity_kg'] as num?)?.toDouble() ?? 0;
              final quality = offer['quality']?.toString() ?? '';
              final location = offer['location']?.toString() ??
                  offer['farmer_location']?.toString() ?? '';
              final farmer = offer['farmer_name']?.toString() ?? 'Farmer';
              final shelfLife = offer['shelf_life_days']?.toString() ?? '';
              final offeredPrice = (offer['offered_price_per_kg'] as num?)
                      ?.toDouble() ??
                  0;
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
                        child: const Icon(
                          Icons.eco_rounded,
                          color: AppTheme.primaryGreen,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${quantity.toInt()} kg $crop (Grade $quality)',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$farmer • 📍 $location • Shelf Life: $shelfLife days\nBuyer rate: ₹${offeredPrice.toStringAsFixed(0)}/kg',
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
                                  'This is a farmer offer for $crop. Review its matching order in Pending Farmer Offers.',
                              ),
                              backgroundColor: AppTheme.primaryGreen,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                        ),
                        child: const Text(
                          'View Offer',
                          style: TextStyle(fontSize: 12),
                        ),
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

  Widget _buildPendingOrders() {
    final pendingOrders = _appState.orders
        .where((order) => order.status.toLowerCase() == 'pending')
        .toList();

    return Card(
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
                  'Pending Farmer Offers',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                if (_appState.isLoadingOrders)
                  const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Text(
                    '${pendingOrders.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (pendingOrders.isEmpty)
              const Text(
                'No pending farmer offers right now.',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              )
            else
              ...pendingOrders.map(_buildPendingOrderRow),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingOrderRow(Order order) {
    final isUpdating = _updatingOrderId == order.orderId;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${order.quantityKg.toInt()} kg ${order.crop}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Farmer offer • ₹${order.pricePerKg.toStringAsFixed(0)}/kg • Total ₹${order.totalAmount.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isUpdating
                      ? null
                      : () => _updateOrderStatus(order, 'rejected'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: isUpdating
                      ? null
                      : () => _updateOrderStatus(order, 'accepted'),
                  child: isUpdating
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
