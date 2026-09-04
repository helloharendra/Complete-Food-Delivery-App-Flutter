import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/authentication/auth_screen.dart';
import 'package:seller_app/design/dierb_theme.dart';
import 'package:seller_app/mainScreens/earning_screens.dart';
import 'package:seller_app/mainScreens/history_screen.dart';
import 'package:seller_app/mainScreens/new_orders_screen.dart';
import 'package:seller_app/mainScreens/store_settings_screen.dart';
import 'package:seller_app/uploadScreens.dart/menus_upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String get merchantId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Stream<QuerySnapshot<Map<String, dynamic>>> _orders(List<String> statuses) => FirebaseFirestore.instance
      .collection('orders')
      .where('sellerUID', isEqualTo: merchantId)
      .where('status', whereIn: statuses)
      .snapshots();

  Future<void> _toggleStore(bool value) async {
    await FirebaseFirestore.instance.collection('stores').doc(merchantId).update({'isOpen': value, 'updatedAt': FieldValue.serverTimestamp()});
  }

  void _open(Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthScreen()), (_) => false);
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ديرب للتجار', style: TextStyle(fontWeight: FontWeight.w900)),
          Text('إدارة متجرك وطلباتك', style: TextStyle(fontSize: 12, color: DierbTheme.muted)),
        ]),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout_rounded), tooltip: 'تسجيل الخروج')],
      ),
      body: merchantId.isEmpty
          ? const Center(child: Text('سجّل الدخول للمتابعة'))
          : RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                children: [
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection('stores').doc(merchantId).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                        return const _InfoCard(icon: Icons.sync_rounded, title: 'جاري تحميل المتجر...', subtitle: 'ثواني ونجهز لوحة التحكم');
                      }
                      if (snapshot.hasError) {
                        return _InfoCard(icon: Icons.error_outline_rounded, title: 'تعذر تحميل بيانات المتجر', subtitle: '${snapshot.error}');
                      }
                      final data = snapshot.data?.data();
                      if (data == null) return _MissingStoreCard(onTap: () => _open(const StoreSettingsScreen()));
                      final status = (data['status'] ?? 'pending').toString();
                      final isOpen = data['isOpen'] == true;
                      final approved = status == 'approved';
                      final name = (data['name'] ?? 'متجرك').toString();
                      final logo = (data['logo'] ?? '').toString();
                      return _StoreStatusCard(
                        storeName: name,
                        logoUrl: logo,
                        status: status,
                        isOpen: isOpen,
                        onChanged: approved ? _toggleStore : null,
                        onSettings: () => _open(const StoreSettingsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(child: _Metric(title: 'طلبات جديدة', stream: _orders(<String>['normal', OrderStatus.received.name, OrderStatus.waitingMerchantApproval.name]), color: const Color(0xFFFFF3E6), icon: Icons.notifications_active_outlined)),
                    const SizedBox(width: 10),
                    Expanded(child: _Metric(title: 'طلبات حالية', stream: _orders(<String>['accepted', 'acceptedByMerchant', OrderStatus.preparing.name, OrderStatus.readyForPickup.name, OrderStatus.pickedUpByRider.name, OrderStatus.onTheWay.name]), color: const Color(0xFFEAF1F8), icon: Icons.delivery_dining_rounded)),
                  ]),
                  const SizedBox(height: 22),
                  const Text('إدارة المتجر', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: DierbTheme.text)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: .92,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _Action(Icons.receipt_long_rounded, 'الطلبات', () => _open(const NewOrdersScreen())),
                      _Action(Icons.inventory_2_rounded, 'المنتجات', () => _open(const MenusUploadScreen())),
                      _Action(Icons.add_box_rounded, 'إضافة منتج', () => _open(const MenusUploadScreen())),
                      _Action(Icons.storefront_rounded, 'ملف المتجر', () => _open(const StoreSettingsScreen())),
                      _Action(Icons.schedule_rounded, 'ساعات العمل', () => _open(const StoreSettingsScreen())),
                      _Action(Icons.bar_chart_rounded, 'المبيعات', () => _open(const HistoryScreen())),
                      _Action(Icons.account_balance_wallet_rounded, 'الأرباح', () => _open(const EarningScreen())),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.subtitle});
  final IconData icon; final String title; final String subtitle;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
    CircleAvatar(backgroundColor: DierbTheme.surfaceSoft, child: Icon(icon, color: DierbTheme.primary)),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: DierbTheme.muted))])),
  ])));
}

class _MissingStoreCard extends StatelessWidget {
  const _MissingStoreCard({required this.onTap}); final VoidCallback onTap;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    const Text('جهّز ملف متجرك', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
    const SizedBox(height: 8), const Text('أضف صورة المتجر والغلاف والقسم وبيانات التواصل.'),
    const SizedBox(height: 12), FilledButton(onPressed: onTap, child: const Text('إعداد المتجر')),
  ])));
}

class _StoreStatusCard extends StatelessWidget {
  const _StoreStatusCard({required this.storeName, required this.logoUrl, required this.status, required this.isOpen, required this.onSettings, this.onChanged});
  final String storeName; final String logoUrl; final String status; final bool isOpen; final ValueChanged<bool>? onChanged; final VoidCallback onSettings;
  @override Widget build(BuildContext context) {
    final label = status == 'approved' ? 'متجر معتمد' : status == 'rejected' ? 'تم رفض الطلب' : status == 'suspended' ? 'الحساب موقوف' : 'قيد المراجعة';
    final approved = status == 'approved';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DierbTheme.border),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(children: [
        Row(children: [
          Container(
            width: 58, height: 58, clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: DierbTheme.surfaceSoft, borderRadius: BorderRadius.circular(18)),
            child: logoUrl.isEmpty ? const Icon(Icons.store_rounded, color: DierbTheme.primary, size: 30) : Image.network(logoUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.store_rounded, color: DierbTheme.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(storeName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: DierbTheme.text)),
            const SizedBox(height: 4),
            Text('$label • ${approved ? (isOpen ? 'مفتوح' : 'مغلق مؤقتًا') : 'لن يظهر للعامة بعد'}', style: const TextStyle(color: DierbTheme.muted)),
          ])),
          Switch(value: isOpen, onChanged: onChanged),
        ]),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: onSettings, icon: const Icon(Icons.edit_outlined), label: const Text('تعديل ملف المتجر والصور'))),
      ]),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.title, required this.stream, required this.color, required this.icon});
  final String title; final Stream<QuerySnapshot<Map<String, dynamic>>> stream; final Color color; final IconData icon;
  @override Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: stream,
    builder: (_, snapshot) => Container(
      height: 112, padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), border: Border.all(color: DierbTheme.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, size: 18, color: DierbTheme.primary), const SizedBox(width: 6), Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: DierbTheme.text)))]),
        const Spacer(),
        Text(snapshot.hasError ? '!' : '${snapshot.data?.docs.length ?? 0}', style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: DierbTheme.primary)),
      ]),
    ),
  );
}

class _Action extends StatelessWidget {
  const _Action(this.icon, this.label, this.onTap); final IconData icon; final String label; final VoidCallback onTap;
  @override Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: DierbTheme.border)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: DierbTheme.surfaceSoft, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: DierbTheme.primary, size: 25)),
        const SizedBox(height: 9),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, color: DierbTheme.text)),
      ]),
    ),
  );
}
