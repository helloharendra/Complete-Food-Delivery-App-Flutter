import 'package:admin_web_portal/mainScreens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'authentication/login.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? startupError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    startupError = error;
  }
  runApp(MyApp(startupError: startupError));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.startupError});
  final Object? startupError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'إدارة ديرب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF166534)), scaffoldBackgroundColor: const Color(0xFFF7F8F5)),
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      home: startupError != null
          ? _AdminStartupError(error: startupError!)
          : FirebaseAuth.instance.currentUser == null
              ? const LoginScreen()
              : const _AdminGate(),
    );
  }
}

class _AdminStartupError extends StatelessWidget {
  const _AdminStartupError({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off_rounded, size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                const Text('تعذر تشغيل لوحة إدارة ديرب', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                const Text('تعذر تهيئة Firebase. راجع إعداد تطبيق الويب ثم أعد المحاولة.', textAlign: TextAlign.center),
                const SizedBox(height: 14),
                SelectableText(error.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ),
      );
}

class _AdminGate extends StatelessWidget {
  const _AdminGate();
  @override Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('admins').doc(uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        if (snapshot.data?.exists == true) return const HomeScreen();
        return Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.admin_panel_settings_outlined, size: 64), const SizedBox(height: 12), const Text('هذا الحساب غير مصرح له بدخول الإدارة'), TextButton(onPressed: () async { await FirebaseAuth.instance.signOut(); if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); }, child: const Text('تسجيل الخروج'))])));
      },
    );
  }
}
