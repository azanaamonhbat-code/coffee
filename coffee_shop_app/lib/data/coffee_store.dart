class CoffeeStore {
  // ☕ INITIAL DATA (анхнаасаа харагдах кофе)
  static List<Map<String, dynamic>> coffees = [
    {
      "name": "Espresso",
      "price": 15000,
      "type": "Espresso",
      "image": "coffee1.jpg"
    },
    {
      "name": "Americano",
      "price": 12000,
      "type": "Espresso",
      "image": "coffee2.jpg"
    },
    {
      "name": "Latte",
      "price": 18000,
      "type": "Latte",
      "image": "coffee3.jpg"
    },
  ];

  // ➕ COFFEE ADD хийх helper function
  static void addCoffee(Map<String, dynamic> coffee) {
    coffees.add(coffee);
  }

  // 🗑 COFFEE DELETE хийх
  static void deleteCoffee(int index) {
    coffees.removeAt(index);
  }

  // 🔄 бүх coffee авах
  static List<Map<String, dynamic>> getAll() {
    return coffees;
  }

  // 🔍 category filter (хэрэгтэй бол ашиглана)
  static List<Map<String, dynamic>> byCategory(String category) {
    if (category == "All") return coffees;

    return coffees.where((c) => c["type"] == category).toList();
  }

  // 🔎 search function
  static List<Map<String, dynamic>> search(String text) {
    return coffees
        .where((c) =>
            c["name"].toString().toLowerCase().contains(text.toLowerCase()))
        .toList();
  }
}