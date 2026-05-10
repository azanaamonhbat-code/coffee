import 'dart:ui';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = "user";
  static const _coffeeBrown = Color(0xFF1C1814);
  static const _accent = Color(0xFFC67C4E);

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if ((selectedRole == "user" && username.isEmpty) || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Бүх талбарыг бөглөнө үү")));
      return;
    }

    if (password != "1234") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Нууц үг буруу")));
      return;
    }

    if (selectedRole == "admin") {
      Navigator.pushReplacementNamed(context, '/admin');
    } else {
      Navigator.pushReplacementNamed(context, '/user', arguments: username);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _coffeeBrown,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/coffee24.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.22),
                  _coffeeBrown.withValues(alpha: 0.78),
                ],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 430;
                final cardWidth = compact ? constraints.maxWidth : 380.0;
                final horizontalPadding = compact ? 18.0 : 28.0;

                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: cardWidth),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          compact ? 18 : 24,
                          compact ? 20 : 26,
                          compact ? 18 : 24,
                          compact ? 20 : 24,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF2B211C,
                          ).withValues(alpha: 0.86),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 28,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Icon(
                              Icons.local_cafe_rounded,
                              color: _accent,
                              size: 34,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Coffee Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Welcome back",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.72),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(child: roleButton("user", "User")),
                                const SizedBox(width: 10),
                                Expanded(child: roleButton("admin", "Admin")),
                              ],
                            ),
                            const SizedBox(height: 14),
                            field(
                              controller: usernameController,
                              hint: "Username",
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 12),
                            field(
                              controller: passwordController,
                              hint: "Password",
                              icon: Icons.lock_outline,
                              obscure: true,
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget roleButton(String role, String label) {
    final isSelected = selectedRole == role;
    return InkWell(
      onTap: () => setState(() => selectedRole = role),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? _accent.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _accent : Colors.white.withValues(alpha: 0.18),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: Colors.brown.shade300),
        prefixIcon: Icon(icon, color: _accent, size: 21),
        filled: true,
        fillColor: const Color(0xFFFFF8F2),
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
      ),
    );
  }
}
