import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/assistant_methods/total_ammount.dart';
import 'package:user_app/dierb/app_shell.dart';
import 'global/global.dart';
import 'commerce/cart_controller.dart';
import 'design/dierb_theme.dart';
import 'notifications/dierb_notification_service.dart';

const dierbFirebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyBVUGFEPhyNrFwkMjEuV4PGk7EEQS_CQ5I',
  appId: '1:365123606367:android:82969f06df11aba2b8c8ea',
  messagingSenderId: '365123606367',
  projectId: 'dierb-29548',
  authDomain: 'dierb-29548.firebaseapp.com',
  storageBucket: 'dierb-29548.firebasestorage.app',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  Object? firebaseStartupError;
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: dierbFirebaseOptions);
    }
  } catch (error) {
    firebaseStartupError = error;
  }
  runApp(MyApp(firebaseStartupError: firebaseStartupError));
  if (firebaseStartupError == null) {
    DierbNotificationService.start(role: 'customer').catchError((Object error) {
      debugPrint('Notification setup error: $error');
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.firebaseStartupError});
  final Object? firebaseStartupError;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartItemCounter()),
        ChangeNotifierProvider(create: (context) => TotalAmmount()),
        ChangeNotifierProvider(create: (context) => AddressChanger()),
        ChangeNotifierProvider(create: (context) => CartController()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: DierbNotificationService.messengerKey,
        title: 'ديرب',
        debugShowCheckedModeBanner: false,
        theme: DierbTheme.light(),
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        ),
        home: firebaseStartupError == null
            ? const DierbAppShell()
            : FirebaseStartupError(error: firebaseStartupError!),
      ),
    );
  }
}

class FirebaseStartupError extends StatelessWidget {
  const FirebaseStartupError({super.key, required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.cloud_off_rounded, size: 58, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                const Text('تعذر الاتصال بخدمات ديرب', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('إعداد Firebase غير صالح. أغلق التطبيق وافتحه مرة أخرى، وإذا استمرت المشكلة تواصل مع الدعم.', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                SelectableText(error.toString(), style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ]),
            ),
          ),
        ),
      );
}





