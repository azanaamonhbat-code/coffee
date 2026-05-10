import 'dart:typed_data';

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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = CoffeeStore.coffees.where((coffee) {
      final matchCategory =
          selectedCategory == "All" || coffee["type"] == selectedCategory;
      final matchSearch = coffee["name"].toString().toLowerCase().contains(
        searchText.toLowerCase(),
      );

      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF12100E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Find your coffee",
          style: TextStyle(
            color: Colors.brown,
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
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
          child: LayoutBuilder(
            builder: (context, viewport) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: viewport.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Good Morning",
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Grab your first coffee in the morning",
                          style: TextStyle(fontSize: 30, color: Colors.grey),
                        ),
                        const SizedBox(height: 22),
                        TextField(
                          controller: searchController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                          onChanged: (value) =>
                              setState(() => searchText = value),
                          decoration: InputDecoration(
                            hintText: "Search coffee...",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 28,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1C1814),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.brown,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 18,
                            ),
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
                              category("Americano"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final crossAxisCount = width >= 1000
                                ? 4
                                : width >= 700
                                ? 3
                                : 2;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filtered.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: 0.72,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                  ),
                              itemBuilder: (context, index) {
                                return coffeeCard(filtered[index]);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget category(String name) {
    final isActive = selectedCategory == name;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = name),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: isActive ? Colors.brown : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.brown,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget coffeeCard(Map<String, dynamic> coffee) {
    final name = coffee["name"]?.toString() ?? "";
    final price = coffee["price"] ?? 0;

    return GestureDetector(
      onTap: () => showCoffeeDetail(coffee),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1814),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: coffeeImage(coffee),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "$price MNT",
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget coffeeImage(Map<String, dynamic> coffee) {
    final bytes = coffee["imageBytes"] as Uint8List?;
    if (bytes != null) {
      return Image.memory(bytes, width: double.infinity, fit: BoxFit.cover);
    }

    final image = coffee["image"]?.toString() ?? "";
    return Image.asset(
      imagePath(image),
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.coffee, color: Colors.white, size: 70),
    );
  }

  String imagePath(String image) {
    if (image.startsWith("lib/assets/images/")) return image;
    if (image.startsWith("assets/images/")) return "lib/$image";
    return "lib/assets/images/$image";
  }

  void showCoffeeDetail(Map<String, dynamic> coffee) {
    final name = coffee["name"]?.toString() ?? "";
    final type = coffee["type"]?.toString() ?? "";
    final price = coffee["price"] ?? 0;
    final ingredients = coffee["ingredients"]?.toString() ?? "No ingredients";
    final description = coffee["description"]?.toString() ?? "No description";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.78,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1814),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: SizedBox(
                  height: 290,
                  width: double.infinity,
                  child: coffeeImage(coffee),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$type  |  $price MNT",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.brown.shade200,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ingredients,
                      style: const TextStyle(
                        fontSize: 28,
                        height: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 28,
                        height: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
