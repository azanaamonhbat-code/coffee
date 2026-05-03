import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";

  final List<Map<String, dynamic>> coffees = [
    {"name": "Espresso", "type": "Espresso", "price": 15000, "image": "coffee2.jpg"},
    {"name": "Americano", "type": "Espresso", "price": 12000, "image": "coffee3.jpg"},
    {"name": "Macchiato", "type": "Espresso", "price": 17000, "image": "coffee10.jpg"},
    {"name": "Ristretto", "type": "Espresso", "price": 14000, "image": "coffee11.jpg"},
    {"name": "Doppio", "type": "Espresso", "price": 16000, "image": "coffee24.jpg"},

    {"name": "Cappuccino", "type": "Cappuccino", "price": 16000, "image": "coffee4.jpg"},
    {"name": "Flat White", "type": "Cappuccino", "price": 17000, "image": "coffee9.jpg"},
    {"name": "Iced Cappuccino", "type": "Cappuccino", "price": 18000, "image": "coffee13.jpg"},
    {"name": "Dry Cappuccino", "type": "Cappuccino", "price": 17500, "image": "coffee14.jpg"},
    {"name": "Double Cappuccino", "type": "Cappuccino", "price": 18500, "image": "coffee15.jpg"},

    {"name": "Latte", "type": "Latte", "price": 18000, "image": "coffee7.jpg"},
    {"name": "Caramel Latte", "type": "Latte", "price": 20000, "image": "coffee6.jpg"},
    {"name": "Vanilla Latte", "type": "Latte", "price": 19500, "image": "coffee16.jpg"},
    {"name": "Hazelnut Latte", "type": "Latte", "price": 20500, "image": "coffee17.jpg"},
    {"name": "Ice Latte", "type": "Latte", "price": 18500, "image": "coffee18.jpg"},

    {"name": "Strawberry Smoothie", "type": "Smoothie", "price": 14000, "image": "coffee19.jpg"},
    {"name": "Mango Smoothie", "type": "Smoothie", "price": 15000, "image": "coffee20.jpg"},
    {"name": "Banana Smoothie", "type": "Smoothie", "price": 13000, "image": "coffee21.jpg"},
    {"name": "Blueberry Smoothie", "type": "Smoothie", "price": 16000, "image": "coffee22.jpg"},
    {"name": "Green Detox Smoothie", "type": "Smoothie", "price": 17000, "image": "coffee23.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategory == "All"
        ? coffees
        : coffees.where((c) => c["type"] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF181818),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Find your coffee"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            // 🔍 SEARCH
            TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                filled: true,
                fillColor: Colors.grey[850],
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ☕ CATEGORY
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  category("All"),
                  category("Espresso"),
                  category("Cappuccino"),
                  category("Latte"),
                  category("Smoothie"),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 🧱 GRID
            Expanded(
              child: GridView.builder(
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.80,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final coffee = filtered[index];
                  return coffeeCard(
                    coffee["name"],
                    coffee["price"],
                    coffee["image"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🟤 CATEGORY
  Widget category(String name) {
    final isActive = selectedCategory == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = name;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  // ☕ CARD (FIXED: no add button + tighter layout)
  Widget coffeeCard(String name, int price, String image) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      padding: const EdgeInsets.all(6),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🖼 IMAGE (closer + clean)
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 1.15,
              child: Image.asset(
                "lib/assets/images/$image",
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 4), // 👈 IMAGE + TEXT ойр

          // ☕ NAME
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 2),

          // 💰 PRICE
          Text(
            "$price ₮",
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}