import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";
  String searchText = "";

  final TextEditingController searchController = TextEditingController();

  // 🔥 API data
  List<dynamic> apiCoffees = [];
  bool isLoading = true;

  // 🔥 Local data (backup)
  final List<Map<String, dynamic>> coffees = [
    {"name": "Espresso", "type": "Espresso", "price": 15000, "image": "coffee2.jpg"},
    {"name": "Americano", "type": "Espresso", "price": 12000, "image": "coffee3.jpg"},
    {"name": "Macchiato", "type": "Espresso", "price": 17000, "image": "coffee10.jpg"},
    {"name": "Ristretto", "type": "Espresso", "price": 14000, "image": "coffee11.jpg"},
    {"name": "Doppio", "type": "Espresso", "price": 16000, "image": "coffee24.jpg"},

    {"name": "Cappuccino", "type": "Cappuccino", "price": 16000, "image": "coffee4.jpg"},
    {"name": "Flat White", "type": "Cappuccino", "price": 17000, "image": "coffee9.jpg"},
    {"name": "Latte", "type": "Latte", "price": 18000, "image": "coffee7.jpg"},
    {"name": "Smoothie", "type": "Smoothie", "price": 14000, "image": "coffee19.jpg"},
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // 🚀 API ачаалах
  void loadData() async {
    try {
      final data = await ApiService.getCoffees();

      setState(() {
        apiCoffees = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataSource = apiCoffees.isNotEmpty ? apiCoffees : coffees;

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
      backgroundColor: const Color(0xFF181818),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Find your coffee"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [

                  // 🔍 SEARCH
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search coffee...",
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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

  // ☕ CARD
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

          const SizedBox(height: 4),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 2),

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