import 'package:flutter/material.dart';
import '../data/coffee_store.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final ingredientsController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  final searchController = TextEditingController();

  String selectedCategory = 'All';
  String searchQuery = ''; // Хайлтын утга хадгалах
  final List<String> categories = ['All', 'Espresso', 'Cappuccino', 'Latte', 'Americano'];

  // Кофе нэмэх функц
  void addCoffee() {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Нэр болон үнийг заавал оруулна уу!")),
      );
      return;
    }

    setState(() {
      CoffeeStore.coffees.add({
        "name": nameController.text,
        "price": double.tryParse(priceController.text) ?? 0.0,
        "type": selectedCategory == 'All' ? 'Espresso' : selectedCategory,
        "ingredients": ingredientsController.text,
        "description": descriptionController.text,
        "image": imageController.text.isEmpty
            ? "assets/images/espresso.png"
            : imageController.text,
      });
    });

    clearFields();
    Navigator.pop(context);
  }

  void clearFields() {
    nameController.clear();
    priceController.clear();
    ingredientsController.clear();
    descriptionController.clear();
    imageController.clear();
  }

  // Шүүгдсэн жагсаалт авах функц
  List get filteredCoffees {
    return CoffeeStore.coffees.where((coffee) {
      final matchesCategory = selectedCategory == 'All' || coffee['type'] == selectedCategory;
      final matchesSearch = coffee['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void showAddCoffeeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF31241e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Шинэ кофе нэмэх", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildInput(nameController, "Нэр", Icons.coffee),
              _buildInput(priceController, "Үнэ (жишээ: 4.40)", Icons.attach_money, number: true),
              _buildInput(ingredientsController, "Амт / Орц", Icons.bubble_chart),
              _buildInput(imageController, "Зураг (URL/Path)", Icons.image),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFc67c4e),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: addCoffee,
                  child: const Text("Бүртгэх", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedItems = filteredCoffees; // Шүүгдсэн дата

    return Scaffold(
      backgroundColor: const Color(0xFF31241e),
      body: SafeArea(
        child: Column(
          children: [
            // Хайлтын хэсэг
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFFb67b4c).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) => setState(() => searchQuery = value),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Search coffee...",
                          hintStyle: TextStyle(color: Colors.white60),
                          icon: Icon(Icons.search, color: Colors.white60),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 55, width: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFc67c4e),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  )
                ],
              ),
            ),

            // Категори
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Row(
                children: categories.map((cat) {
                  bool isSelected = selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFc67c4e) : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white60,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Жагсаалт
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: displayedItems.length,
                itemBuilder: (context, index) {
                  final item = displayedItems[index];
                  return _buildCoffeeCard(item);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFc67c4e),
        onPressed: showAddCoffeeSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCoffeeCard(Map item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3c2a21),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/images/espresso.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 24),
                    onPressed: () {
                      setState(() {
                        // Үндсэн жагсаалтаас нэрээр нь шүүж устгах
                        CoffeeStore.coffees.removeWhere((element) => element == item);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(item['name'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1),
          Text(item['ingredients'] ?? "Choose Flavor", style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("\$${item['price']}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFc67c4e),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, IconData icon, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: number ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: const Color(0xFFc67c4e)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFc67c4e))),
        ),
      ),
    );
  }
}