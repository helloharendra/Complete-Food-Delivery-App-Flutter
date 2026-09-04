import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authentication/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _Section {
  const _Section(this.label, this.icon, this.collection, {this.approval = false});
  final String label;
  final IconData icon;
  final String? collection;
  final bool approval;
}

class _HomeScreenState extends State<HomeScreen> {
  int selected = 0;
  static const sections = <_Section>[
    _Section('لوحة التحكم', Icons.dashboard_rounded, null),
    _Section('أرباحي', Icons.account_balance_wallet_rounded, null),
    _Section('المستخدمون', Icons.people_rounded, 'users'),
    _Section('طلبات التجار', Icons.badge_rounded, 'merchantApplications', approval: true),
    _Section('المتاجر', Icons.store_rounded, 'stores', approval: true),
    _Section('المنتجات', Icons.inventory_2_rounded, 'products'),
    _Section('الأقسام', Icons.category_rounded, 'categories'),
    _Section('الطلبات', Icons.receipt_long_rounded, 'orders'),
    _Section('المندوبون', Icons.delivery_dining_rounded, 'riders', approval: true),
    _Section('اسأل ديرب', Icons.forum_rounded, 'communityPosts'),
    _Section('الخدمات', Icons.handyman_rounded, 'services'),
    _Section('العقارات', Icons.apartment_rounded, 'properties'),
    _Section('الوظائف', Icons.work_rounded, 'jobs'),
    _Section('العروض', Icons.local_offer_rounded, 'offers'),
    _Section('البلاغات', Icons.flag_rounded, 'reports'),
    _Section('التقييمات', Icons.star_rounded, 'reviews'),
    _Section('المدن', Icons.location_city_rounded, 'cities'),
    _Section('المناطق', Icons.map_rounded, 'areas'),
    _Section('القرى', Icons.holiday_village_rounded, 'villages'),
    _Section('مناطق التوصيل', Icons.route_rounded, 'serviceZones'),
    _Section('إعدادات التطبيق', Icons.settings_rounded, 'appSettings'),
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 850;
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة ديرب', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout_rounded), tooltip: 'تسجيل الخروج')],
      ),
      drawer: narrow ? Drawer(child: _navigation()) : null,
      body: Row(children: [
        if (!narrow) SizedBox(width: 250, child: _navigation()),
        Expanded(child: selected == 0 ? const _Dashboard() : selected == 1 ? const _EarningsDashboard() : _CollectionPanel(section: sections[selected])),
      ]),
    );
  }

  Widget _navigation() => ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: List.generate(
          sections.length,
          (index) => ListTile(
            selected: selected == index,
            leading: Icon(sections[index].icon),
            title: Text(sections[index].label),
            onTap: () {
              setState(() => selected = index);
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ),
      );
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();
  static const metrics = <(String, String, IconData)>[
    ('الطلبات', 'orders', Icons.receipt_long_rounded),
    ('تجار للمراجعة', 'merchantApplications', Icons.badge_rounded),
    ('المتاجر', 'stores', Icons.store_rounded),
    ('البلاغات', 'reports', Icons.flag_rounded),
  ];

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('نظرة عامة', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: metrics
                .map((metric) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection(metric.$2).limit(100).snapshots(),
                      builder: (_, snapshot) => Container(
                        width: 250,
                        height: 125,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          CircleAvatar(radius: 25, child: Icon(metric.$3)),
                          const SizedBox(width: 13),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(metric.$1, style: const TextStyle(fontWeight: FontWeight.w800)),
                              Text(
                                snapshot.hasError ? '—' : '${snapshot.data?.docs.length ?? 0}',
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ))
                .toList(),
          ),
        ],
      );
}

enum _RevenueRange { today, week, month }

class _EarningsDashboard extends StatefulWidget {
  const _EarningsDashboard();
  @override
  State<_EarningsDashboard> createState() => _EarningsDashboardState();
}

class _EarningsDashboardState extends State<_EarningsDashboard> {
  _RevenueRange range = _RevenueRange.today;

  DateTime get from {
    final now = DateTime.now();
    switch (range) {
      case _RevenueRange.today:
        return DateTime(now.year, now.month, now.day);
      case _RevenueRange.week:
        final day = DateTime(now.year, now.month, now.day);
        return day.subtract(Duration(days: day.weekday - 1));
      case _RevenueRange.month:
        return DateTime(now.year, now.month);
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: 'delivered').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('تعذر تحميل بيانات الأرباح'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final orders = snapshot.data!.docs.where((doc) {
            final value = doc.data()['deliveredAt'] ?? doc.data()['updatedAt'] ?? doc.data()['createdAt'];
            return value is Timestamp && !value.toDate().isBefore(from);
          }).toList();
          int sum(String piastersField, String legacyField) => orders.fold(0, (total, doc) {
                final data = doc.data();
                return total + ((data[piastersField] as num?)?.toInt() ?? (((data[legacyField] as num?) ?? 0) * 100).round());
              });
          final gmv = sum('subtotalPiasters', 'subtotal');
          final customerRevenue = sum('customerTotalPiasters', 'total');
          final commission = sum('platformCommissionPiasters', 'platformCommissionAmount');
          final delivery = sum('platformDeliveryRevenuePiasters', 'platformDeliveryRevenue');
          final merchantNet = sum('merchantNetPiasters', 'merchantNetAmount');
          final riderPayable = sum('riderPayoutPiasters', 'riderFee');
          final platformTotal = commission + delivery;
          return ListView(padding: const EdgeInsets.all(24), children: [
            const Text('أرباحي', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const Text('إيرادات المنصة من الطلبات التي تم تسليمها فقط', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            SegmentedButton<_RevenueRange>(
              segments: const [
                ButtonSegment(value: _RevenueRange.today, label: Text('اليوم')),
                ButtonSegment(value: _RevenueRange.week, label: Text('هذا الأسبوع')),
                ButtonSegment(value: _RevenueRange.month, label: Text('هذا الشهر')),
              ],
              selected: {range},
              onSelectionChanged: (value) => setState(() => range = value.first),
            ),
            const SizedBox(height: 20),
            Wrap(spacing: 12, runSpacing: 12, children: [
              _RevenueCard('إجمالي دخل المنصة', platformTotal, Icons.trending_up_rounded, const Color(0xFF0D6B4E), featured: true),
              _RevenueCard('GMV مبيعات التجار', gmv, Icons.storefront_rounded, const Color(0xFF2867B2)),
              _RevenueCard('إجمالي دفع العملاء', customerRevenue, Icons.receipt_long_rounded, const Color(0xFF6A4C93)),
              _RevenueCard('عمولات الطلبات', commission, Icons.percent_rounded, const Color(0xFF9A5A00)),
              _RevenueCard('هامش التوصيل', delivery, Icons.delivery_dining_rounded, const Color(0xFF0D6B4E)),
              _RevenueCard('صافي مستحق التجار', merchantNet, Icons.account_balance_rounded, const Color(0xFF2867B2)),
              _RevenueCard('مستحق المندوبين', riderPayable, Icons.two_wheeler_rounded, const Color(0xFFC05B38)),
              _RevenueCard('طلبات مسلّمة', orders.length, Icons.check_circle_rounded, const Color(0xFF0D6B4E), currency: false),
            ]),
          ]);
        },
      );
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard(this.label, this.value, this.icon, this.color, {this.featured = false, this.currency = true});
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final bool featured;
  final bool currency;
  @override
  Widget build(BuildContext context) => Container(
        width: featured ? 340 : 265,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: featured ? const Color(0xFF123B30) : Colors.white, borderRadius: BorderRadius.circular(20), border: featured ? null : Border.all(color: const Color(0xFFE1E8E3))),
        child: Row(children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: featured ? Colors.white.withValues(alpha: .12) : color.withValues(alpha: .1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: featured ? Colors.white : color)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(color: featured ? Colors.white70 : Colors.black54, fontWeight: FontWeight.w700)),
            Text(currency ? '${(value / 100).toStringAsFixed(2)} ج.م' : '$value', style: TextStyle(color: featured ? Colors.white : const Color(0xFF14231D), fontSize: 23, fontWeight: FontWeight.w900)),
          ])),
        ]),
      );
}

class _CollectionPanel extends StatelessWidget {
  const _CollectionPanel({required this.section});
  final _Section section;

  Future<void> _adminAction(BuildContext context, DocumentReference<Map<String, dynamic>> reference, Map<String, dynamic> changes, String success) async {
    try {
      await reference.update(<String, dynamic>{...changes, 'updatedAt': FieldValue.serverTimestamp()});
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success)));
    } on FirebaseException catch (error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر تنفيذ الإجراء: ${error.code}')));
    }
  }

  Widget? _managementMenu(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final collection = section.collection;
    if (collection == 'communityPosts') {
      return PopupMenuButton<String>(
        onSelected: (value) => _adminAction(context, doc.reference, {'status': value}, value == 'published' ? 'تم نشر المحتوى' : 'تم إخفاء المحتوى'),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'published', child: Text('نشر')),
          PopupMenuItem(value: 'hidden', child: Text('إخفاء للمراجعة')),
          PopupMenuItem(value: 'removed', child: Text('إزالة')),
        ],
      );
    }
    if (collection == 'reports') {
      return PopupMenuButton<String>(
        onSelected: (value) => _adminAction(context, doc.reference, {'status': value, 'resolvedBy': FirebaseAuth.instance.currentUser?.uid}, value == 'resolved' ? 'تم إغلاق البلاغ' : 'تم رفض البلاغ'),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'resolved', child: Text('تم الحل')),
          PopupMenuItem(value: 'dismissed', child: Text('رفض البلاغ')),
        ],
      );
    }
    if (collection == 'categories') {
      final active = doc.data()['active'] == true;
      return IconButton(
        tooltip: active ? 'إيقاف القسم' : 'تفعيل القسم',
        onPressed: () => _adminAction(context, doc.reference, {'active': !active}, active ? 'تم إيقاف القسم' : 'تم تفعيل القسم'),
        icon: Icon(active ? Icons.visibility_rounded : Icons.visibility_off_rounded),
      );
    }
    if (const {'services', 'properties', 'jobs', 'offers', 'directoryEntries'}.contains(collection)) {
      return PopupMenuButton<String>(
        onSelected: (value) => _adminAction(context, doc.reference, {'status': value}, value == 'published' ? 'تم نشر العنصر' : 'تم إخفاء العنصر'),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'published', child: Text('نشر')),
          PopupMenuItem(value: 'hidden', child: Text('إخفاء')),
          PopupMenuItem(value: 'rejected', child: Text('رفض')),
        ],
      );
    }
    return null;
  }

  Future<void> _setStatus(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String status,
  ) async {
    try {
      final db = FirebaseFirestore.instance;
      final batch = db.batch();
      final now = FieldValue.serverTimestamp();
      final data = doc.data();
      batch.update(doc.reference, <String, dynamic>{'status': status, 'updatedAt': now});

      if (section.collection == 'merchantApplications' || section.collection == 'stores') {
        final ownerId = (data['userId'] ?? data['ownerId'] ?? doc.id).toString();
        final storeRef = db.collection('stores').doc(ownerId);
        final applicationRef = db.collection('merchantApplications').doc(ownerId);
        final store = await storeRef.get();
        final application = await applicationRef.get();
        final storeName = (data['name'] ?? data['storeName'] ?? store.data()?['name'] ?? application.data()?['name'] ?? 'متجر ديرب').toString();
        final phone = (data['phone'] ?? store.data()?['phone'] ?? application.data()?['phone'] ?? '').toString();
        final address = (data['address'] ?? store.data()?['address'] ?? '').toString();
        final categoryId = (data['categoryId'] ?? store.data()?['categoryId'] ?? application.data()?['categoryId'] ?? 'restaurants').toString();

        if (storeRef.path != doc.reference.path) {
          if (store.exists) {
            batch.update(storeRef, <String, dynamic>{'status': status, 'updatedAt': now});
          } else {
            batch.set(storeRef, <String, dynamic>{
              'ownerId': ownerId,
              'name': storeName,
              'description': '',
              'phone': phone,
              'whatsapp': phone,
              'address': address,
              'openingHours': '',
              'logo': '',
              'cover': '',
              'categoryId': categoryId.isEmpty ? 'restaurants' : categoryId,
              'cityId': data['cityId'] ?? 'dierb-nigm',
              'areaId': '',
              'villageId': '',
              'latitude': 0,
              'longitude': 0,
              'isOpen': false,
              'deliveryEnabled': true,
              'pickupEnabled': true,
              'deliveryZones': <String>[],
              'minimumOrder': 0,
              'deliveryFee': 0,
              'verified': false,
              'featured': false,
              'status': status,
              'createdAt': now,
              'updatedAt': now,
            });
          }
        }

        if (applicationRef.path != doc.reference.path) {
          if (application.exists) {
            batch.update(applicationRef, <String, dynamic>{'status': status, 'updatedAt': now});
          } else {
            batch.set(applicationRef, <String, dynamic>{
              'userId': ownerId,
              'name': storeName,
              'phone': phone,
              'cityId': data['cityId'] ?? 'dierb-nigm',
              'status': status,
              'createdAt': now,
              'updatedAt': now,
            });
          }
        }

        final sellerRef = db.collection('sellers').doc(ownerId);
        final seller = await sellerRef.get();
        if (seller.exists && sellerRef.path != doc.reference.path) {
          batch.update(sellerRef, <String, dynamic>{'status': status, 'updatedAt': now});
        }
      }

      await batch.commit();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == 'approved'
                  ? 'تمت الموافقة وتمت مزامنة المتجر'
                  : status == 'rejected'
                      ? 'تم الرفض'
                      : 'تم الإيقاف',
            ),
          ),
        );
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر تنفيذ الإجراء: ${e.code}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(section.label, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection(section.collection!).limit(100).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('تعذر تحميل ${section.label}\n${snapshot.error}', textAlign: TextAlign.center));
                }
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد بيانات في ${section.label} حتى الآن',
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data();
                    final title = data['name'] ??
                        data['sellerName'] ??
                        data['riderName'] ??
                        data['customerName'] ??
                        data['title'] ??
                        data['email'] ??
                        doc.id;
                    final status = data['status']?.toString() ?? '';
                    final secondary = data['phone'] ?? data['customerPhone'] ?? data['address'] ?? data['addressText'] ?? '';
                    return Card(
                      child: ListTile(
                        title: Text(title.toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: Text([
                          if (status.isNotEmpty) 'الحالة: $status',
                          if (secondary.toString().isNotEmpty) secondary.toString(),
                          if ((data['ownerId'] ?? data['userId'] ?? '').toString().isNotEmpty) 'المالك: ${data['ownerId'] ?? data['userId']}',
                        ].join(' • ')),
                        onTap: () => showDialog<void>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(title.toString()),
                            content: SizedBox(
                              width: 480,
                              child: SingleChildScrollView(
                                child: Text(data.entries.map((entry) => '${entry.key}: ${entry.value}').join('\n')),
                              ),
                            ),
                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))],
                          ),
                        ),
                        trailing: section.approval
                            ? Wrap(spacing: 3, children: [
                                if (status != 'approved')
                                  IconButton(
                                    tooltip: 'موافقة',
                                    onPressed: () => _setStatus(context, doc, 'approved'),
                                    icon: const Icon(Icons.check_circle_rounded, color: Colors.green),
                                  ),
                                if (status != 'rejected')
                                  IconButton(
                                    tooltip: 'رفض',
                                    onPressed: () => _setStatus(context, doc, 'rejected'),
                                    icon: const Icon(Icons.cancel_rounded, color: Colors.orange),
                                  ),
                                if (status != 'suspended')
                                  IconButton(
                                    tooltip: 'إيقاف',
                                    onPressed: () => _setStatus(context, doc, 'suspended'),
                                    icon: const Icon(Icons.block_rounded, color: Colors.red),
                                  ),
                              ])
                            : _managementMenu(context, doc),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      );
}
