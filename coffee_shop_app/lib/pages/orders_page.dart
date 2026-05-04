import 'package:flutter/material.dart';
import 'package:coffee_shop_app/models/coffee.dart';

List<Coffee> orders = [];

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<String> sizes = ["Жижиг", "Дунд", "Том"];

  // ☕ MENU (ИЛҮҮ ОЛОН КОФЕ НЭМСЭН)
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

    // ➕ НЭМСЭН КОФЕНҮҮД
    Coffee(
      name: "Mocha",
      description: "Шоколадтай кофе",
      details: "Какао + кофе + сүү",
      price: 20000,
      image: "https://images.unsplash.com/photo-1512568400610-62da28bc8a13",
    ),
    Coffee(
      name: "Espresso",
      description: "Хүчтэй жижиг кофе",
      details: "Pure coffee shot",
      price: 12000,
      image: "https://images.unsplash.com/photo-1510626176961-4b57d4fbad03",
    ),
    Coffee(
      name: "Ice Coffee",
      description: "Хүйтэн кофе",
      details: "Ice + кофе + сүү",
      price: 16000,
      image: "https://images.unsplash.com/photo-1461023058943-07fcbe16d735",
    ),
  ];

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

                      // SIZE
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

                      // QTY
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Тоо ширхэг"),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (qty > 1) {
                                    setModalState(() => qty--);
                                  }
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
                            details:
                                "Хэмжээ: $selectedSize | Тоо: $qty",
                            price: 0,
                            image:
                                "https://images.unsplash.com/photo-1511920170033-f8396924c348",
                          );

                          if (coffee == null) {
                            addOrder(coffeeOrder);
                          } else {
                            editOrder(index!, coffeeOrder);
                          }

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
              child: Text(
                "☕ Цэс",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            coffee.image,
                            height: 90,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(coffee.name),
                        Text(
                          "${coffee.price} ₮",
                          style: const TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "🛒 Захиалга",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: orders.isEmpty
                ? const Center(child: Text("Захиалга алга ☕"))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: ListTile(
                          title: Text(order.name),
                          subtitle: Text(order.details),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                onPressed: () => openOrderForm(
                                    coffee: order, index: index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
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