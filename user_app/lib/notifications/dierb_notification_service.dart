import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DierbNotificationService {
  DierbNotificationService._();

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static String? _role;

  static Future<void> start({required String role}) async {
    if (kIsWeb) return;
    _role = role;
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) return;
      final token = await messaging.getToken();
      if (token != null) await _saveToken(user.uid, token);
    });
    messaging.onTokenRefresh.listen((token) async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) await _saveToken(uid, token);
    });
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? 'إشعار من ديرب';
      final body = message.notification?.body ?? '';
      messengerKey.currentState?.showSnackBar(SnackBar(
        content: Text(body.isEmpty ? title : '$title\n$body'),
        behavior: SnackBarBehavior.floating,
      ));
    });
  }

  static Future<void> _saveToken(String uid, String token) async {
    final id = base64Url.encode(utf8.encode(token)).replaceAll('=', '');
    await FirebaseFirestore.instance
        .collection('deviceTokens').doc(uid).collection('tokens').doc(id)
        .set(<String, dynamic>{
      'uid': uid,
      'token': token,
      'role': _role,
      'platform': defaultTargetPlatform.name,
      'active': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
