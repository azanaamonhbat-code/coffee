import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/admin_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🚀 эхлэх хуудас
      initialRoute: '/login',

      // 📌 routes
      routes: {
        // 🔐 Login
        '/login': (context) => const LoginPage(),

        // 👤 User home (no role)
        '/user': (context) => const HomePage(),

        // 👑 Admin panel
        '/admin': (context) => const AdminHomePage(),
      },
    );
  }
}