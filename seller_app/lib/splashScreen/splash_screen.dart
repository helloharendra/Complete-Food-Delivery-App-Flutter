import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seller_app/authentication/auth_screen.dart';
import 'package:seller_app/global/global.dart';
import '../mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final next = firebaseAuth.currentUser != null ? const HomeScreen() : const AuthScreen();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => next));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 48, backgroundColor: Color(0xFFE0F2E9), child: Icon(Icons.storefront_rounded, size: 54, color: Color(0xFF166534))),
            SizedBox(height: 18),
            Text('ديرب للتجار', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            SizedBox(height: 6),
            Text('متجرك وطلباتك في مكان واحد', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
