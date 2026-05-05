import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ Emulator → 10.0.2.2
  // ⚠️ Real phone → PC IP (жишээ: 192.168.1.10)
  static const String baseUrl = "http://10.0.2.2:3000";

  // =========================
  // 🔧 INTERNAL HELPER
  // =========================
  static Uri _uri(String path) {
    return Uri.parse("$baseUrl$path");
  }

  static dynamic _handleResponse(http.Response response) {
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.statusCode}");
    }
  }

  // =========================
  // ☕ ALL COFFEES
  // =========================
  static Future<List<dynamic>> getCoffees() async {
    try {
      print("GET: /api/coffees");
      final response = await http.get(_uri("/api/coffees"));
      return _handleResponse(response);
    } catch (e) {
      print("ERROR getCoffees: $e");
      throw Exception(e);
    }
  }

  // =========================
  // 📂 CATEGORY FILTER
  // =========================
  static Future<List<dynamic>> getByCategory(String category) async {
    try {
      print("GET: /api/coffees/category/$category");
      final response =
          await http.get(_uri("/api/coffees/category/$category"));
      return _handleResponse(response);
    } catch (e) {
      print("ERROR getByCategory: $e");
      throw Exception(e);
    }
  }

  // =========================
  // 🔍 SEARCH
  // =========================
  static Future<List<dynamic>> searchCoffee(String text) async {
    try {
      print("GET: /api/coffees/search/$text");
      final response =
          await http.get(_uri("/api/coffees/search/$text"));
      return _handleResponse(response);
    } catch (e) {
      print("ERROR searchCoffee: $e");
      throw Exception(e);
    }
  }

  // =========================
  // 🛒 CREATE ORDER
  // =========================
  static Future<Map<String, dynamic>> sendOrder(
      Map<String, dynamic> data) async {
    try {
      print("POST: /api/order");
      print("DATA: $data");

      final response = await http.post(
        _uri("/api/order"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      print("ERROR sendOrder: $e");
      throw Exception(e);
    }
  }

  // =========================
  // 📦 GET ORDERS
  // =========================
  static Future<List<dynamic>> getOrders() async {
    try {
      print("GET: /api/orders");
      final response = await http.get(_uri("/api/orders"));
      return _handleResponse(response);
    } catch (e) {
      print("ERROR getOrders: $e");
      throw Exception(e);
    }
  }

  // =========================
  // 🗑 DELETE ORDER
  // =========================
  static Future<void> deleteOrder(int id) async {
    try {
      print("DELETE: /api/orders/$id");
      final response = await http.delete(_uri("/api/orders/$id"));
      _handleResponse(response);
    } catch (e) {
      print("ERROR deleteOrder: $e");
      throw Exception(e);
    }
  }
}