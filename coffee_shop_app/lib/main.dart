import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'dart:ui' as ui;

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
      title: 'Coffee Shop',
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
  late final LiquidController _liquidController;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _liquidController = LiquidController();

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
    _liquidController.animateToPage(page: index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: LiquidSwipe(
        pages: pages,
        liquidController: _liquidController,
        fullTransitionValue: 600,
        enableSideReveal: true,
        enableLoop: false,
        waveType: WaveType.liquidReveal,
        positionSlideIcon: 0.5,
        slideIconWidget: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white70,
          size: 28,
        ),
        onPageChangeCallback: (index) {
          setState(() => selectedIndex = index);
        },
      ),

      // Modern Floating Bottom Navigation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1814),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
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

  Widget navItem(IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 18 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown.shade400 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}