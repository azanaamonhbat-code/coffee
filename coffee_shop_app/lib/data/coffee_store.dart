class CoffeeStore {
  // ☕ бүх кофе хадгалах үндсэн list
  static List<Map<String, dynamic>> coffees = [
    {
      "name": "Espresso",
      "price": 15000,
      "type": "Espresso",
      "ingredients": "Coffee",
      "description": "Strong coffee",
      "image": "coffee1.jpg"
    },
    {
      "name": "Americano",
      "price": 12000,
      "type": "Espresso",
      "ingredients": "Coffee + Water",
      "description": "Mild coffee",
      "image": "coffee2.jpg"
    },
    {
      "name": "Latte",
      "price": 18000,
      "type": "Latte",
      "ingredients": "Coffee + Milk",
      "description": "Milk coffee",
      "image": "coffee3.jpg"
    },
  ];

  // ➕ ADD
  static void addCoffee(Map<String, dynamic> coffee) {
    coffees.add(coffee);
  }

  // 🗑 DELETE
  static void deleteCoffee(int index) {
    if (index >= 0 && index < coffees.length) {
      coffees.removeAt(index);
    }
  }

  // ✏️ UPDATE
  static void updateCoffee(int index, Map<String, dynamic> coffee) {
    if (index >= 0 && index < coffees.length) {
      coffees[index] = coffee;
    }
  }

  // 📋 GET ALL
  static List<Map<String, dynamic>> getAll() {
    return coffees;
  }
}