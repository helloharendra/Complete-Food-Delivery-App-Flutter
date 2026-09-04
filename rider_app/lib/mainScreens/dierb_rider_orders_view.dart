import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DierbRiderOrdersView extends StatelessWidget {
  const DierbRiderOrdersView({
    super.key,
    required this.title,
    required this.statuses,
    this.availableOrders = false,
  });

  final String title;
  final List<String> statuses;
  final bool availableOrders;

  String get riderId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Query<Map<String, dynamic>> _query() {
    final base = FirebaseFirestore.instance.collection('orders');
    if (availableOrders) {
      return base
          .where('status', isEqualTo: OrderStatus.readyForPickup.name)
          .where('riderUID', isEqualTo: '');
    }
    return base
        .where('riderUID', isEqualTo: riderId)
        .where('status', whereIn: statuses);
  }

  Future<void> _claim(BuildContext context, DocumentReference<Map<String, dynamic>> ref) async {
    if (riderId.isEmpty) return;
    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snap = await tx.get(ref);
        final data = snap.data();
        if (data == null || data['status'] != OrderStatus.readyForPickup.name) {
          throw FirebaseException(plugin: 'cloud_firestore', code: 'order-unavailable');
        }
        final assigned = data['riderUID']?.toString() ?? '';
        if (assigned.isNotEmpty && assigned != riderId) {
          throw FirebaseException(plugin: 'cloud_firestore', code: 'already-assigned');
        }
        tx.update(ref, <String, dynamic>{
          'riderUID': riderId,
          'status': OrderStatus.pickedUpByRider.name,
          'pickedUpAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم استلام الطلب')));
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر استلام الطلب: ${e.code}')));
      }
    }
  }

  Future<void> _setStatus(BuildContext context, DocumentReference<Map<String, dynamic>> ref, String status) async {
    try {
      final snapshot = await ref.get();
      final data = snapshot.data() ?? const <String, dynamic>{};
      final collectingCod = status == OrderStatus.delivered.name && data['paymentMethod'] == 'cashOnDelivery';
      await ref.update(<String, dynamic>{
        'status': status,
        if (status == OrderStatus.onTheWay.name) 'onTheWayAt': FieldValue.serverTimestamp(),
        if (status == OrderStatus.delivered.name) 'deliveredAt': FieldValue.serverTimestamp(),
        if (collectingCod) 'cashCollected': true,
        if (collectingCod) 'collectedBy': riderId,
        if (collectingCod) 'collectedAt': FieldValue.serverTimestamp(),
        if (collectingCod) 'paymentStatus': 'cashCollected',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث حالة الطلب')));
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر تحديث الطلب: ${e.code}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!availableOrders && riderId.isEmpty) {
      return const Scaffold(body: Center(child: Text('سجّل الدخول كمندوب أولاً')));
    }
    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _query().snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('تعذر تحميل الطلبات الآن'));
          }
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs.toList()
            ..sort((a, b) {
              final at = a.data()['createdAt'];
              final bt = b.data()['createdAt'];
              final am = at is Timestamp ? at.millisecondsSinceEpoch : 0;
              final bm = bt is Timestamp ? bt.millisecondsSinceEpoch : 0;
              return bm.compareTo(am);
            });
          if (docs.isEmpty) {
            return const Center(child: Text('لا توجد طلبات في هذه المرحلة'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _OrderCard(
              doc: docs[index],
              availableOrders: availableOrders,
              onClaim: () => _claim(context, docs[index].reference),
              onStatus: (status) => _setStatus(context, docs[index].reference, status),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.doc,
    required this.availableOrders,
    required this.onClaim,
    required this.onStatus,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final bool availableOrders;
  final VoidCallback onClaim;
  final ValueChanged<String> onStatus;

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final status = data['status']?.toString() ?? '';
    final items = (data['items'] as List?)
            ?.whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        const <Map<String, dynamic>>[];
    final total = (data['total'] as num?)?.toDouble() ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(data['storeName']?.toString() ?? 'متجر ديرب', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(data['customerName']?.toString() ?? 'عميل ديرب'),
          if ((data['customerPhone']?.toString() ?? '').isNotEmpty) Text(data['customerPhone'].toString()),
          if ((data['addressText']?.toString() ?? '').isNotEmpty) Text(data['addressText'].toString()),
          const Divider(height: 22),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('${item['name'] ?? 'منتج'} × ${(item['quantity'] as num?)?.toInt() ?? 1}'),
              )),
          const SizedBox(height: 8),
          Text('الإجمالي: ${total.toStringAsFixed(0)} ج.م', style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          if (availableOrders)
            FilledButton(onPressed: onClaim, child: const Text('استلام الطلب'))
          else if (status == OrderStatus.pickedUpByRider.name)
            FilledButton(onPressed: () => onStatus(OrderStatus.onTheWay.name), child: const Text('بدء التوصيل'))
          else if (status == OrderStatus.onTheWay.name)
            FilledButton(onPressed: () => onStatus(OrderStatus.delivered.name), child: const Text('تم التسليم')),
        ]),
      ),
    );
  }
}
