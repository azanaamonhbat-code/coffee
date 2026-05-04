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

  bool isLoading = false;

  final List<Coffee> menu = [
    Coffee(
      name: "Americano",
      description: "Хүчтэй хар кофе",
      details: "Классик хар кофе",
      price: 15000,
      image: "https://images.unsplash.com/photo-1511920170033-f8396924c348",
    ),
    Coffee(
      name: "Latte",
      description: "Сүүтэй зөөлөн кофе",
      details: "Кремтэй зөөлөн амт",
      price: 18000,
      image: "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
    ),
    Coffee(
      name: "Cappuccino",
      description: "Хөөс ихтэй кофе",
      details: "Тэнцвэртэй амт",
      price: 17000,
      image: "https://images.unsplash.com/photo-1521302080334-4bebac2763a6",
    ),
  ];

  // 🚀 LOCAL ADD
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

  // 🚀 SEND TO NODE.JS
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
    final nameController =
        TextEditingController(text: coffee?.name ?? "");

    int qty = 1;
    String selectedSize = "Дунд";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                      const Text(
                        "☕ Кофе захиалах",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Кофены нэр",
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Хэмжээ"),
                          DropdownButton<String>(
                            value: selectedSize,
                            items: sizes.map((size) {
                              return DropdownMenuItem(
                                value: size,
                                child: Text(size),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedSize = value!;
                              });
                            },
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
                              IconButton(
                                onPressed: () {
                                  if (qty > 1) setModalState(() => qty--);
                                },
                                icon: const Icon(Icons.remove_circle),
                              ),
                              Text("$qty"),
                              IconButton(
                                onPressed: () {
                                  setModalState(() => qty++);
                                },
                                icon: const Icon(Icons.add_circle),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          final coffeeOrder = Coffee(
                            name: nameController.text,
                            description: "Захиалга",
                            details: "Хэмжээ: $selectedSize | Тоо: $qty",
                            price: 0,
                            image:
                                "https://images.unsplash.com/photo-1511920170033-f8396924c348",
                          );

                          if (coffee == null) {
                            addOrder(coffeeOrder);
                          } else {
                            editOrder(index!, coffeeOrder);
                          }

                          // 🚀 SERVER рүү илгээх
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    coffee.image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  coffee.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(coffee.description),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    minimumSize: const Size(double.infinity, 50),
                  ),
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("☕ Цэс"),
            ),
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
                        Image.network(coffee.image, height: 90, fit: BoxFit.cover),
                        Text(coffee.name),
                        Text("${coffee.price} ₮"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(),

          const Text("🛒 Захиалга"),

          Expanded(
            child: orders.isEmpty
                ? const Center(child: Text("Захиалга алга ☕"))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return ListTile(
                        title: Text(order.name),
                        subtitle: Text(order.details),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  openOrderForm(coffee: order, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteOrder(index),
                            ),
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