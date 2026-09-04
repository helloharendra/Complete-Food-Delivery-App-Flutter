import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجل المبيعات', style: TextStyle(fontWeight: FontWeight.w900))),
      body: uid.isEmpty
          ? const Center(child: Text('سجّل الدخول أولاً'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('orders').where('sellerUID', isEqualTo: uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('تعذر تحميل سجل المبيعات'));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs.where((doc) {
                  final status = OrderStatusCodec.fromStorage(doc.data()['status']);
                  return status == OrderStatus.delivered || status == OrderStatus.cancelled || status == OrderStatus.rejected;
                }).toList()
                  ..sort((a, b) {
                    final at = a.data()['createdAt'];
                    final bt = b.data()['createdAt'];
                    final av = at is Timestamp ? at.millisecondsSinceEpoch : 0;
                    final bv = bt is Timestamp ? bt.millisecondsSinceEpoch : 0;
                    return bv.compareTo(av);
                  });
                if (docs.isEmpty) return const Center(child: Text('لا توجد طلبات منتهية حتى الآن'));
                return ListView.separated(
                  padding: const EdgeInsets.all(14),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    final data = docs[index].data();
                    final status = OrderStatusCodec.fromStorage(data['status']);
                    final total = (data['total'] as num?)?.toDouble() ?? 0;
                    return Card(
                      child: ListTile(
                        leading: Icon(status == OrderStatus.delivered ? Icons.check_circle_rounded : Icons.cancel_outlined, color: status == OrderStatus.delivered ? Colors.green : Colors.orange),
                        title: Text(data['customerName']?.toString() ?? 'طلب ديرب', style: const TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: Text(status.labelAr),
                        trailing: Text('${total.toStringAsFixed(0)} ج.م', style: const TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
