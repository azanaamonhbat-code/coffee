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

  List<dynamic> apiCoffees = [];
  bool isLoading = true;

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

  void loadData() async {
    try {
      final data = await ApiService.getCoffees();
      setState(() {
        apiCoffees = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void showCoffeeDetail(Map<String, dynamic> coffee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF5F1EC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "lib/assets/images/${coffee['image']}",
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 120, color: Colors.brown),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(coffee['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 8),
              Text("${coffee['price']} ₮", style: const TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold)),
              
              const Divider(height: 30, color: Colors.brown),
              const Text("Тайлбар", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 8),
              Text("${coffee['type']} - Амттай, хүчтэй кофены сонголт.", style: const TextStyle(fontSize: 16, color: Colors.brown)),
              
              const SizedBox(height: 20),
              const Text("Найрлага", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 8),
              Text(
                "• Espresso shot\n• ${coffee['type'] == 'Espresso' ? 'Халуун ус / Сүү' : 'Сүү, эспрессо'}\n• Элсэн чихэр (заавал биш)",
                style: const TextStyle(fontSize: 16, color: Color(0xFF5D4037)),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Захиалга нэмэгдлээ ☕")));
                  },
                  child: const Text("Захиалах", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataSource = apiCoffees.isNotEmpty ? apiCoffees : coffees;

    final filtered = dataSource.where((c) {
      final matchCategory = selectedCategory == "All" || c["type"] == selectedCategory;
      final matchSearch = c["name"].toString().toLowerCase().contains(searchText.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
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
                  const SizedBox(height: 20), // AppBar-тай давхцахгүйн тулд

                  const Text(
                    "Good Morning ☕",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Text(
                    "Grab your first coffee in the morning",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => setState(() => searchText = value),
                    decoration: InputDecoration(
                      hintText: "Search coffee...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1C1814),
                      prefixIcon: const Icon(Icons.search, color: Colors.brown),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF3E2723)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.brown, width: 2),
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final coffee = filtered[index];
                      return GestureDetector(
                        onTap: () => showCoffeeDetail(coffee),
                        child: coffeeCard(coffee["name"], coffee["price"], coffee["image"]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // AppBar-г тунгалаг болгож background-тай нийлүүлэв
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Find your coffee", style: TextStyle(color: Colors.brown)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  // ================== 3D CATEGORY WIDGET ==================
  Widget category(String name) {
    final isActive = selectedCategory == name;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF3E2723), Color(0xFF5D4037)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Colors.white, Color(0xFFF5F1EC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(isActive ? 0.45 : 0.18),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(isActive ? 0.25 : 0.7),
              blurRadius: 8,
              offset: const Offset(-3, -3),
            ),
            if (isActive)
              BoxShadow(
                color: const Color(0xFF3E2723).withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(4, 6),
              ),
          ],
          border: Border.all(
            color: isActive 
                ? const Color(0xFFBCAAA4) 
                : const Color(0xFFBCAAA4).withOpacity(0.7),
            width: isActive ? 2.5 : 1.5,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.brown.shade800,
            fontWeight: FontWeight.w600,
            fontSize: 15.5,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  // ================== 3D COFFEE CARD ==================
  Widget coffeeCard(String name, int price, String image) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1814),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1.05,
              child: Image.asset(
                "lib/assets/images/$image",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.brown.shade700,
                  child: const Icon(Icons.coffee, size: 80, color: Colors.white70),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xFF1C1814)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Best Coffee",
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$price ₮",
                    style: const TextStyle(
                      color: Color(0xFFFFC107),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}