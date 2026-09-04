import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../orders/order_conversation_page.dart';

class RiderOrdersPage extends StatelessWidget {
  const RiderOrdersPage({super.key, required this.mode});

  final RiderOrdersMode mode;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      return const Scaffold(body: Center(child: Text('سجّل الدخول أولاً')));
    }

    final Query<Map<String, dynamic>> query = mode == RiderOrdersMode.available
        ? FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: OrderStatus.readyForPickup.name)
            .where('riderUID', isEqualTo: '')
        : FirebaseFirestore.instance.collection('orders').where('riderUID', isEqualTo: uid);

    return Scaffold(
      appBar: AppBar(title: Text(mode.title, style: const TextStyle(fontWeight: FontWeight.w900))),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _MessageState(
              icon: Icons.cloud_off_rounded,
              title: 'تعذر تحميل الطلبات',
              subtitle: snapshot.error.toString(),
            );
          }
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs.where((doc) {
            final status = OrderStatusCodec.fromStorage(doc.data()['status']);
            switch (mode) {
              case RiderOrdersMode.available:
                return status == OrderStatus.readyForPickup && (doc.data()['riderUID']?.toString() ?? '').isEmpty;
              case RiderOrdersMode.pickup:
                return status == OrderStatus.pickedUpByRider;
              case RiderOrdersMode.delivering:
                return status == OrderStatus.onTheWay;
              case RiderOrdersMode.history:
                return status == OrderStatus.delivered;
            }
          }).toList()
            ..sort((a, b) => _dateOf(b.data()).compareTo(_dateOf(a.data())));

          if (docs.isEmpty) {
            return _MessageState(
              icon: mode == RiderOrdersMode.history ? Icons.history_rounded : Icons.delivery_dining_rounded,
              title: mode.emptyTitle,
              subtitle: mode.emptySubtitle,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _RiderOrderCard(order: docs[index], mode: mode),
          );
        },
      ),
    );
  }
}

enum RiderOrdersMode { available, pickup, delivering, history }

extension RiderOrdersModeText on RiderOrdersMode {
  String get title {
    switch (this) {
      case RiderOrdersMode.available:
        return 'طلبات توصيل متاحة';
      case RiderOrdersMode.pickup:
        return 'طلبات استلمتها';
      case RiderOrdersMode.delivering:
        return 'في الطريق للعميل';
      case RiderOrdersMode.history:
        return 'سجل التوصيل';
    }
  }

  String get emptyTitle {
    switch (this) {
      case RiderOrdersMode.available:
        return 'مفيش طلبات جاهزة دلوقتي';
      case RiderOrdersMode.pickup:
        return 'مفيش طلبات مستلمة';
      case RiderOrdersMode.delivering:
        return 'مفيش توصيلات في الطريق';
      case RiderOrdersMode.history:
        return 'لسه مفيش توصيلات مكتملة';
    }
  }

  String get emptySubtitle {
    switch (this) {
      case RiderOrdersMode.available:
        return 'أول ما متجر يجهز طلب هتلاقيه هنا.';
      case RiderOrdersMode.pickup:
        return 'استلم طلب من قائمة الطلبات المتاحة.';
      case RiderOrdersMode.delivering:
        return 'بعد استلام الطلب من المتجر ابدأ التوصيل.';
      case RiderOrdersMode.history:
        return 'الطلبات المسلّمة هتظهر هنا.';
    }
  }
}

class _RiderOrderCard extends StatefulWidget {
  const _RiderOrderCard({required this.order, required this.mode});

  final QueryDocumentSnapshot<Map<String, dynamic>> order;
  final RiderOrdersMode mode;

  @override
  State<_RiderOrderCard> createState() => _RiderOrderCardState();
}

class _RiderOrderCardState extends State<_RiderOrderCard> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.order.data();
    final status = OrderStatusCodec.fromStorage(data['status']);
    final items = (data['items'] as List?)?.whereType<Map>().toList() ?? const <Map>[];
    final total = (data['total'] as num?)?.toDouble() ?? 0;
    final store = data['storeName']?.toString() ?? 'متجر ديرب';
    final customer = data['customerName']?.toString() ?? 'العميل';
    final phone = data['customerPhone']?.toString() ?? '';
    final address = data['addressText']?.toString() ?? data['address']?.toString() ?? '';
    final image = items.isEmpty ? '' : (items.first['image'] ?? '').toString();

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _OrderThumb(url: image),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      Text(status.labelAr, style: const TextStyle(color: Color(0xFF0D6B4E), fontSize: 12, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                Text('${total.toStringAsFixed(0)} ج.م', style: const TextStyle(fontWeight: FontWeight.w900)),
              ],
            ),
            const Divider(height: 24),
            _RoutePoint(icon: Icons.storefront_outlined, label: 'الاستلام من', value: store, color: const Color(0xFF0D6B4E)),
            Container(margin: const EdgeInsetsDirectional.only(start: 16), width: 2, height: 15, color: const Color(0xFFD9E2DC)),
            _RoutePoint(icon: Icons.location_on_outlined, label: 'التوصيل إلى', value: address.isEmpty ? customer : '$customer\n$address', color: const Color(0xFF2867B2)),
            if (phone.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 8), child: Row(children: [const Icon(Icons.phone_outlined, size: 18, color: Color(0xFF68766F)), const SizedBox(width: 7), Text(phone, style: const TextStyle(fontWeight: FontWeight.w800))])),
            if (items.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                items.map((item) {
                  final name = item['name']?.toString() ?? 'منتج';
                  final qty = item['quantity'] ?? 1;
                  return '$qty × $name';
                }).join(' • '),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
            const SizedBox(height: 14),
            if (widget.mode != RiderOrdersMode.available) ...[
              Row(children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderConversationPage(orderId: widget.order.id))),
                  icon: const Icon(Icons.forum_outlined),
                  label: const Text('محادثة العميل'),
                )),
                if (widget.mode == RiderOrdersMode.delivering) ...[
                  const SizedBox(width: 8),
                  Expanded(child: FilledButton.tonalIcon(
                    onPressed: _busy ? null : _notifyArrival,
                    icon: const Icon(Icons.location_on_rounded),
                    label: const Text('وصلت'),
                  )),
                ],
              ]),
              const SizedBox(height: 9),
            ],
            if (widget.mode == RiderOrdersMode.available)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _busy ? null : _claim,
                  icon: const Icon(Icons.delivery_dining_rounded),
                  label: Text(_busy ? 'جاري الاستلام...' : 'استلام الطلب'),
                ),
              ),
            if (widget.mode == RiderOrdersMode.pickup)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _busy ? null : () => _changeStatus(OrderStatus.onTheWay),
                  icon: const Icon(Icons.route_rounded),
                  label: Text(_busy ? 'جاري التحديث...' : 'خرجت للتوصيل'),
                ),
              ),
            if (widget.mode == RiderOrdersMode.delivering)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _busy ? null : () => _changeStatus(OrderStatus.delivered),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: Text(_busy ? 'جاري التحديث...' : 'تم التسليم للعميل'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _claim() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _busy = true);
    try {
      final riderSnap = await FirebaseFirestore.instance.collection('riders').doc(user.uid).get();
      final rider = riderSnap.data() ?? <String, dynamic>{};
      final status = rider['status']?.toString() ?? '';
      if (status != 'approved' && status != 'Approved') {
        throw StateError('حساب المندوب غير معتمد بعد');
      }
      if (rider['available'] != true) {
        throw StateError('فعّل حالة متاح من الصفحة الرئيسية قبل استلام الطلب');
      }
      final riderName = rider['riderName']?.toString() ?? user.displayName ?? 'مندوب ديرب';
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final fresh = await tx.get(widget.order.reference);
        final data = fresh.data() ?? <String, dynamic>{};
        final currentStatus = OrderStatusCodec.fromStorage(data['status']);
        final currentRider = data['riderUID']?.toString() ?? '';
        if (currentStatus != OrderStatus.readyForPickup || currentRider.isNotEmpty) {
          throw StateError('الطلب استلمه مندوب آخر');
        }
        tx.update(widget.order.reference, <String, dynamic>{
          'riderUID': user.uid,
          'riderName': riderName,
          'status': OrderStatus.pickedUpByRider.name,
          'pickedUpAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم استلام الطلب')));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _changeStatus(OrderStatus next) async {
    setState(() => _busy = true);
    try {
      final fresh = await widget.order.reference.get();
      final current = OrderStatusCodec.fromStorage(fresh.data()?['status']);
      if (!OrderStatusCodec.canTransition(current, next)) {
        throw StateError('حالة الطلب تغيرت بالفعل. حدّث القائمة وحاول مرة أخرى.');
      }
      final payload = <String, dynamic>{
        'status': next.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (next == OrderStatus.onTheWay) payload['onTheWayAt'] = FieldValue.serverTimestamp();
      if (next == OrderStatus.delivered) {
        payload['deliveredAt'] = FieldValue.serverTimestamp();
        if (fresh.data()?['paymentMethod'] == 'cashOnDelivery') {
          payload.addAll(<String, dynamic>{
            'cashCollected': true,
            'collectedBy': FirebaseAuth.instance.currentUser!.uid,
            'collectedAt': FieldValue.serverTimestamp(),
            'paymentStatus': 'cashCollected',
          });
        }
      }
      await widget.order.reference.update(payload);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.labelAr)));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _notifyArrival() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _busy = true);
    try {
      await widget.order.reference.collection('messages').add({
        'senderId': user.uid,
        'senderRole': 'rider',
        'text': 'المندوب وصل لمكان التسليم',
        'type': 'riderArrived',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إبلاغ العميل إنك وصلت')));
    } on FirebaseException catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر إرسال التنبيه: ${error.code}')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _OrderThumb extends StatelessWidget {
  const _OrderThumb({required this.url});
  final String url;
  @override
  Widget build(BuildContext context) => Container(
        width: 50, height: 50, clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: const Color(0xFFE8F5EC), borderRadius: BorderRadius.circular(15)),
        child: url.isEmpty ? const Icon(Icons.storefront_rounded, color: Color(0xFF0D6B4E)) : Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined)),
      );
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({required this.icon, required this.label, required this.value, required this.color});
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 34, height: 34, decoration: BoxDecoration(color: color.withValues(alpha: .1), shape: BoxShape.circle), child: Icon(icon, size: 19, color: color)),
        const SizedBox(width: 9),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFF68766F), fontSize: 11)), Text(value, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.35))])),
      ]);
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 58, color: Colors.grey),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

DateTime _dateOf(Map<String, dynamic> data) {
  final updated = data['updatedAt'];
  if (updated is Timestamp) return updated.toDate();
  final created = data['createdAt'];
  if (created is Timestamp) return created.toDate();
  return DateTime.fromMillisecondsSinceEpoch(0);
}
