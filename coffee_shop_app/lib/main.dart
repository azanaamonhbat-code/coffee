import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/orders_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

// ================= MAIN PAGE =================

class MainPage extends StatefulWidget {
  final String username;

  const MainPage({super.key, required this.username});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const HomePage(),
      const OrdersPage(),
      ProfilePage(username: widget.username),
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // 🔥 CUSTOM NAV ITEM
  Widget navItem(IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          // 🔥 FIX: бүх item нэг бараан background-той боллоо
          color: isSelected
              ? Colors.brown.shade400
              : const Color(0xFF1C1814),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      // 🔥 MODERN FLOATING NAVBAR
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1814),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(Icons.home_rounded, "Нүүр", 0),
              navItem(Icons.local_cafe_rounded, "Захиалга", 1),
              navItem(Icons.person_rounded, "Профайл", 2),
            ],
          ),
        ),
      ),
    );
  }
}