import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/dierb_states.dart';
import 'order_conversation_page.dart';

enum _OrderFilter { active, completed, cancelled }

class CustomerOrdersPage extends StatefulWidget {
  const CustomerOrdersPage({super.key});
  @override
  State<CustomerOrdersPage> createState() => _CustomerOrdersPageState();
}

class _CustomerOrdersPageState extends State<CustomerOrdersPage> {
  _OrderFilter filter = _OrderFilter.active;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('طلباتي', style: TextStyle(fontWeight: FontWeight.w900))),
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, auth) {
              final user = auth.data;
              if (user == null) {
                return const DierbMessage(icon: Icons.lock_outline_rounded, title: 'سجّل الدخول علشان تتابع طلباتك');
              }
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SegmentedButton<_OrderFilter>(
                    segments: const [
                      ButtonSegment(value: _OrderFilter.active, label: Text('الحالية')),
                      ButtonSegment(value: _OrderFilter.completed, label: Text('المكتملة')),
                      ButtonSegment(value: _OrderFilter.cancelled, label: Text('الملغية/المرفوضة')),
                    ],
                    selected: {filter},
                    onSelectionChanged: (value) => setState(() => filter = value.first),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection('orders').where('orderedBy', isEqualTo: user.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return DierbMessage(icon: Icons.error_outline, title: firestoreErrorMessage(snapshot.error!));
                      }
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      final docs = snapshot.data!.docs.where((doc) => _matches(doc.data())).toList()
                        ..sort((a, b) => _orderMillis(b.data()).compareTo(_orderMillis(a.data())));
                      if (docs.isEmpty) {
                        return const DierbMessage(
                          icon: Icons.receipt_long_outlined,
                          title: 'مفيش طلبات في القسم ده',
                          subtitle: 'بعد إتمام طلب من متجر هتقدر تتابع حالته هنا خطوة بخطوة.',
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(14, 4, 14, 90),
                        itemCount: docs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, index) => _OrderCard(id: docs[index].id, data: docs[index].data()),
                      );
                    },
                  ),
                ),
              ]);
            },
          ),
        ),
      );

  bool _matches(Map<String, dynamic> data) {
    final status = OrderStatusCodec.fromStorage(data['status']?.toString());
    if (filter == _OrderFilter.completed) return status == OrderStatus.delivered;
    if (filter == _OrderFilter.cancelled) return status == OrderStatus.cancelled || status == OrderStatus.rejected;
    return status.isActive;
  }
}

int _orderMillis(Map<String, dynamic> data) {
  final value = data['createdAt'] ?? data['orderTime'];
  if (value is Timestamp) return value.millisecondsSinceEpoch;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.id, required this.data});
  final String id;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final status = OrderStatusCodec.fromStorage(data['status']?.toString());
    final total = (data['total'] ?? data['totolAmmount'] ?? 0) as num;
    final items = (data['items'] as List?)?.whereType<Map>().toList() ?? const <Map>[];
    final firstImage = items.isEmpty ? '' : (items.first['image'] ?? '').toString();
    final storeName = (data['storeName'] ?? 'متجر ديرب').toString();
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              _OrderImage(url: firstImage),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(storeName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 3),
                Text('${items.length} منتج • ${_formatOrderTime(data)}', style: const TextStyle(color: Color(0xFF68766F), fontSize: 12)),
              ])),
              Text('${total.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            ]),
            const Divider(height: 24),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(color: _statusColor(status).withValues(alpha: .1), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_statusIcon(status), color: _statusColor(status), size: 18),
                  const SizedBox(width: 6),
                  Text(status.labelAr, style: TextStyle(color: _statusColor(status), fontWeight: FontWeight.w900, fontSize: 12)),
                ]),
              ),
              const Spacer(),
              Text('عرض التفاصيل', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w800, fontSize: 12)),
              const SizedBox(width: 3),
              Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: Theme.of(context).colorScheme.primary),
            ]),
          ]),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final status = OrderStatusCodec.fromStorage(data['status']?.toString());
    final items = (data['items'] as List?)?.whereType<Map>().toList() ?? const [];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .86,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(20),
          children: [
            Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFFDCEFE6), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF0D6B4E))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('تفاصيل الطلب', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                Text('#${id.length > 8 ? id.substring(id.length - 8) : id} • ${_formatOrderTime(data)}', style: const TextStyle(color: Color(0xFF68766F))),
              ])),
            ]),
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF7FAF8), borderRadius: BorderRadius.circular(20)), child: _Timeline(current: status)),
            const Divider(height: 30),
            if ((data['storeName'] ?? '').toString().isNotEmpty) ListTile(leading: const Icon(Icons.storefront_outlined), title: Text(data['storeName'].toString())),
            ListTile(leading: const Icon(Icons.location_on_outlined), title: const Text('عنوان التوصيل'), subtitle: Text((data['addressText'] ?? data['address'] ?? data['addressId'] ?? 'غير محدد').toString())),
            ListTile(leading: const Icon(Icons.payments_outlined), title: const Text('طريقة الدفع'), subtitle: Text(data['paymentMethod'] == 'cashOnDelivery' ? 'الدفع عند الاستلام' : (data['paymentMethod'] ?? 'الدفع عند الاستلام').toString())),
            if ((data['customerPhone'] ?? '').toString().isNotEmpty) ListTile(leading: const Icon(Icons.phone_outlined), title: const Text('هاتف الاستلام'), subtitle: Text(data['customerPhone'].toString())),
            if ((data['notes'] ?? '').toString().isNotEmpty) ListTile(leading: const Icon(Icons.notes_rounded), title: const Text('ملاحظات'), subtitle: Text(data['notes'].toString())),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderConversationPage(orderId: id, role: 'customer'))),
                icon: const Icon(Icons.forum_outlined),
                label: const Text('محادثة التاجر والمندوب'),
              ),
            ),
            const SizedBox(height: 12),
            const Text('المنتجات', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
            if (items.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('تفاصيل المنتجات غير متاحة لهذا الطلب.')),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(children: [
                    _OrderImage(url: (item['image'] ?? '').toString(), size: 54),
                    const SizedBox(width: 11),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text((item['name'] ?? 'منتج').toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text('الكمية: ${item['quantity'] ?? 1}', style: const TextStyle(color: Color(0xFF68766F), fontSize: 12)),
                    ])),
                    Text('${item['price'] ?? 0} ج.م', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ]),
                )),
            const Divider(),
            if ((data['deliveryFee'] as num?) != null) ListTile(title: const Text('رسوم التوصيل'), trailing: Text('${data['deliveryFee']} ج.م')),
            ListTile(
              title: const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.w900)),
              trailing: Text('${data['total'] ?? data['totolAmmount'] ?? 0} ج.م', style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.current});
  final OrderStatus current;

  static const flow = <OrderStatus>[
    OrderStatus.waitingMerchantApproval,
    OrderStatus.acceptedByMerchant,
    OrderStatus.preparing,
    OrderStatus.readyForPickup,
    OrderStatus.pickedUpByRider,
    OrderStatus.onTheWay,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    if (current == OrderStatus.cancelled) {
      return const ListTile(leading: Icon(Icons.cancel_rounded, color: Colors.red), title: Text('ملغي', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)));
    }
    if (current == OrderStatus.rejected) {
      return const ListTile(leading: Icon(Icons.block_rounded, color: Colors.red), title: Text('رفض المتجر الطلب', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900)));
    }
    final currentIndex = flow.indexOf(current);
    return Column(children: List.generate(flow.length, (index) {
      final complete = index <= currentIndex;
      final currentStep = index == currentIndex;
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250), width: 26, height: 26,
            decoration: BoxDecoration(color: complete ? const Color(0xFF0D6B4E) : Colors.white, shape: BoxShape.circle, border: Border.all(color: complete ? const Color(0xFF0D6B4E) : const Color(0xFFCBD5CF), width: 2)),
            child: Icon(complete ? Icons.check_rounded : Icons.circle, size: complete ? 17 : 7, color: complete ? Colors.white : const Color(0xFFCBD5CF)),
          ),
          if (index < flow.length - 1) Container(width: 2, height: 27, color: index < currentIndex ? const Color(0xFF0D6B4E) : const Color(0xFFDDE5E0)),
        ]),
        const SizedBox(width: 11),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(flow[index].labelAr, style: TextStyle(color: complete ? const Color(0xFF14231D) : const Color(0xFF829087), fontWeight: currentStep ? FontWeight.w900 : FontWeight.w600)),
        )),
        if (currentStep) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFEBCB), borderRadius: BorderRadius.circular(9)), child: const Text('الحالة الحالية', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900))),
      ]);
    }));
  }
}

class _OrderImage extends StatelessWidget {
  const _OrderImage({required this.url, this.size = 62});
  final String url;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size, clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: const Color(0xFFEAF2ED), borderRadius: BorderRadius.circular(16)),
        child: url.isEmpty
            ? const Icon(Icons.inventory_2_outlined, color: Color(0xFF0D6B4E))
            : Image.network(url, fit: BoxFit.cover, loadingBuilder: (_, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)), errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined, color: Color(0xFF68766F))),
      );
}

String _formatOrderTime(Map<String, dynamic> data) {
  final value = data['createdAt'] ?? data['orderTime'];
  final date = value is Timestamp ? value.toDate() : DateTime.tryParse(value?.toString() ?? '');
  if (date == null) return 'الوقت غير محدد';
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.day}/${date.month} • $hour:$minute ${date.hour >= 12 ? 'م' : 'ص'}';
}

Color _statusColor(OrderStatus status) {
  if (status == OrderStatus.cancelled || status == OrderStatus.rejected) return const Color(0xFFC63C3C);
  if (status == OrderStatus.delivered) return const Color(0xFF0D6B4E);
  if (status == OrderStatus.onTheWay || status == OrderStatus.pickedUpByRider) return const Color(0xFF2867B2);
  return const Color(0xFF9A5A00);
}

IconData _statusIcon(OrderStatus status) {
  if (status == OrderStatus.delivered) return Icons.check_circle_outline;
  if (status == OrderStatus.cancelled || status == OrderStatus.rejected) return Icons.cancel_outlined;
  if (status == OrderStatus.onTheWay || status == OrderStatus.pickedUpByRider) return Icons.delivery_dining;
  return Icons.schedule_rounded;
}
