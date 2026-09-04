import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DierbMessage extends StatelessWidget {
  const DierbMessage({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 58, color: const Color(0xFF166534)),
            const SizedBox(height: 14),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(subtitle!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, height: 1.4)),
            ],
            if (onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel ?? 'حاول تاني')),
            ],
          ],
        ),
      ),
    );
  }
}

String firestoreErrorMessage(Object error) {
  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return 'لا يوجد صلاحية لعرض هذه البيانات. لو المشكلة مستمرة سجّل خروج ثم دخول، أو تواصل مع الدعم.';
      case 'unavailable':
      case 'deadline-exceeded':
        return 'تعذر الاتصال بخدمات ديرب. تأكد من الإنترنت وحاول مرة أخرى.';
      case 'not-found':
        return 'البيانات المطلوبة غير موجودة.';
      default:
        return 'تعذر تحميل البيانات (${error.code}).';
    }
  }
  return 'تعذر تحميل البيانات. حاول مرة أخرى.';
}
