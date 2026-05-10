import 'package:flutter/material.dart';
import '../data/coffee_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";
  String searchText = "";

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 🔥 ADMIN-аас нэмсэн бүх кофе эндээс уншина
    final dataSource = CoffeeStore.coffees;

    final filtered = dataSource.where((c) {
      final matchCategory =
          selectedCategory == "All" || c["type"] == selectedCategory;

      final matchSearch = c["name"]
          .toString()
          .toLowerCase()
          .contains(searchText.toLowerCase());

      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Find your coffee",
          style: TextStyle(color: Colors.brown),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=2070",
            ),
            fit: BoxFit.cover,
            opacity: 0.85,
          ),
        ),

        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF2C1810).withOpacity(0.75),
                const Color(0xFF2C1810).withOpacity(0.65),
                const Color(0xFF12100E).withOpacity(0.85),
              ],
            ),
          ),

          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  const Text(
                    "Good Morning ☕",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const Text(
                    "Grab your first coffee in the morning",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  // SEARCH
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) =>
                        setState(() => searchText = value),
                    decoration: InputDecoration(
                      hintText: "Search coffee...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1C1814),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.brown),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

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

                  const SizedBox(height: 25),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= CATEGORY =================
  Widget category(String name) {
    final isActive = selectedCategory == name;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = name),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.brown : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.brown,
          ),
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget coffeeCard(String name, int price, String image) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1814),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              "lib/assets/images/$image",
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.coffee,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
          Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            "$price ₮",
            style: const TextStyle(color: Colors.amber),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}