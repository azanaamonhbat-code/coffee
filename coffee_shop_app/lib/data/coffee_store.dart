import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class CoffeeStore {
  static const _storageKey = 'coffee_store_items';

  static List<Map<String, dynamic>> coffees = [
    {
      "name": "Espresso",
      "price": 15000,
      "type": "Espresso",
      "ingredients": "Coffee",
      "description": "Strong coffee",
      "image": "coffee1.jpg",
    },
    {
      "name": "Americano",
      "price": 12000,
      "type": "Espresso",
      "ingredients": "Coffee + Water",
      "description": "Mild coffee",
      "image": "coffee2.jpg",
    },
    {
      "name": "Latte",
      "price": 18000,
      "type": "Latte",
      "ingredients": "Coffee + Milk",
      "description": "Milk coffee",
      "image": "coffee3.jpg",
    },
  ];

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved == null || saved.isEmpty) return;

    final decoded = jsonDecode(saved) as List<dynamic>;
    coffees = decoded.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      final encodedImage = map.remove("imageBytesBase64") as String?;
      if (encodedImage != null && encodedImage.isNotEmpty) {
        map["imageBytes"] = base64Decode(encodedImage);
      }
      return map;
    }).toList();
  }

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = coffees.map((item) {
      final map = Map<String, dynamic>.from(item);
      final bytes = map.remove("imageBytes");
      if (bytes is Uint8List) {
        map["imageBytesBase64"] = base64Encode(bytes);
      }
      return map;
    }).toList();

    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  static Future<void> addCoffee(Map<String, dynamic> coffee) async {
    coffees.add(coffee);
    await save();
  }

  static Future<void> deleteCoffee(int index) async {
    if (index >= 0 && index < coffees.length) {
      coffees.removeAt(index);
      await save();
    }
  }

  static Future<void> updateCoffee(
    int index,
    Map<String, dynamic> coffee,
  ) async {
    if (index >= 0 && index < coffees.length) {
      coffees[index] = coffee;
      await save();
    }
  }

  static List<Map<String, dynamic>> getAll() {
    return coffees;
  }
}
