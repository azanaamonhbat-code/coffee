import 'package:flutter/material.dart';

import 'data/coffee_store.dart';
import 'pages/admin_home_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/orders_page.dart';
import 'pages/profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CoffeeStore.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.45)),
          child: child!,
        );
      },
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/user': (context) {
          final username =
              ModalRoute.of(context)?.settings.arguments as String? ?? 'User';
          return MainNavigationPage(
            pages: [
              const HomePage(),
              const OrdersPage(),
              ProfilePage(username: username),
            ],
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
        '/admin': (context) => const MainNavigationPage(
          pages: [
            AdminHomePage(),
            ProfilePage(username: 'admin'),
          ],
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      },
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> items;

  const MainNavigationPage({
    super.key,
    required this.pages,
    required this.items,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openPage(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: widget.pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _openPage,
        backgroundColor: const Color(0xFF1C1814),
        selectedItemColor: const Color(0xFFC67C4E),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: widget.items,
      ),
    );
  }
}
