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
          name: "Sidama",
          description: "COMMON ROOM",
          details: "",
          price: 0,
          image: "https://images.unsplash.com/photo-1511920170033-f8396924c348",
        ),
        Coffee(
          name: "Geisha",
          description: "PASSENGER COFFEE",
          details: "",
          price: 0,
          image: "https://images.unsplash.com/photo-1509042239860-f550ce710b93",
        ),
        Coffee(
          name: "La Pastora",
          description: "METHODICAL COFFEE",
          details: "",
          price: 0,
          image: "https://images.unsplash.com/photo-1521302080334-4bebac2763a6",
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=2070",
            ),
            fit: BoxFit.cover,
            opacity: 0.88,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                const Color(0xFF2C1810).withOpacity(0.65),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ==================== HEADER - Бор өнгөгүй (бүрэн ил) ====================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
                  decoration: BoxDecoration(
                    color: Colors.transparent,   // Бор өнгө бүрмөсөн арилгалаа
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFEE7C3A), width: 4),
                        ),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: Text(
                            "👤",
                            style: TextStyle(fontSize: 75, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Coffee Enthusiast",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEE7C3A),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Premium Member",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // My Favorite Coffees
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "My Favorite Coffees",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C1810),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Coffee List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: coffees.length,
                    itemBuilder: (context, index) {
                      final coffee = coffees[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  coffee.image,
                                  width: 95,
                                  height: 95,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coffee.name,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C1810),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      coffee.description,
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) => const Icon(Icons.star, color: Colors.amber, size: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.favorite, color: Color(0xFFEE7C3A), size: 26),
                                  const SizedBox(height: 24),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2C1810),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Text(
                                      "Order",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}