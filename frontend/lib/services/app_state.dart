import 'package:flutter/foundation.dart';
import '../models/buyer.dart';
import '../models/farmer_profile.dart';
import '../models/market_price.dart';
import '../models/order.dart';
import '../models/produce.dart';
import '../models/recommendation.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    _initializeData();
  }

  // Active user role (Farmer vs Buyer)
  bool isFarmerMode = true;

  // Farmer Profile
  FarmerProfile farmerProfile = const FarmerProfile(
    name: 'Ramesh Naidu',
    phone: '+91 94401 23456',
    village: 'Gannavaram',
    district: 'Krishna',
    state: 'Andhra Pradesh',
    landSizeAcres: 6.5,
    primaryCrops: ['Tomato', 'Chilli', 'Paddy', 'Cotton'],
    memberSince: 'January 2024',
    kisanId: 'AP-KRA-2024-8921',
  );

  // Active Harvest / Produce
  Produce activeProduce = Produce(
    id: 'prod_001',
    crop: 'Tomato',
    variety: 'Hybrid Vaishnavi',
    quantityKg: 1000.0,
    qualityGrade: 'Grade A',
    harvestDate: DateTime.now(),
    shelfLifeDays: 4,
    location: 'Vijayawada, AP',
    notes: 'Freshly harvested, firm skin, suitable for retail and wholesale.',
  );

  // Harvest history
  List<Produce> produceList = [];

  // Market Prices (Agmarknet / Mandi Style)
  List<MarketPrice> marketPrices = [];

  // Buyer Marketplace
  List<Buyer> buyers = [];

  // Active Orders
  List<Order> orders = [];

  // Active Recommendation
  late Recommendation currentRecommendation;

  // What-If Simulation Parameters
  double simTransportMultiplier = 1.0;
  int simFreshMartCapacity = 600;
  int simTirupatiCapacity = 500;
  int simShelfLifeDays = 4;

  void _initializeData() {
    produceList = [
      activeProduce,
      Produce(
        id: 'prod_002',
        crop: 'Green Chilli',
        variety: 'Guntur Sannam',
        quantityKg: 650.0,
        qualityGrade: 'Grade A',
        harvestDate: DateTime.now().subtract(const Duration(days: 2)),
        shelfLifeDays: 8,
        location: 'Guntur, AP',
        notes: 'Export quality pungent chillies.',
      ),
      Produce(
        id: 'prod_003',
        crop: 'Onion',
        variety: 'Nasik Red',
        quantityKg: 2000.0,
        qualityGrade: 'Grade B',
        harvestDate: DateTime.now().subtract(const Duration(days: 5)),
        shelfLifeDays: 14,
        location: 'Kurnool, AP',
        notes: 'Dry, medium size onions.',
      ),
    ];

    marketPrices = [
      const MarketPrice(
        id: 'mp_01',
        commodity: 'Tomato',
        variety: 'Hybrid Vaishnavi',
        grade: 'Grade A',
        market: 'Vijayawada Mandi',
        district: 'Krishna',
        state: 'Andhra Pradesh',
        date: '18 Sep 2026',
        minPrice: 25.0,
        maxPrice: 34.0,
        modalPrice: 30.0,
        priceChangePercent: 4.2,
        arrivalsTons: 68,
      ),
      const MarketPrice(
        id: 'mp_02',
        commodity: 'Tomato',
        variety: 'Local Desi',
        grade: 'Grade B',
        market: 'Guntur Market Yard',
        district: 'Guntur',
        state: 'Andhra Pradesh',
        date: '18 Sep 2026',
        minPrice: 22.0,
        maxPrice: 29.0,
        modalPrice: 26.5,
        priceChangePercent: -1.5,
        arrivalsTons: 110,
      ),
      const MarketPrice(
        id: 'mp_03',
        commodity: 'Tomato',
        variety: 'Hybrid / Round',
        grade: 'Grade A',
        market: 'Bowenpally Mandi',
        district: 'Hyderabad',
        state: 'Telangana',
        date: '18 Sep 2026',
        minPrice: 28.0,
        maxPrice: 38.0,
        modalPrice: 33.0,
        priceChangePercent: 6.8,
        arrivalsTons: 140,
      ),
      const MarketPrice(
        id: 'mp_04',
        commodity: 'Tomato',
        variety: 'Special Table',
        grade: 'Grade A',
        market: 'Tenali AMC',
        district: 'Guntur',
        state: 'Andhra Pradesh',
        date: '18 Sep 2026',
        minPrice: 24.0,
        maxPrice: 31.0,
        modalPrice: 28.0,
        priceChangePercent: 1.1,
        arrivalsTons: 42,
      ),
      const MarketPrice(
        id: 'mp_05',
        commodity: 'Tomato',
        variety: 'Commercial Red',
        grade: 'Grade B',
        market: 'Warangal Agricultural Market',
        district: 'Warangal',
        state: 'Telangana',
        date: '18 Sep 2026',
        minPrice: 21.0,
        maxPrice: 28.0,
        modalPrice: 25.0,
        priceChangePercent: -2.0,
        arrivalsTons: 85,
      ),
      const MarketPrice(
        id: 'mp_06',
        commodity: 'Green Chilli',
        variety: 'Teja Pungent',
        grade: 'Grade A',
        market: 'Guntur Chilli Yard',
        district: 'Guntur',
        state: 'Andhra Pradesh',
        date: '18 Sep 2026',
        minPrice: 160.0,
        maxPrice: 210.0,
        modalPrice: 185.0,
        priceChangePercent: 3.5,
        arrivalsTons: 320,
      ),
    ];

    buyers = [
      const Buyer(
        id: 'b_01',
        buyerName: 'FreshMart Superstores',
        businessType: 'Modern Retail Chain',
        crop: 'Tomato',
        pricePerKg: 30.0,
        capacityKg: 600,
        location: 'Vijayawada Hub (Auto Nagar)',
        distanceKm: 18.0,
        requiredQuality: 'Grade A',
        transportCostPerKg: 1.5,
        rating: 4.8,
        paymentTerms: 'Instant UPI on Delivery',
        isVerified: true,
        contactPhone: '+91 86624 55100',
      ),
      const Buyer(
        id: 'b_02',
        buyerName: 'Tirupati Agro Foods',
        businessType: 'Food Processor & Ketchup Unit',
        crop: 'Tomato',
        pricePerKg: 28.5,
        capacityKg: 800,
        location: 'Mangalagiri Industrial Park',
        distanceKm: 24.0,
        requiredQuality: 'Grade A / B',
        transportCostPerKg: 1.8,
        rating: 4.6,
        paymentTerms: 'Same-day Bank NEFT',
        isVerified: true,
        contactPhone: '+91 86452 77890',
      ),
      const Buyer(
        id: 'b_03',
        buyerName: 'Hyderabad Mega Mandi Exporters',
        businessType: 'Interstate Wholesaler',
        crop: 'Tomato',
        pricePerKg: 33.5, // Advertises highest price! But distance is 280km!
        capacityKg: 2500,
        location: 'Bowenpally, Hyderabad',
        distanceKm: 280.0,
        requiredQuality: 'Grade A',
        transportCostPerKg: 5.5, // High transport!
        rating: 4.2,
        paymentTerms: '48-hour RTGS Settlement',
        isVerified: true,
        contactPhone: '+91 40277 88990',
      ),
      const Buyer(
        id: 'b_04',
        buyerName: 'Krishna Valley Organic & Fresh',
        businessType: 'Direct-to-Consumer Distributor',
        crop: 'Tomato',
        pricePerKg: 31.0,
        capacityKg: 300,
        location: 'Benz Circle, Vijayawada',
        distanceKm: 14.0,
        requiredQuality: 'Grade A',
        transportCostPerKg: 1.2,
        rating: 4.7,
        paymentTerms: 'Instant Cash/UPI',
        isVerified: true,
        contactPhone: '+91 86629 11223',
      ),
      const Buyer(
        id: 'b_05',
        buyerName: 'Guntur Regional Mandi Commission',
        businessType: 'APMC Licensed Trader',
        crop: 'Tomato',
        pricePerKg: 27.0,
        capacityKg: 1500,
        location: 'Guntur AMC',
        distanceKm: 38.0,
        requiredQuality: 'Grade A / B / C',
        transportCostPerKg: 2.2,
        rating: 4.4,
        paymentTerms: 'Next Morning Transfer',
        isVerified: true,
        contactPhone: '+91 86322 34455',
      ),
    ];

    orders = [
      Order(
        orderId: 'ORD-8921-01',
        buyerName: 'FreshMart Superstores',
        crop: 'Tomato',
        quantityKg: 600.0,
        pricePerKg: 30.0,
        totalAmount: 18000.0,
        transportCost: 900.0,
        netAmount: 17100.0,
        status: 'Confirmed',
        orderDate: DateTime.now().subtract(const Duration(hours: 3)),
        deliveryLocation: 'Vijayawada Auto Nagar Hub',
        pickupLocation: 'Gannavaram Farm Gate',
      ),
      Order(
        orderId: 'ORD-8921-02',
        buyerName: 'Tirupati Agro Foods',
        crop: 'Tomato',
        quantityKg: 400.0,
        pricePerKg: 28.5,
        totalAmount: 11400.0,
        transportCost: 720.0,
        netAmount: 10680.0,
        status: 'Pending',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        deliveryLocation: 'Mangalagiri Industrial Park',
        pickupLocation: 'Gannavaram Farm Gate',
      ),
      Order(
        orderId: 'ORD-8710-09',
        buyerName: 'Guntur Chilli Yard Exporters',
        crop: 'Green Chilli',
        quantityKg: 500.0,
        pricePerKg: 185.0,
        totalAmount: 92500.0,
        transportCost: 3200.0,
        netAmount: 89300.0,
        status: 'Completed',
        orderDate: DateTime.now().subtract(const Duration(days: 6)),
        deliveryLocation: 'Guntur Yard',
        pickupLocation: 'Gannavaram Farm Gate',
      ),
    ];

    recalculateRecommendation();
  }

  void recalculateRecommendation({
    double? transportFactor,
    int? freshMartCap,
    int? tirupatiCap,
    int? shelfDays,
  }) {
    if (transportFactor != null) simTransportMultiplier = transportFactor;
    if (freshMartCap != null) simFreshMartCapacity = freshMartCap;
    if (tirupatiCap != null) simTirupatiCapacity = tirupatiCap;
    if (shelfDays != null) simShelfLifeDays = shelfDays;

    final totalHarvest = activeProduce.quantityKg; // 1000 kg

    // Buyer 1: FreshMart
    final double b1Alloc = simFreshMartCapacity >= totalHarvest
        ? totalHarvest
        : simFreshMartCapacity.toDouble();
    final double b1Price = 30.0;
    final double b1Transport = (1.5 * simTransportMultiplier) * b1Alloc;
    // Spoilage risk is low (2%) because short distance (18km) and 4 days shelf life
    final double b1SpoilagePct = simShelfLifeDays < 3 ? 5.0 : 2.0;
    final double b1Gross = b1Alloc * b1Price;
    final double b1SpoilageLoss = (b1Gross * (b1SpoilagePct / 100));
    final double b1Net = b1Gross - b1Transport - b1SpoilageLoss;

    final buyer1 = buyers.firstWhere(
      (b) => b.id == 'b_01',
      orElse: () => buyers[0],
    ).copyWith(capacityKg: simFreshMartCapacity);

    final alloc1 = SplitAllocation(
      buyer: buyer1,
      allocatedQtyKg: b1Alloc,
      pricePerKg: b1Price,
      transportCost: b1Transport,
      spoilageRiskPercentage: b1SpoilagePct,
      spoilageLossAmount: b1SpoilageLoss,
      grossRevenue: b1Gross,
      netValue: b1Net,
      allocationReason:
          'Highest net yield per kg (₹${(b1Net / b1Alloc).toStringAsFixed(1)}/kg). Absorbs full buyer capacity of ${simFreshMartCapacity}kg near Vijayawada.',
    );

    // Remaining produce to Buyer 2: Tirupati Agro
    final double remainingQty = totalHarvest - b1Alloc;
    final List<SplitAllocation> allocations = [alloc1];

    if (remainingQty > 0) {
      final double b2Alloc = remainingQty;
      final double b2Price = 28.5;
      final double b2Transport = (1.8 * simTransportMultiplier) * b2Alloc;
      final double b2SpoilagePct = simShelfLifeDays < 3 ? 6.5 : 3.0;
      final double b2Gross = b2Alloc * b2Price;
      final double b2SpoilageLoss = (b2Gross * (b2SpoilagePct / 100));
      final double b2Net = b2Gross - b2Transport - b2SpoilageLoss;

      final buyer2 = buyers.firstWhere(
        (b) => b.id == 'b_02',
        orElse: () => buyers[1],
      ).copyWith(capacityKg: simTirupatiCapacity);

      final alloc2 = SplitAllocation(
        buyer: buyer2,
        allocatedQtyKg: b2Alloc,
        pricePerKg: b2Price,
        transportCost: b2Transport,
        spoilageRiskPercentage: b2SpoilagePct,
        spoilageLossAmount: b2SpoilageLoss,
        grossRevenue: b2Gross,
        netValue: b2Net,
        allocationReason:
            'Reliable processor capacity absorbs remaining ${remainingQty.toInt()}kg at 24km distance with same-day payment.',
      );
      allocations.add(alloc2);
    }

    final double totalRevenue = allocations.fold(0.0, (s, a) => s + a.grossRevenue);
    final double totalTransport = allocations.fold(0.0, (s, a) => s + a.transportCost);
    final double totalSpoilage = allocations.fold(0.0, (s, a) => s + a.spoilageLossAmount);
    final double totalNet = totalRevenue - totalTransport - totalSpoilage;

    // Naive highest advertised price comparison: Hyderabad buyer @ ₹33.5/kg but 280km transport + 15% transit spoilage
    final double naiveRevenue = totalHarvest * 33.5;
    final double naiveTransport = (5.5 * simTransportMultiplier) * totalHarvest;
    final double naiveSpoilagePct = simShelfLifeDays < 3 ? 24.0 : 14.0;
    final double naiveSpoilage = naiveRevenue * (naiveSpoilagePct / 100);
    final double naiveNet = naiveRevenue - naiveTransport - naiveSpoilage;
    final double netGain = totalNet - naiveNet;

    currentRecommendation = Recommendation(
      id: 'REC-${DateTime.now().millisecondsSinceEpoch}',
      crop: activeProduce.crop,
      totalQuantityKg: totalHarvest,
      allocations: allocations,
      expectedRevenue: totalRevenue,
      totalTransportCost: totalTransport,
      expectedSpoilageLoss: totalSpoilage,
      expectedNetValue: totalNet,
      strategySummary: allocations.length > 1
          ? 'Split Sale: ${alloc1.allocatedQtyKg.toInt()} kg → ${alloc1.buyer.buyerName} + ${allocations[1].allocatedQtyKg.toInt()} kg → ${allocations[1].buyer.buyerName}'
          : 'Single Buyer Sale: ${alloc1.allocatedQtyKg.toInt()} kg → ${alloc1.buyer.buyerName}',
      whyThisStrategy:
          'While Hyderabad Mandi advertises a headline price of ₹33.50/kg, long haul transit (280 km) incurs ₹${naiveTransport.toInt()} transport and ~${naiveSpoilagePct.toInt()}% spoilage risk (₹${naiveSpoilage.toInt()} loss), leaving only ₹${naiveNet.toInt()} net profit.\n\n'
          'SYE Smart Split Strategy pairs nearby retail demand (${buyer1.buyerName} @ ₹30.00/kg) up to capacity (${simFreshMartCapacity}kg), and diverts the balance to nearby ${buyers[1].buyerName} (24km). This saves transport, slashes transit spoilage, and earns you an extra ₹${netGain.abs().toInt()} in real cash in hand.',
      naiveSingleBuyerNetValue: naiveNet,
      netGainOverNaive: netGain,
      decisionFactors: [
        DecisionFactor(
          title: 'Buyer Capacity Matching',
          impact: 'Optimal',
          description:
              'FreshMart has a hard limit of ${simFreshMartCapacity}kg. Splitting prevents having 400kg unsold or distress-sold.',
        ),
        DecisionFactor(
          title: 'Perishable Shelf Life (4 Days)',
          impact: 'Optimal',
          description:
              'Nearby delivery (<25km) ensures delivery within 2 hours with under 3% transit spoilage.',
        ),
        DecisionFactor(
          title: 'Transport Cost Advantage',
          impact: 'Optimal',
          description:
              'Local freight costs ₹${totalTransport.toInt()} total vs ₹${naiveTransport.toInt()} for distant high-bid buyers.',
        ),
        DecisionFactor(
          title: 'Quality Grade A Match',
          impact: 'Optimal',
          description:
              'Both selected buyers accept your Grade A harvest with zero deduction penalties.',
        ),
      ],
    );

    notifyListeners();
  }

  void addProduce(Produce produce) {
    produceList.insert(0, produce);
    activeProduce = produce;
    recalculateRecommendation();
    notifyListeners();
  }

  void updateFarmerProfile(FarmerProfile updated) {
    farmerProfile = updated;
    notifyListeners();
  }

  void createOrdersFromRecommendation() {
    final now = DateTime.now();
    for (int i = 0; i < currentRecommendation.allocations.length; i++) {
      final alloc = currentRecommendation.allocations[i];
      final newOrder = Order(
        orderId: 'ORD-${now.millisecondsSinceEpoch.toString().substring(7)}-0${i + 1}',
        buyerName: alloc.buyer.buyerName,
        crop: currentRecommendation.crop,
        quantityKg: alloc.allocatedQtyKg,
        pricePerKg: alloc.pricePerKg,
        totalAmount: alloc.grossRevenue,
        transportCost: alloc.transportCost,
        netAmount: alloc.netValue,
        status: 'Confirmed',
        orderDate: now,
        deliveryLocation: alloc.buyer.location,
        pickupLocation: '${farmerProfile.village}, ${farmerProfile.district}',
        contactPhone: alloc.buyer.contactPhone,
      );
      orders.insert(0, newOrder);
    }
    notifyListeners();
  }

  void toggleUserRole() {
    isFarmerMode = !isFarmerMode;
    notifyListeners();
  }
}
