import 'package:flutter/material.dart';
import 'package:coffee_shop_app/models/coffee.dart';
import 'package:coffee_shop_app/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  final String username;

  const ProfilePage({super.key, required this.username});

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  List<Coffee> get coffees => [
        Coffee(
          name: "Americano",
          description: "Strong black coffee",
          details: "Classic strong espresso with hot water.",
          price: 5.0,
          image:
              "https://images.unsplash.com/photo-1511920170033-f8396924c348",
        ),
        Coffee(
          name: "Latte",
          description: "Milk coffee",
          details: "Smooth coffee with steamed milk.",
          price: 6.5,
          image:
              "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
        ),
        Coffee(
          name: "Cappuccino",
          description: "Foamy coffee",
          details: "Espresso with milk foam on top.",
          price: 6.0,
          image:
              "https://images.unsplash.com/photo-1521302080334-4bebac2763a6",
        ),
        Coffee(
          name: "Mocha",
          description: "Chocolate coffee",
          details: "Coffee mixed with chocolate flavor.",
          price: 6.8,
          image:
              "https://images.unsplash.com/photo-1551024709-8f23befc6f87",
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        title: const Text("☕ Profile"),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: Column(
        children: [

          // ===== NEW HEADER (EMOJI AVATAR) =====
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF8D58BF)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),

              Positioned(
                bottom: -50,
                left: 0,
                right: 0,
                child: Column(
                  children: [

                    // EMOJI AVATAR
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          "👤",
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      "☕ Coffee Lover",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 70),

          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "🔥 My Favorite Coffees",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ===== COFFEE LIST =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: coffees.length,
              itemBuilder: (context, index) {
                final coffee = coffees[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        coffee.image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),

                    title: Text(
                      coffee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),

                    subtitle: Text(coffee.description),

                    trailing: Text(
                      "${coffee.price.toStringAsFixed(1)} ₮",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
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
}