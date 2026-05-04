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
    menu = coffees.map((item) => Coffee(
          name: item['name'],
          description: item['type'] ?? '',
          details: '',
          price: item['price'],
          image: item['image'],
        )).toList();

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
      print("Server error: $e");
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
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("☕ Кофе захиалах",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown)),
                      const SizedBox(height: 15),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: "Кофены нэр"),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Хэмжээ"),
                          DropdownButton<String>(
                            value: selectedSize,
                            items: sizes.map((size) => DropdownMenuItem(value: size, child: Text(size))).toList(),
                            onChanged: (value) => setModalState(() => selectedSize = value!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Тоо ширхэг"),
                          Row(
                            children: [
                              IconButton(onPressed: () => qty > 1 ? setModalState(() => qty--) : null, icon: const Icon(Icons.remove_circle)),
                              Text("$qty"),
                              IconButton(onPressed: () => setModalState(() => qty++), icon: const Icon(Icons.add_circle)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, minimumSize: const Size(double.infinity, 50)),
                        onPressed: () {
                          final coffeeOrder = Coffee(
                            name: nameController.text,
                            description: "Захиалга",
                            details: "Хэмжээ: $selectedSize | Тоо: $qty",
                            price: 0,
                            image: "https://images.unsplash.com/photo-1511920170033-f8396924c348",
                          );

                          if (coffee == null) addOrder(coffeeOrder);
                          else editOrder(index!, coffeeOrder);

                          sendToServer(coffeeOrder);
                          Navigator.pop(context);
                        },
                        child: const Text("Захиалга баталгаажуулах"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void openCoffeeDetail(Coffee coffee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'lib/assets/images/${coffee.image}',   // ← lib/ нэмсэн
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 120, color: Colors.brown),
                  ),
                ),
                const SizedBox(height: 15),
                Text(coffee.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(coffee.description ?? ''),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    Navigator.pop(context);
                    openOrderForm(coffee: coffee);
                  },
                  child: const Text("Захиалах"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        title: const Text("☕ Кофе захиалга"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () => openOrderForm(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Align(alignment: Alignment.centerLeft, child: Text("☕ Цэс", style: TextStyle(fontSize: 18))),
          ),

          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final coffee = menu[index];
                return GestureDetector(
                  onTap: () => openCoffeeDetail(coffee),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.asset(
                            'lib/assets/images/${coffee.image}',   // ← lib/ нэмсэн
                            height: 90,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 60, color: Colors.brown),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(coffee.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Text("${coffee.price} ₮"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Align(alignment: Alignment.centerLeft, child: Text("🛒 Захиалга", style: TextStyle(fontSize: 18))),
          ),

          Expanded(
            child: orders.isEmpty
                ? const Center(child: Text("Захиалга алга ☕"))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return ListTile(
                        title: Text(order.name),
                        subtitle: Text(order.details ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => openOrderForm(coffee: order, index: index)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => deleteOrder(index)),
                          ],
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