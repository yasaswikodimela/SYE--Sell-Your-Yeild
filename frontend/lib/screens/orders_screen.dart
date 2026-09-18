import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/order_card.dart';
import 'dashboard_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _appState = AppState();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        final orders = _appState.orders;

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Selling Orders'),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primaryGreen,
              labelColor: AppTheme.darkGreen,
              unselectedLabelColor: AppTheme.textMuted,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(text: 'All (${orders.length})'),
                Tab(
                    text:
                        'Confirmed (${orders.where((o) => o.status == 'Confirmed').length})'),
                Tab(
                    text:
                        'Pending (${orders.where((o) => o.status == 'Pending').length})'),
                Tab(
                    text:
                        'Completed (${orders.where((o) => o.status == 'Completed').length})'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(orders),
              _buildOrderList(
                  orders.where((o) => o.status == 'Confirmed').toList()),
              _buildOrderList(
                  orders.where((o) => o.status == 'Pending').toList()),
              _buildOrderList(
                  orders.where((o) => o.status == 'Completed').toList()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderList(List dynamicOrders) {
    if (dynamicOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined,
                size: 56, color: Color(0xFFD1D5DB)),
            const SizedBox(height: 12),
            const Text(
              'No orders found in this category',
              style: TextStyle(fontSize: 15, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  (route) => false,
                );
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: dynamicOrders.length,
      itemBuilder: (context, index) {
        final order = dynamicOrders[index];
        return OrderCard(
          order: order,
          onTap: () {
            _showOrderDetailModal(order);
          },
        );
      },
    );
  }

  void _showOrderDetailModal(dynamic order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ${order.orderId}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.paleGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 10),
              _modalRow('Buyer / Trader', order.buyerName),
              _modalRow('Produce / Grade', '${order.quantityKg.toInt()} kg ${order.crop}'),
              _modalRow('Agreed Price', '₹${order.pricePerKg}/kg'),
              _modalRow('Gross Amount', '₹${order.totalAmount.toInt()}'),
              _modalRow('Transport Deductions', '-₹${order.transportCost.toInt()}'),
              _modalRow('Net In-Hand Payout', '₹${order.netAmount.toInt()}', isBold: true),
              _modalRow('Delivery Location', order.deliveryLocation),
              _modalRow('Pickup Point', order.pickupLocation),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Close Details'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _modalRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? AppTheme.darkGreen : AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
