import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأرباح', style: TextStyle(fontWeight: FontWeight.w900))),
      body: uid.isEmpty
          ? const Center(child: Text('سجّل الدخول أولاً'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('orders').where('sellerUID', isEqualTo: uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text('تعذر تحميل الأرباح'));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final delivered = snapshot.data!.docs.where((doc) => OrderStatusCodec.fromStorage(doc.data()['status']) == OrderStatus.delivered).toList();
                int sumPiasters(String piastersField, String legacyField) => delivered.fold(0, (sum, doc) {
                      final data = doc.data();
                      return sum + ((data[piastersField] as num?)?.toInt() ?? (((data[legacyField] as num?) ?? 0) * 100).round());
                    });
                final gross = sumPiasters('subtotalPiasters', 'subtotal');
                final commission = sumPiasters('platformCommissionPiasters', 'platformCommissionAmount');
                final net = sumPiasters('merchantNetPiasters', 'merchantNetAmount');
                return ListView(
                  padding: const EdgeInsets.all(18),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: const Color(0xFFE0F2E9), borderRadius: BorderRadius.circular(24)),
                      child: Column(children: [
                        const Icon(Icons.account_balance_wallet_rounded, size: 46, color: Color(0xFF166534)),
                        const SizedBox(height: 12),
                        Text('${(net / 100).toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
                        const Text('صافي مستحقاتك من الطلبات المسلّمة'),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(child: _MoneyCard(label: 'إجمالي المبيعات', value: gross, icon: Icons.storefront_rounded)),
                      const SizedBox(width: 10),
                      Expanded(child: _MoneyCard(label: 'عمولة ديرب', value: commission, icon: Icons.percent_rounded)),
                    ]),
                    const SizedBox(height: 10),
                    Card(child: ListTile(leading: const Icon(Icons.receipt_long_rounded), title: const Text('طلبات تم تسليمها'), trailing: Text('${delivered.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)))),
                    const SizedBox(height: 10),
                    const Text('التفاصيل حسب الطلب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    ...delivered.map((doc) {
                      final data = doc.data();
                      final orderNet = (data['merchantNetPiasters'] as num?)?.toInt() ?? ((((data['merchantNetAmount'] ?? data['subtotal']) as num?) ?? 0) * 100).round();
                      return Card(child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.check_rounded)),
                        title: Text(data['customerName']?.toString() ?? 'عميل ديرب'),
                        subtitle: Text('#${doc.id.substring(0, doc.id.length > 8 ? 8 : doc.id.length)}'),
                        trailing: Text('${(orderNet / 100).toStringAsFixed(2)} ج.م', style: const TextStyle(fontWeight: FontWeight.w900)),
                      ));
                    }),
                    const SizedBox(height: 10),
                    const Text('تُحتسب المستحقات من الطلبات التي وصلت إلى «تم التسليم» فقط. التسوية البنكية تُدار منفصلة.', style: TextStyle(color: Colors.black54)),
                  ],
                );
              },
            ),
    );
  }
}

class _MoneyCard extends StatelessWidget {
  const _MoneyCard({required this.label, required this.value, required this.icon});
  final String label;
  final int value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: const Color(0xFF0D6B4E)),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: Color(0xFF68766F), fontSize: 12)),
          Text('${(value / 100).toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ]),
      ));
}
