import 'package:flutter/foundation.dart';
import '../models/buyer.dart';
import '../models/farmer_profile.dart';
import '../models/market_price.dart';
import '../models/order.dart';
import '../models/produce.dart';
import '../models/recommendation.dart';
import 'api_service.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // -----------------------------------------------------------------------
  // User role
  // -----------------------------------------------------------------------
  bool isFarmerMode = true;

  // -----------------------------------------------------------------------
  // Logged-in farmer state
  // -----------------------------------------------------------------------
  String? farmerId;
  String? buyerId;
  String buyerName = '';

  FarmerProfile farmerProfile = const FarmerProfile(
    name: '',
    phone: '',
    village: '',
    district: '',
    state: '',
    landSizeAcres: 0,
    primaryCrops: [],
    memberSince: '',
    kisanId: '',
  );

  // -----------------------------------------------------------------------
  // Produce
  // -----------------------------------------------------------------------
  Produce activeProduce = Produce(
    id: '',
    crop: '',
    variety: '',
    quantityKg: 0,
    qualityGrade: 'A',
    harvestDate: DateTime.now(),
    shelfLifeDays: 0,
    location: '',
  );

  List<Produce> produceList = [];
  List<Produce> buyerMatchingProduce = [];
  List<Map<String, dynamic>> buyerRequirements = [];

  // -----------------------------------------------------------------------
  // Market Prices
  // -----------------------------------------------------------------------
  List<MarketPrice> marketPrices = [];

  // -----------------------------------------------------------------------
  // Buyers
  // -----------------------------------------------------------------------
  List<Buyer> buyers = [];

  // -----------------------------------------------------------------------
  // Orders
  // -----------------------------------------------------------------------
  List<Order> orders = [];

  // -----------------------------------------------------------------------
  // Recommendation  (null until loaded from backend)
  // -----------------------------------------------------------------------
  Recommendation? _currentRecommendation;

  Recommendation get currentRecommendation {
    return _currentRecommendation ?? _emptyRecommendation();
  }

  bool get hasRecommendation => _currentRecommendation != null;

  // -----------------------------------------------------------------------
  // Loading / error flags
  // -----------------------------------------------------------------------
  bool isLoadingRecommendation = false;
  bool isLoadingOrders = false;
  bool isLoadingProduce = false;
  bool isLoadingMarketPrices = false;
  String? recommendationError;

  // -----------------------------------------------------------------------
  // POST-LOGIN: load all farmer data
  // -----------------------------------------------------------------------
  Future<void> loadFarmerData() async {
    if (farmerId == null) return;
    await Future.wait([
      loadFarmerProduce(),
      loadFarmerOrders(),
    ]);
    // Load market prices for the active crop, then recommendation
    if (activeProduce.crop.isNotEmpty) {
      await loadMarketPrices(activeProduce.crop);
      await loadRecommendation();
    }
  }

  // -----------------------------------------------------------------------
  // LOAD PRODUCE
  // -----------------------------------------------------------------------
  Future<void> loadFarmerProduce() async {
    if (farmerId == null) return;
    isLoadingProduce = true;
    notifyListeners();

    try {
      final data = await ApiService.getFarmerProduce(farmerId!);
      if (data.isNotEmpty) {
        produceList = data
            .map((d) => Produce.fromJson(Map<String, dynamic>.from(d as Map)))
            .toList();
        activeProduce = produceList.first;
      }
    } catch (e) {
      debugPrint('loadFarmerProduce error: $e');
    } finally {
      isLoadingProduce = false;
      notifyListeners();
    }
  }

  // -----------------------------------------------------------------------
  // LOAD MARKET PRICES
  // -----------------------------------------------------------------------
  Future<void> loadMarketPrices(String crop) async {
    isLoadingMarketPrices = true;
    notifyListeners();

    try {
      final data = await ApiService.getMarketPrices(crop);
      marketPrices = data
          .map((d) =>
              MarketPrice.fromBackendJson(Map<String, dynamic>.from(d as Map)))
          .toList();
    } catch (e) {
      debugPrint('loadMarketPrices error: $e');
    } finally {
      isLoadingMarketPrices = false;
      notifyListeners();
    }
  }

  // -----------------------------------------------------------------------
  // LOAD RECOMMENDATION  (calls POST /recommendation on backend)
  // -----------------------------------------------------------------------
  Future<void> loadRecommendation() async {
    if (activeProduce.crop.isEmpty) return;

    isLoadingRecommendation = true;
    recommendationError = null;
    notifyListeners();

    try {
      // Build the quality code the backend expects: A / B / C
      final qualityCode = _extractQualityCode(activeProduce.qualityGrade);

      final payload = {
        'farmer_id': farmerId ?? '',
        'crop': activeProduce.crop,
        'quantity_kg': activeProduce.quantityKg,
        'quality': qualityCode,
        'shelf_life_days': activeProduce.shelfLifeDays,
        'location': activeProduce.location,
      };

      final raw = await ApiService.getRecommendation(payload);
      _currentRecommendation = _parseRecommendation(raw);
    } catch (e) {
      recommendationError = e.toString();
      debugPrint('loadRecommendation error: $e');
    } finally {
      isLoadingRecommendation = false;
      notifyListeners();
    }
  }

  // -----------------------------------------------------------------------
  // LOAD ORDERS
  // -----------------------------------------------------------------------
  Future<void> loadFarmerOrders() async {
    if (farmerId == null) return;
    isLoadingOrders = true;
    notifyListeners();

    try {
      final data = await ApiService.getFarmerOrders(farmerId!);
      final buyersData = await ApiService.getBuyers();
      final buyerNames = <String, String>{
        for (final buyer in buyersData)
          buyer['id'].toString(): buyer['business_name']?.toString() ?? '',
      };
      orders = data
          .map((d) {
            final json = Map<String, dynamic>.from(d as Map);
            return Order.fromBackendJson(
              json,
              buyerName: buyerNames[json['buyer_id']?.toString()] ?? '',
            );
          })
          .toList();
    } catch (e) {
      debugPrint('loadFarmerOrders error: $e');
    } finally {
      isLoadingOrders = false;
      notifyListeners();
    }
  }

  // -----------------------------------------------------------------------
  // CREATE ORDERS FROM RECOMMENDATION  (posts to backend)
  // -----------------------------------------------------------------------
  Future<void> createOrdersFromRecommendation() async {
    if (_currentRecommendation == null) return;
    if (farmerId == null) return;

    final rec = _currentRecommendation!;

    for (final alloc in rec.allocations) {
      try {
        final orderPayload = {
          'farmer_id': farmerId!,
          'buyer_id': alloc.buyer.id,
          'requirement_id': alloc.requirementId,
          'crop': rec.crop,
          'quantity_kg': alloc.allocatedQtyKg,
          'price_per_kg': alloc.pricePerKg,
        };

        final result = await ApiService.createOrder(orderPayload);

        if (result['success'] == true && result['order'] != null) {
          final newOrder = Order.fromBackendJson(
            Map<String, dynamic>.from(result['order'] as Map),
            buyerName: alloc.buyer.buyerName,
            deliveryLocation: alloc.buyer.location,
            pickupLocation:
                '${farmerProfile.village}, ${farmerProfile.district}',
            contactPhone: alloc.buyer.contactPhone,
            transportCost: alloc.transportCost,
          );
          orders.insert(0, newOrder);
        }
      } catch (e) {
        debugPrint('createOrder error for ${alloc.buyer.buyerName}: $e');
      }
    }

    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // ADD PRODUCE (local + backend)
  // -----------------------------------------------------------------------
  Future<void> addProduceWithSync(Produce produce) async {
    produceList.insert(0, produce);
    activeProduce = produce;
    notifyListeners();

    if (farmerId != null) {
      try {
        final qualityCode = _extractQualityCode(produce.qualityGrade);
        await ApiService.addProduce({
          'farmer_id': farmerId!,
          'crop': produce.crop,
          'quantity_kg': produce.quantityKg,
          'quality': qualityCode,
          'shelf_life_days': produce.shelfLifeDays,
          'location': produce.location,
        });
      } catch (e) {
        debugPrint('addProduce backend error: $e');
      }
    }

    // Refresh market prices and recommendation for new crop
    await loadMarketPrices(produce.crop);
    await loadRecommendation();
  }

  // Keep the old synchronous addProduce for screens that still call it
  void addProduce(Produce produce) {
    produceList.insert(0, produce);
    activeProduce = produce;
    notifyListeners();
    // Fire-and-forget sync
    addProduceWithSync(produce);
  }

  // -----------------------------------------------------------------------
  // PROFILE UPDATE (local only — no backend profile-update endpoint yet)
  // -----------------------------------------------------------------------
  void updateFarmerProfile(FarmerProfile updated) {
    farmerProfile = updated;
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // ROLE TOGGLE
  // -----------------------------------------------------------------------
  void toggleUserRole() {
    isFarmerMode = !isFarmerMode;
    notifyListeners();
  }

  // -----------------------------------------------------------------------
  // RESET on logout
  // -----------------------------------------------------------------------
  void reset() {
    farmerId = null;
    buyerId = null;
    buyerName = '';
    isFarmerMode = true;
    farmerProfile = const FarmerProfile(
      name: '',
      phone: '',
      village: '',
      district: '',
      state: '',
      landSizeAcres: 0,
      primaryCrops: [],
      memberSince: '',
      kisanId: '',
    );
    activeProduce = Produce(
      id: '',
      crop: '',
      variety: '',
      quantityKg: 0,
      qualityGrade: 'A',
      harvestDate: DateTime.now(),
      shelfLifeDays: 0,
      location: '',
    );
    produceList = [];
    buyerMatchingProduce = [];
    buyerRequirements = [];
    marketPrices = [];
    buyers = [];
    orders = [];
    _currentRecommendation = null;
    notifyListeners();
  }

  Future<void> loadBuyerData() async {
    if (buyerId == null) return;

    try {
      final requirements = await ApiService.getBuyerRequirements();
      buyerRequirements = requirements
          .map((item) => Map<String, dynamic>.from(item as Map))
          .where((item) => item['buyer_id']?.toString() == buyerId)
          .toList();

      final produce = await ApiService.getAllProduce();
      final crops = buyerRequirements
          .map((item) => item['crop']?.toString().toLowerCase())
          .whereType<String>()
          .toSet();
      buyerMatchingProduce = produce
          .map((item) => Map<String, dynamic>.from(item as Map))
          .where((item) => crops.contains(item['crop']?.toString().toLowerCase()))
          .map(Produce.fromJson)
          .toList();
    } catch (e) {
      debugPrint('loadBuyerData error: $e');
    } finally {
      notifyListeners();
    }
  }

  // -----------------------------------------------------------------------
  // HELPERS
  // -----------------------------------------------------------------------

  /// Extract single-letter quality code from various formats:
  /// "A", "Grade A", "Grade A (Premium / Export)" → "A"
  String _extractQualityCode(String raw) {
    final trimmed = raw.trim().toUpperCase();
    if (trimmed.startsWith('GRADE ')) {
      final letter = trimmed.substring(6, 7);
      return letter;
    }
    if (trimmed.length == 1) return trimmed;
    return 'A'; // safe default
  }

  /// Parse the backend /recommendation JSON response into the
  /// existing Recommendation model used by all screens.
  ///
  /// Backend response shape:
  /// ```json
  /// {
  ///   "strategy": "split|single_buyer|no_buyers|no_suitable_buyer",
  ///   "expected_net_value": 28450.0,
  ///   "market_price_per_kg": 30.0,
  ///   "allocations": [
  ///     {
  ///       "buyer": "name",
  ///       "buyer_id": "uuid",
  ///       "requirement_id": "uuid",
  ///       "quantity_kg": 600,
  ///       "price_per_kg": 30.0,
  ///       "revenue": 18000.0,
  ///       "transport_cost": 900.0,
  ///       "spoilage_loss": 360.0,
  ///       "net_value": 16740.0
  ///     }
  ///   ],
  ///   "remaining_quantity_kg": 0,
  ///   "reasons": [...]
  /// }
  /// ```
  Recommendation _parseRecommendation(Map<String, dynamic> raw) {
    final strategy = raw['strategy']?.toString() ?? 'no_buyers';
    final expectedNet = (raw['expected_net_value'] as num?)?.toDouble() ?? 0.0;
    final marketPricePerKg =
        (raw['market_price_per_kg'] as num?)?.toDouble() ?? 0.0;
    final remainingKg =
        (raw['remaining_quantity_kg'] as num?)?.toDouble() ?? 0.0;
    final reasons = (raw['reasons'] as List?)
            ?.map((r) => r.toString())
            .toList() ??
        [];

    final rawAllocations = (raw['allocations'] as List?) ?? [];

    final List<SplitAllocation> allocations = rawAllocations.map((a) {
      final aMap = Map<String, dynamic>.from(a as Map);
      final buyerName = aMap['buyer']?.toString() ?? '';
      final buyerId = aMap['buyer_id']?.toString() ?? '';
      final requirementId = aMap['requirement_id']?.toString() ?? '';
      final qty = (aMap['quantity_kg'] as num?)?.toDouble() ?? 0.0;
      final price = (aMap['price_per_kg'] as num?)?.toDouble() ?? 0.0;
      final revenue = (aMap['revenue'] as num?)?.toDouble() ?? (qty * price);
      final transport = (aMap['transport_cost'] as num?)?.toDouble() ?? 0.0;
      final spoilageLoss = (aMap['spoilage_loss'] as num?)?.toDouble() ?? 0.0;
      final netValue = (aMap['net_value'] as num?)?.toDouble() ?? 0.0;

      // Find matching buyer object from loaded buyers list for rich details.
      // Fall back to a minimal Buyer constructed from the allocation data.
      Buyer buyer = buyers.firstWhere(
        (b) =>
            b.id == buyerId ||
            b.buyerName.toLowerCase() == buyerName.toLowerCase(),
        orElse: () => Buyer(
          id: buyerId,
          buyerName: buyerName,
          businessType: 'Wholesaler',
          crop: activeProduce.crop,
          pricePerKg: price,
          capacityKg: qty.toInt(),
          location: '',
          distanceKm: 0,
          requiredQuality: 'A',
          transportCostPerKg: qty > 0 ? transport / qty : 0,
        ),
      );

      // Spoilage rate back-calculated for display
      final spoilagePct =
          revenue > 0 ? (spoilageLoss / revenue) * 100 : 0.0;

      return SplitAllocation(
        buyer: buyer,
        requirementId: requirementId,
        allocatedQtyKg: qty,
        pricePerKg: price,
        transportCost: transport,
        spoilageRiskPercentage: spoilagePct,
        spoilageLossAmount: spoilageLoss,
        grossRevenue: revenue,
        netValue: netValue,
        allocationReason: reasons.isNotEmpty ? reasons.first : '',
      );
    }).toList();

    // Summary totals
    final totalRevenue =
        allocations.fold(0.0, (s, a) => s + a.grossRevenue);
    final totalTransport =
        allocations.fold(0.0, (s, a) => s + a.transportCost);
    final totalSpoilage =
        allocations.fold(0.0, (s, a) => s + a.spoilageLossAmount);

    // Build strategy summary string
    String strategySummary;
    if (allocations.isEmpty) {
      strategySummary = strategy == 'no_buyers'
          ? 'No buyers available for this crop'
          : 'No suitable buyers match quality requirements';
    } else if (allocations.length == 1) {
      strategySummary =
          'Single Buyer Sale: ${allocations[0].allocatedQtyKg.toInt()} kg → ${allocations[0].buyer.buyerName}';
    } else {
      final parts = allocations
          .map((a) => '${a.allocatedQtyKg.toInt()} kg → ${a.buyer.buyerName}')
          .join(' + ');
      strategySummary = 'Split Sale: $parts';
    }

    // Why-this-strategy: join all reasons
    final whyStrategy = reasons.join('\n• ');

    // Build decision factors from reasons list
    final List<DecisionFactor> decisionFactors = reasons.map((r) {
      return DecisionFactor(
        title: r,
        impact: 'Optimal',
        description: '',
      );
    }).toList();

    // naive comparison: market price vs best buyer price for context
    final bestBuyerPrice = allocations.isNotEmpty
        ? allocations
            .map((a) => a.pricePerKg)
            .reduce((a, b) => a > b ? a : b)
        : 0.0;
    final naiveNet = activeProduce.quantityKg * marketPricePerKg;
    final netGain = expectedNet - naiveNet;

    return Recommendation(
      id: 'REC-${DateTime.now().millisecondsSinceEpoch}',
      crop: activeProduce.crop,
      totalQuantityKg: activeProduce.quantityKg,
      allocations: allocations,
      expectedRevenue: totalRevenue,
      totalTransportCost: totalTransport,
      expectedSpoilageLoss: totalSpoilage,
      expectedNetValue: expectedNet,
      strategySummary: strategySummary,
      whyThisStrategy: whyStrategy.isEmpty
          ? 'Recommendation generated by SYE engine based on buyer capacity, quality requirements, transport cost, spoilage risk, and market prices.'
          : '• $whyStrategy',
      naiveSingleBuyerNetValue: naiveNet,
      netGainOverNaive: netGain,
      decisionFactors: decisionFactors,
      remainingQuantityKg: remainingKg,
      marketPricePerKg: marketPricePerKg,
      bestBuyerPricePerKg: bestBuyerPrice,
    );
  }

  Recommendation _emptyRecommendation() {
    return Recommendation(
      id: '',
      crop: activeProduce.crop.isNotEmpty ? activeProduce.crop : 'N/A',
      totalQuantityKg: activeProduce.quantityKg,
      allocations: const [],
      expectedRevenue: 0,
      totalTransportCost: 0,
      expectedSpoilageLoss: 0,
      expectedNetValue: 0,
      strategySummary: 'Loading recommendation...',
      whyThisStrategy: '',
      naiveSingleBuyerNetValue: 0,
      netGainOverNaive: 0,
      decisionFactors: const [],
      remainingQuantityKg: 0,
      marketPricePerKg: 0,
      bestBuyerPricePerKg: 0,
    );
  }
}
