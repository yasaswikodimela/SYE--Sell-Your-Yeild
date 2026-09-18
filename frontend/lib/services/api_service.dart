import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // FastAPI backend
  static const String baseUrl = 'http://127.0.0.1:8000';
  static Future<String> testConnection() async {
  final response = await http.get(
    Uri.parse('$baseUrl/'),
  );

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
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  // -------------------------
  // FARMER REGISTER
  // -------------------------
  static Future<Map<String, dynamic>> farmerRegister(
    Map<String, dynamic> farmerData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/farmers/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(farmerData),
    );

    return jsonDecode(response.body);
  }

  // -------------------------
  // ADD PRODUCE
  // -------------------------
  static Future<Map<String, dynamic>> addProduce(
    Map<String, dynamic> produceData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produce'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(produceData),
    );

    return jsonDecode(response.body);
  }

  // -------------------------
  // GET FARMER PRODUCE
  // -------------------------
  static Future<List<dynamic>> getFarmerProduce(
    String farmerId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/produce/farmer/$farmerId'),
    );

    return jsonDecode(response.body);
  }

  // -------------------------
  // GET RECOMMENDATION
  // -------------------------
  static Future<Map<String, dynamic>> getRecommendation(
    Map<String, dynamic> produceData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recommendation'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(produceData),
    );

    return jsonDecode(response.body);
  }

  // -------------------------
  // GET BUYER REQUIREMENTS
  // -------------------------
  static Future<List<dynamic>> getBuyerRequirements() async {
    final response = await http.get(
      Uri.parse('$baseUrl/buyer-requirements'),
    );

    return jsonDecode(response.body);
  }

  // -------------------------
  // CREATE ORDER
  // -------------------------
  static Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(orderData),
    );

    return jsonDecode(response.body);
  }

  // -------------------------
  // GET FARMER ORDERS
  // -------------------------
  static Future<List<dynamic>> getFarmerOrders(
    String farmerId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders/farmer/$farmerId'),
    );

    return jsonDecode(response.body);
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
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  // -------------------------
  // BUYER REGISTER
  // -------------------------
  static Future<Map<String, dynamic>> buyerRegister(
    Map<String, dynamic> buyerData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyers/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(buyerData),
    );

    return jsonDecode(response.body);
  }

  // -------------------------
  // GET MARKET PRICES
  // -------------------------
  static Future<List<dynamic>> getMarketPrices(
    String crop,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/market-prices/$crop'),
    );

    return jsonDecode(response.body);
  }
}