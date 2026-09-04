import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/splashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'design/dierb_theme.dart';
import 'notifications/dierb_notification_service.dart';

const _dierbFirebase = FirebaseOptions(
  apiKey: 'AIzaSyBVUGFEPhyNrFwkMjEuV4PGk7EEQS_CQ5I',
  appId: '1:365123606367:android:2067df0428046493b8c8ea',
  messagingSenderId: '365123606367',
  projectId: 'dierb-29548',
  storageBucket: 'dierb-29548.firebasestorage.app',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    if (kDebugMode) FlutterError.dumpErrorToConsole(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) debugPrint('PlatformDispatcher error: $error\n$stack');
    return true;
  };

  Object? startupError;
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: _dierbFirebase);
    }
    firebaseAuth = FirebaseAuth.instance;
    sharedPreferences = await SharedPreferences.getInstance();
  } catch (error, stackTrace) {
    if (kDebugMode) debugPrint('Startup error: $error\n$stackTrace');
    startupError = error;
  }
  runApp(MyApp(startupError: startupError));
  if (startupError == null) {
    DierbNotificationService.start(role: 'merchant').catchError((Object error) => debugPrint('Notification setup error: $error'));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.startupError});
  final Object? startupError;
  @override
  Widget build(BuildContext context) => MaterialApp(
    scaffoldMessengerKey: DierbNotificationService.messengerKey,
    title: 'ديرب للتجار',
    debugShowCheckedModeBanner: false,
    theme: DierbTheme.light(),
    builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child ?? const SizedBox.shrink()),
    home: startupError == null ? const MySplashScreen() : MerchantStartupError(error: startupError!),
  );
}

class MerchantStartupError extends StatelessWidget {
  const MerchantStartupError({super.key, required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.error_outline_rounded, size: 64, color: Theme.of(context).colorScheme.error),
      const SizedBox(height: 16),
      const Text('تعذر تشغيل ديرب للتجار', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      const Text('ظهر خطأ أثناء تهيئة التطبيق. انسخ الرسالة الموجودة بالأسفل وأرسلها للإدارة.', textAlign: TextAlign.center),
      const SizedBox(height: 14),
      SelectableText(error.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ]),
  ))));
}
