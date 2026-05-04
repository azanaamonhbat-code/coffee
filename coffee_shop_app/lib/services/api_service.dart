import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ Emulator = 10.0.2.2
  // ⚠️ Real phone = PC IP ашиглана
  static const String baseUrl = "http://10.0.2.2:3000";

  // =========================
  // ☕ COFFEE LIST АВАХ
  // =========================
  static Future<List<dynamic>> getCoffees() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/coffees"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Coffee load failed");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // =========================
  // 🛒 ORDER ИЛГЭЭХ
  // =========================
  static Future<Map<String, dynamic>> sendOrder(
      Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/order"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Order failed");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // =========================
  // 📦 ORDER LIST АВАХ
  // =========================
  static Future<List<dynamic>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/orders"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Orders load failed");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}