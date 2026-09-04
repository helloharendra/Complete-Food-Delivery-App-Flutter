import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rider_app/authentication/auth_screen.dart';
import 'package:rider_app/mainScreens/home_screen.dart';

import '../global/global.dart';

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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => firebaseAuth.currentUser != null ? const HomeScreen() : const AuthScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFFE8F5EC),
              child: Icon(Icons.delivery_dining_rounded, size: 48, color: Color(0xFF166534)),
            ),
            SizedBox(height: 18),
            Text('ديرب للمندوبين', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            SizedBox(height: 6),
            Text('استلم الطلبات ووصّلها بسهولة', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
