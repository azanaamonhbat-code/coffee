import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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
  Uint8List? pickedImageBytes;
  String? pickedImageName;

  String selectedCategory = 'Espresso';
  String filterCategory = 'All';
  String searchQuery = '';
  int? editIndex;

  final List<String> categories = [
    'Espresso',
    'Cappuccino',
    'Latte',
    'Smoothie',
    'Americano',
  ];

  List<Map<String, dynamic>> get filteredCoffees {
    return CoffeeStore.coffees.where((coffee) {
      final matchesCategory =
          filterCategory == 'All' || coffee['type'] == filterCategory;
      final matchesSearch = coffee['name'].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    ingredientsController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> addCoffee() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Нэр болон үнийг оруулна уу!")),
      );
      return;
    }

    await CoffeeStore.addCoffee(formCoffee());
    setState(() {});

    clearFields();
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Кофе нэмэгдлээ")));
  }

  void editCoffee(Map<String, dynamic> item) {
    editIndex = CoffeeStore.coffees.indexOf(item);

    nameController.text = item["name"]?.toString() ?? "";
    priceController.text = item["price"]?.toString() ?? "";
    ingredientsController.text = item["ingredients"]?.toString() ?? "";
    descriptionController.text = item["description"]?.toString() ?? "";
    imageController.text = item["image"]?.toString() ?? "";
    pickedImageBytes = item["imageBytes"] as Uint8List?;
    pickedImageName = item["imageName"]?.toString();
    selectedCategory = categories.contains(item["type"])
        ? item["type"].toString()
        : 'Espresso';

    showCoffeeSheet(isEdit: true);
  }

  Future<void> saveEdit() async {
    if (editIndex == null) return;

    await CoffeeStore.updateCoffee(editIndex!, formCoffee());
    setState(() {});

    clearFields();
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Кофе засагдлаа")));
  }

  Map<String, dynamic> formCoffee() {
    return {
      "name": nameController.text.trim(),
      "price": int.tryParse(priceController.text.trim()) ?? 0,
      "type": selectedCategory,
      "ingredients": ingredientsController.text.trim(),
      "description": descriptionController.text.trim(),
      "image": imageController.text.trim().isEmpty
          ? "coffee1.jpg"
          : imageController.text.trim(),
      "imageBytes": pickedImageBytes,
      "imageName": pickedImageName,
    };
  }

  Future<void> deleteCoffee(Map<String, dynamic> item) async {
    await CoffeeStore.deleteCoffee(CoffeeStore.coffees.indexOf(item));
    setState(() {});
  }

  void clearFields() {
    nameController.clear();
    priceController.clear();
    ingredientsController.clear();
    descriptionController.clear();
    imageController.clear();
    pickedImageBytes = null;
    pickedImageName = null;
    selectedCategory = 'Espresso';
    editIndex = null;
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return;

    setState(() {
      pickedImageBytes = result.files.single.bytes;
      pickedImageName = result.files.single.name;
      imageController.text = pickedImageName ?? '';
    });
  }

  void showCoffeeSheet({bool isEdit = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF31241E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
                  isEdit ? "Кофе засах" : "Шинэ кофе нэмэх",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                _buildInput(nameController, "Нэр", Icons.coffee),
                _buildInput(
                  priceController,
                  "Үнэ",
                  Icons.attach_money,
                  number: true,
                ),
                _buildCategoryDropdown(),
                _buildInput(ingredientsController, "Орц", Icons.list),
                _buildInput(descriptionController, "Тайлбар", Icons.notes),
                _buildImagePicker(),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC67C4E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: isEdit ? saveEdit : addCoffee,
                    child: Text(
                      isEdit ? "Хадгалах" : "Нэмэх",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(clearFields);
  }

  Widget _buildCategoryDropdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          dropdownColor: const Color(0xFF2D2421),
          style: const TextStyle(color: Colors.white),
          items: categories
              .map(
                (category) =>
                    DropdownMenuItem(value: category, child: Text(category)),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => selectedCategory = value);
          },
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.image, color: Color(0xFFC67C4E)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  pickedImageName ?? "Notebook-оос зураг сонгох",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              TextButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.folder_open, size: 18),
                label: const Text("Сонгох"),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFC67C4E),
                ),
              ),
            ],
          ),
          if (pickedImageBytes != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                pickedImageBytes!,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedItems = filteredCoffees;

    return Scaffold(
      backgroundColor: const Color(0xFF31241E),
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: const Color(0xFF31241E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) => setState(() => searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search coffee...",
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFFB67B4C).withOpacity(0.45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
            child: Row(
              children: ['All', ...categories].map((category) {
                final isSelected = filterCategory == category;
                return GestureDetector(
                  onTap: () => setState(() => filterCategory = category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFC67C4E)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white60,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              itemCount: displayedItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (context, index) {
                return _buildCoffeeCard(displayedItems[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC67C4E),
        onPressed: () => showCoffeeSheet(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCoffeeCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C2A21),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: coffeeImage(item),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item['name']?.toString() ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item['type']?.toString() ?? '',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${item['price']} MNT",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () => editCoffee(item),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => deleteCoffee(item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String imagePath(String image) {
    if (image.startsWith("lib/assets/images/")) return image;
    if (image.startsWith("assets/images/")) return "lib/$image";
    return "lib/assets/images/$image";
  }

  Widget coffeeImage(Map<String, dynamic> item) {
    final bytes = item['imageBytes'] as Uint8List?;
    if (bytes != null) {
      return Image.memory(bytes, width: double.infinity, fit: BoxFit.cover);
    }

    return Image.asset(
      imagePath(item['image']?.toString() ?? ''),
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.black26,
        child: const Center(
          child: Icon(Icons.coffee, color: Colors.white54, size: 52),
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: const Color(0xFFC67C4E)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.06),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFC67C4E)),
          ),
        ),
      ),
    );
  }
}
