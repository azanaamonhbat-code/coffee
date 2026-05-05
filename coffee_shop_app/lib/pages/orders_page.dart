import 'package:flutter/material.dart';
import 'package:coffee_shop_app/models/coffee.dart';
import '../services/api_service.dart';

List<Coffee> orders = [];

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<String> sizes = ["Жижиг", "Дунд", "Том"];

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

  late List<Coffee> menu;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  void _loadMenu() {
    menu = coffees
        .map((item) => Coffee(
              name: item['name'],
              description: item['type'] ?? '',
              details: '',
              price: item['price'],
              image: item['image'],
            ))
        .toList();

    orders = List.from(menu); 
  }

  void addOrder(Coffee coffee) {
    setState(() {
      orders.add(coffee);
    });
  }

  void editOrder(int index, Coffee coffee) {
    setState(() {
      orders[index] = coffee;
    });
  }

  void deleteOrder(int index) {
    setState(() {
      orders.removeAt(index);
    });
  }

  void sendToServer(Coffee coffee) async {
    try {
      await ApiService.sendOrder({
        "name": coffee.name,
        "details": coffee.details,
        "price": coffee.price,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Сервертэй холбогдоход алдаа гарлаа: $e")),
      );
    }
  }

  void openOrderForm({Coffee? coffee, int? index}) {
    final nameController = TextEditingController(text: coffee?.name ?? "");
    int qty = 1;
    String selectedSize = "Дунд";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1C1814),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "☕ Захиалга үүсгэх",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Кофены нэр",
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.brown),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("Хэмжээ", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const Spacer(),
                      DropdownButton<String>(
                        value: selectedSize,
                        dropdownColor: const Color(0xFF2A241E),
                        style: const TextStyle(color: Colors.white),
                        items: sizes.map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            )).toList(),
                        onChanged: (value) => setModalState(() => selectedSize = value!),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text("Тоо ширхэг", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => qty > 1 ? setModalState(() => qty--) : null,
                            icon: const Icon(Icons.remove_circle, color: Colors.brown),
                          ),
                          Text("$qty", style: const TextStyle(fontSize: 20, color: Colors.white)),
                          IconButton(
                            onPressed: () => setModalState(() => qty++),
                            icon: const Icon(Icons.add_circle, color: Colors.brown),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 8,
                    ),
                    onPressed: () {
                      final coffeeOrder = Coffee(
                        name: nameController.text.isEmpty ? "Custom Coffee" : nameController.text,
                        description: "Захиалга",
                        details: "Хэмжээ: $selectedSize | Тоо: $qty",
                        price: 0,
                        image: "https://images.unsplash.com/photo-1511920170033-f8396924c348",
                      );

                      if (coffee == null) {
                        addOrder(coffeeOrder);
                      } else {
                        editOrder(index!, coffeeOrder);
                      }

                      sendToServer(coffeeOrder);
                      Navigator.pop(context);
                    },
                    child: const Text("Захиалга баталгаажуулах", style: TextStyle(fontSize: 17)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void openCoffeeDetail(Coffee coffee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1814),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: Image.asset(
                  'lib/assets/images/${coffee.image}',
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 280,
                    color: Colors.brown.shade800,
                    child: const Icon(Icons.coffee, size: 100, color: Colors.white54),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coffee.name,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      coffee.description,
                      style: TextStyle(fontSize: 18, color: Colors.brown.shade200), // ← const устгасан
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 58),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        openOrderForm(coffee: coffee);
                      },
                      child: const Text("Захиалах", style: TextStyle(fontSize: 18)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12100E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1814),
        elevation: 0,
        title: const Text("☕ Кофе Захиалга", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown.shade700,
        elevation: 12,
        child: const Icon(Icons.add, size: 28),
        onPressed: () => openOrderForm(),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("☕ Цэс", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),

          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final coffee = menu[index];
                return GestureDetector(
                  onTap: () => openCoffeeDetail(coffee),
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1814),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: Image.asset(
                            'lib/assets/images/${coffee.image}',
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 60, color: Colors.brown),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          coffee.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                        ),
                        Text("${coffee.price} ₮", style: TextStyle(color: Colors.brown.shade200)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(color: Colors.grey, height: 1),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("🛒 Миний захиалга", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),

          Expanded(
            child: orders.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.coffee_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("Захиалга хараахан алга", style: TextStyle(color: Colors.grey, fontSize: 18)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1814),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(order.name, style: const TextStyle(fontSize: 17, color: Colors.white)),
                          subtitle: Text(order.details ?? '', style: TextStyle(color: Colors.grey.shade400)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.brown),
                                onPressed: () => openOrderForm(coffee: order, index: index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => deleteOrder(index),
                              ),
                            ],
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
}