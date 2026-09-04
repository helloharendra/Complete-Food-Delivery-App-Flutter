import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../orders/order_conversation_page.dart';

class NewOrdersScreen extends StatelessWidget {
  const NewOrdersScreen({super.key});

  String get merchantId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    if (merchantId.isEmpty) {
      return const Scaffold(body: Center(child: Text('سجّل الدخول كتاجر أولاً')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات المتجر', style: TextStyle(fontWeight: FontWeight.w900))),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').where('sellerUID', isEqualTo: merchantId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const _StateMessage(icon: Icons.cloud_off_rounded, title: 'تعذر تحميل الطلبات', subtitle: 'راجع الاتصال وحاول مرة أخرى.');
          }
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs.toList()
            ..sort((a, b) {
              final ad = a.data()['createdAt'];
              final bd = b.data()['createdAt'];
              final at = ad is Timestamp ? ad.millisecondsSinceEpoch : 0;
              final bt = bd is Timestamp ? bd.millisecondsSinceEpoch : 0;
              return bt.compareTo(at);
            });
          if (docs.isEmpty) {
            return const _StateMessage(
              icon: Icons.receipt_long_outlined,
              title: 'لا توجد طلبات حتى الآن',
              subtitle: 'أول طلب من عميل ديرب سيظهر هنا مباشرة.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _OrderCard(doc: docs[index]),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.doc});
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  Future<void> _setStatus(BuildContext context, OrderStatus status) async {
    try {
      final fresh = await doc.reference.get();
      final current = OrderStatusCodec.fromStorage(fresh.data()?['status']);
      if (!OrderStatusCodec.canTransition(current, status)) {
        throw StateError('حالة الطلب تغيرت بالفعل. حدّث الصفحة وحاول مرة أخرى.');
      }
      await doc.reference.update(<String, dynamic>{
        'status': OrderStatusCodec.toStorage(status),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(status.labelAr)));
    } on FirebaseException catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر تحديث الطلب: ${e.code}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final items = (data['items'] as List?)?.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() ?? const <Map<String, dynamic>>[];
    final status = OrderStatusCodec.fromStorage(data['status']);
    final total = (data['total'] as num?)?.toDouble() ?? 0;
    final customer = data['customerName']?.toString() ?? 'عميل ديرب';
    final phone = data['customerPhone']?.toString() ?? '';
    final address = data['addressText']?.toString() ?? '';
    final isNew = status == OrderStatus.waitingMerchantApproval;
    return Card(
      color: isNew ? const Color(0xFFFFFBF2) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: isNew ? const Color(0xFFFFB547) : const Color(0xFFE1E8E3), width: isNew ? 1.6 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Container(width: 46, height: 46, decoration: BoxDecoration(color: isNew ? const Color(0xFFFFE9C4) : const Color(0xFFDCEFE6), borderRadius: BorderRadius.circular(14)), child: Icon(isNew ? Icons.notifications_active_rounded : Icons.receipt_long_rounded, color: isNew ? const Color(0xFF9A5A00) : const Color(0xFF0D6B4E))),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(isNew ? 'طلب جديد' : status.labelAr, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
              Text('#${doc.id.substring(0, doc.id.length > 7 ? 7 : doc.id.length)} • ${_formatTime(data['createdAt'])}', style: const TextStyle(color: Color(0xFF68766F), fontSize: 12)),
            ])),
            Text('${total.toStringAsFixed(0)} ج.م', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF5F7F4), borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Row(children: [const Icon(Icons.person_outline_rounded, size: 19), const SizedBox(width: 7), Expanded(child: Text(customer, style: const TextStyle(fontWeight: FontWeight.w800))), if (phone.isNotEmpty) Text(phone, style: const TextStyle(color: Color(0xFF0D6B4E), fontWeight: FontWeight.w800))]),
              if (address.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 7), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.location_on_outlined, size: 19), const SizedBox(width: 7), Expanded(child: Text(address, style: const TextStyle(color: Color(0xFF68766F))))])),
            ]),
          ),
          const Divider(height: 24),
          ...items.map((item) {
            final name = item['name']?.toString() ?? 'منتج';
            final qty = (item['quantity'] as num?)?.toInt() ?? 1;
            final price = (item['price'] as num?)?.toDouble() ?? 0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(children: [
                _ProductThumb(url: (item['image'] ?? '').toString()),
                const SizedBox(width: 9),
                Expanded(child: Text('$name × $qty', style: const TextStyle(fontWeight: FontWeight.w700))),
                Text('${(price * qty).toStringAsFixed(0)} ج.م', style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
            );
          }),
          const Divider(height: 24),
          Row(children: [
            const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.w800)),
            const Spacer(),
            Text('${total.toStringAsFixed(0)} ج.م', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderConversationPage(orderId: doc.id))),
            icon: const Icon(Icons.forum_outlined),
            label: const Text('محادثة العميل والمندوب'),
          ),
          const SizedBox(height: 8),
          _actions(context, status),
        ]),
      ),
    );
  }

  Widget _actions(BuildContext context, OrderStatus status) {
    if (status == OrderStatus.waitingMerchantApproval) {
      return Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: () => _setStatus(context, OrderStatus.rejected), icon: const Icon(Icons.close_rounded), label: const Text('رفض'))),
        const SizedBox(width: 10),
        Expanded(child: FilledButton.icon(onPressed: () => _setStatus(context, OrderStatus.acceptedByMerchant), icon: const Icon(Icons.check_rounded), label: const Text('قبول الطلب'))),
      ]);
    }
    if (status == OrderStatus.acceptedByMerchant) {
      return FilledButton.icon(onPressed: () => _setStatus(context, OrderStatus.preparing), icon: const Icon(Icons.soup_kitchen_outlined), label: const Text('بدء التجهيز'));
    }
    if (status == OrderStatus.preparing) {
      return FilledButton.icon(onPressed: () => _setStatus(context, OrderStatus.readyForPickup), icon: const Icon(Icons.inventory_2_outlined), label: const Text('جاهز للمندوب'));
    }
    return const SizedBox.shrink();
  }
}

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({required this.url});
  final String url;
  @override
  Widget build(BuildContext context) => Container(
        width: 44, height: 44, clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: const Color(0xFFEAF2ED), borderRadius: BorderRadius.circular(12)),
        child: url.isEmpty ? const Icon(Icons.inventory_2_outlined, size: 20, color: Color(0xFF0D6B4E)) : Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined)),
      );
}

String _formatTime(Object? value) {
  final date = value is Timestamp ? value.toDate() : null;
  if (date == null) return 'الآن';
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  return '${date.day}/${date.month} • $hour:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'م' : 'ص'}';
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 62, color: const Color(0xFF166534)),
            const SizedBox(height: 14),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center),
          ]),
        ),
      );
}
