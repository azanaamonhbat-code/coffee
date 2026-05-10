import 'dart:ui';
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
  static const _pageDark = Color(0xFF12100E);
  static const _panelDark = Color(0xFF1C1814);
  static const _accent = Color(0xFFC67C4E);

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
      backgroundColor: _pageDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Find your coffee",
          style: TextStyle(
            color: _accent,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/coffee21.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.24),
                  const Color(0xFF2C1810).withValues(alpha: 0.62),
                  _pageDark.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, viewport) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: viewport.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Good Morning",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "Grab your first coffee in the morning",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: searchController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            onChanged: (value) =>
                                setState(() => searchText = value),
                            decoration: InputDecoration(
                              hintText: "Search coffee...",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: _panelDark.withValues(alpha: 0.88),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: _accent,
                                size: 20,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final width = constraints.maxWidth;
                              final crossAxisCount = width >= 1100
                                  ? 5
                                  : width >= 820
                                  ? 4
                                  : width >= 560
                                  ? 3
                                  : 2;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filtered.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: 0.78,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
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
        ],
      ),
    );
  }

  Widget category(String name) {
    final isActive = selectedCategory == name;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = name),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _accent : Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.brown,
            fontSize: 13,
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
          color: _panelDark.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: coffeeImage(coffee),
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "$price MNT",
              style: const TextStyle(
                color: _accent,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
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
        height: MediaQuery.of(context).size.height * 0.68,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1814),
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: SizedBox(
                  height: 210,
                  width: double.infinity,
                  child: coffeeImage(coffee),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$type  |  $price MNT",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.brown.shade200,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ingredients,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
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
