import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiService {
  // FastAPI backend
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://127.0.0.1:8000';
    }
    return 'http://127.0.0.1:8000';
  }

  static Future<String> testConnection() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    return response.body;
  }

  // -------------------------
  // FARMER LOGIN
  // -------------------------
  static Future<Map<String, dynamic>> farmerLogin(
    String phone,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/farmers/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // -------------------------
  // FARMER REGISTER
  // -------------------------
  static Future<Map<String, dynamic>> farmerRegister(
    Map<String, dynamic> farmerData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/farmers/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(farmerData),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    final dynamic decoded = jsonDecode(response.body);
    if (decoded is List) {
      if (decoded.isEmpty) {
        return <String, dynamic>{};
      }
      final firstRow = decoded.first;
      if (firstRow is Map) {
        return Map<String, dynamic>.from(firstRow);
      }
      throw Exception('Unexpected farmer registration response format');
    }
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
    throw Exception('Unexpected farmer registration response format');
  }

  // -------------------------
  // ADD PRODUCE
  // -------------------------
  static Future<Map<String, dynamic>> addProduce(
    Map<String, dynamic> produceData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produce'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produceData),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // -------------------------
  // GET FARMER PRODUCE
  // -------------------------
  static Future<List<dynamic>> getFarmerProduce(String farmerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/produce/farmer/$farmerId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  static Future<List<dynamic>> getAllProduce() async {
    final response = await http.get(Uri.parse('$baseUrl/produce'));
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  // -------------------------
  // GET RECOMMENDATION
  // -------------------------
  static Future<Map<String, dynamic>> getRecommendation(
    Map<String, dynamic> produceData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recommendation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produceData),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // -------------------------
  // GET BUYER REQUIREMENTS
  // -------------------------
  static Future<List<dynamic>> getBuyerRequirements(String buyerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer-requirements?buyer_id=$buyerId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  // -------------------------
  // GET ALL VERIFIED BUYERS
  // -------------------------
  static Future<List<dynamic>> getBuyers() async {
    final response = await http.get(Uri.parse('$baseUrl/buyers'));
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  // -------------------------
  // CREATE ORDER
  // -------------------------
  static Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // -------------------------
  // GET FARMER ORDERS
  // -------------------------
  static Future<List<dynamic>> getFarmerOrders(String farmerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/farmer/$farmerId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  // -------------------------
  // GET BUYER ORDERS
  // -------------------------
  static Future<List<dynamic>> getBuyerOrders(String buyerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/buyer/$buyerId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  static Future<List<dynamic>> getBuyerMatchingProduce(String buyerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyers/$buyerId/matching-produce'),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  // -------------------------
  // UPDATE ORDER STATUS (BUYER ACTION)
  // -------------------------
  static Future<Map<String, dynamic>> updateOrderStatus(
    String orderId,
    String status,
    String buyerId,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/orders/$orderId/status?buyer_id=$buyerId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (decoded['success'] != true) {
      throw Exception(
        decoded['message']?.toString() ?? 'Unable to update order',
      );
    }
    return decoded;
  }

  // -------------------------
  // BUYER LOGIN
  // -------------------------
  static Future<Map<String, dynamic>> buyerLogin(
    String phone,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyers/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // -------------------------
  // BUYER REGISTER
  // -------------------------
  static Future<Map<String, dynamic>> buyerRegister(
    Map<String, dynamic> buyerData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyers/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(buyerData),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // -------------------------
  // GET MARKET PRICES
  // -------------------------
  static Future<List<dynamic>> getMarketPrices(String crop) async {
    final response = await http.get(Uri.parse('$baseUrl/market-prices/$crop'));
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as List<dynamic>;
  }

  // -------------------------
  // ADD BUYER REQUIREMENT
  // -------------------------
  static Future<Map<String, dynamic>> addBuyerRequirement(
    Map<String, dynamic> requirementData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyers/requirements'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requirementData),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateBuyerRequirement(
    String requirementId,
    Map<String, dynamic> requirementData,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/buyers/requirements/$requirementId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requirementData),
    );
    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
