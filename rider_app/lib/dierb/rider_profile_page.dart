import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RiderProfilePage extends StatelessWidget {
  const RiderProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('سجّل الدخول أولاً')));
    final reference = FirebaseFirestore.instance.collection('riders').doc(user.uid);
    return Scaffold(
      appBar: AppBar(title: const Text('حساب المندوب', style: TextStyle(fontWeight: FontWeight.w900))),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: reference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('تعذر تحميل الحساب'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() ?? <String, dynamic>{};
          return ListView(padding: const EdgeInsets.all(18), children: [
            const CircleAvatar(radius: 42, backgroundColor: Color(0xFFE8F5EC), child: Icon(Icons.delivery_dining_rounded, size: 44, color: Color(0xFF166534))),
            const SizedBox(height: 14),
            Text((data['riderName'] ?? 'مندوب ديرب').toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Text(user.email ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 18),
            Card(child: Column(children: [
              ListTile(leading: const Icon(Icons.phone_outlined), title: const Text('الهاتف'), subtitle: Text((data['phone'] ?? 'غير مسجل').toString())),
              const Divider(height: 1),
              ListTile(leading: const Icon(Icons.location_on_outlined), title: const Text('العنوان'), subtitle: Text((data['address'] ?? 'غير مسجل').toString())),
              const Divider(height: 1),
              ListTile(leading: const Icon(Icons.verified_user_outlined), title: const Text('حالة الحساب'), subtitle: Text(_statusLabel((data['status'] ?? 'pending').toString()))),
            ])),
            const SizedBox(height: 14),
            FilledButton.icon(onPressed: () => _edit(context, reference, data), icon: const Icon(Icons.edit_outlined), label: const Text('تعديل الهاتف والعنوان')),
          ]);
        },
      ),
    );
  }

  String _statusLabel(String value) {
    switch (value.toLowerCase()) {
      case 'approved': return 'معتمد';
      case 'rejected': return 'مرفوض';
      case 'suspended': return 'موقوف';
      default: return 'قيد المراجعة';
    }
  }

  Future<void> _edit(BuildContext context, DocumentReference<Map<String, dynamic>> reference, Map<String, dynamic> data) async {
    final phone = TextEditingController(text: data['phone']?.toString() ?? '');
    final address = TextEditingController(text: data['address']?.toString() ?? '');
    await showModalBottomSheet<void>(context: context, isScrollControlled: true, useSafeArea: true, builder: (sheetContext) => Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.viewInsetsOf(sheetContext).bottom + 20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('تعديل البيانات', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'الهاتف')),
        const SizedBox(height: 10),
        TextField(controller: address, decoration: const InputDecoration(labelText: 'العنوان')),
        const SizedBox(height: 16),
        FilledButton(onPressed: () async {
          await reference.update({'phone': phone.text.trim(), 'address': address.text.trim(), 'updatedAt': FieldValue.serverTimestamp()});
          if (sheetContext.mounted) Navigator.pop(sheetContext);
        }, child: const Text('حفظ')),
      ]),
    ));
  }
}
