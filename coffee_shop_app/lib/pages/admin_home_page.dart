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

  String selectedCategory = 'Espresso';

  final List<String> categories = [
    'Espresso',
    'Cappuccino',
    'Latte',
    'Smoothie',
    'Americano'
  ];

  int? editIndex;

  // ================= ADD =================
  void addCoffee() {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Нэр болон үнийг оруулна уу!")),
      );
      return;
    }

    CoffeeStore.coffees.add({
      "name": nameController.text,
      "price": int.tryParse(priceController.text) ?? 0,
      "type": selectedCategory,
      "ingredients": ingredientsController.text,
      "description": descriptionController.text,
      "image": imageController.text.isEmpty
          ? "assets/images/default.png"
          : imageController.text,
    });

    clearFields();
    Navigator.pop(context);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("☕ Кофе нэмэгдлээ")),
    );
  }

  // ================= EDIT OPEN =================
  void editCoffee(int index) {
    final item = CoffeeStore.coffees[index];

    setState(() {
      nameController.text = item["name"] ?? "";
      priceController.text = item["price"].toString();
      ingredientsController.text = item["ingredients"] ?? "";
      descriptionController.text = item["description"] ?? "";
      selectedCategory = item["type"];
      editIndex = index;
    });

    showCoffeeSheet(isEdit: true);
  }

  // ================= SAVE EDIT =================
  void saveEdit() {
    if (editIndex == null) return;

    CoffeeStore.coffees[editIndex!] = {
      "name": nameController.text,
      "price": int.tryParse(priceController.text) ?? 0,
      "type": selectedCategory,
      "ingredients": ingredientsController.text,
      "description": descriptionController.text,
      "image": imageController.text.isEmpty
          ? "assets/images/default.png"
          : imageController.text,
    };

    clearFields();
    Navigator.pop(context);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✏️ Засагдлаа")),
    );
  }

  // ================= DELETE =================
  void deleteCoffee(int index) {
    CoffeeStore.coffees.removeAt(index);
    setState(() {});
  }

  // ================= CLEAR =================
  void clearFields() {
    nameController.clear();
    priceController.clear();
    ingredientsController.clear();
    descriptionController.clear();
    imageController.clear();
    editIndex = null;
  }

  // ================= BOTTOM SHEET =================
  void showCoffeeSheet({bool isEdit = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1c1614),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? "Кофе засах" : "Кофе нэмэх",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 15),

                _buildInput(nameController, "Нэр", Icons.coffee),
                _buildInput(priceController, "Үнэ", Icons.money,
                    number: true),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      dropdownColor: const Color(0xFF2d2421),
                      style: const TextStyle(color: Colors.white),
                      items: categories
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCategory = val!;
                        });
                      },
                    ),
                  ),
                ),

                _buildInput(ingredientsController, "Орц", Icons.list),
                _buildInput(descriptionController, "Тайлбар", Icons.description),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFc67c4e),
                    ),
                    onPressed: isEdit ? saveEdit : addCoffee,
                    child: Text(isEdit ? "Хадгалах" : "Нэмэх"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1c1614),
      appBar: AppBar(
        title: const Text("Admin Panel 👑"),
        backgroundColor: const Color(0xFF1c1614),
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFc67c4e),
        onPressed: () => showCoffeeSheet(isEdit: false),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: CoffeeStore.coffees.length,
        itemBuilder: (context, index) {
          final item = CoffeeStore.coffees[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                item['name'],
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "${item['type']} • ${item['price']}₮",
                style: const TextStyle(color: Colors.white60),
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => editCoffee(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteCoffee(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= INPUT =================
  Widget _buildInput(TextEditingController controller, String label,
      IconData icon,
      {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white60),
          prefixIcon: Icon(icon, color: const Color(0xFFc67c4e)),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}