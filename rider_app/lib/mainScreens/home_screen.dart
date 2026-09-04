import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/authentication/auth_screen.dart';
import 'package:rider_app/dierb/rider_earnings_page.dart';
import 'package:rider_app/dierb/rider_orders_page.dart';
import 'package:rider_app/dierb/rider_profile_page.dart';
import 'package:rider_app/global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String get riderId => FirebaseAuth.instance.currentUser?.uid ?? sharedPreferences?.getString('uid') ?? '';

  Future<void> _setAvailable(bool available) async {
    if (riderId.isEmpty) return;
    await FirebaseFirestore.instance.collection('riders').doc(riderId).update(<String, dynamic>{
      'available': available,
      'availabilityUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  void _open(Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await sharedPreferences?.clear();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (riderId.isEmpty) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: _logout,
            child: const Text('تسجيل الدخول'),
          ),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('riders').doc(riderId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _ApprovalState(
            icon: Icons.cloud_off_rounded,
            title: 'تعذر تحميل حساب المندوب',
            subtitle: snapshot.error.toString(),
            onLogout: _logout,
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.data!.exists) {
          return _ApprovalState(
            icon: Icons.person_off_outlined,
            title: 'بيانات المندوب غير موجودة',
            subtitle: 'سجّل حساب مندوب جديد أو تواصل مع الإدارة.',
            onLogout: _logout,
          );
        }

        final data = snapshot.data!.data() ?? <String, dynamic>{};
        final status = data['status']?.toString().toLowerCase() ?? 'pending';
        final name = data['riderName']?.toString() ?? sharedPreferences?.getString('name') ?? '';

        if (status == 'pending') {
          return _ApprovalState(
            icon: Icons.hourglass_top_rounded,
            title: 'طلبك قيد المراجعة',
            subtitle: 'الإدارة هتراجع حسابك، وبعد الموافقة هتقدر تستقبل طلبات التوصيل.',
            onLogout: _logout,
          );
        }
        if (status == 'rejected' || status == 'suspended' || status == 'blocked') {
          return _ApprovalState(
            icon: Icons.block_rounded,
            title: status == 'rejected' ? 'طلب التسجيل مرفوض' : 'حساب المندوب موقوف',
            subtitle: 'تواصل مع إدارة ديرب لمراجعة حالة الحساب.',
            onLogout: _logout,
          );
        }
        if (status != 'approved') {
          return _ApprovalState(
            icon: Icons.info_outline_rounded,
            title: 'الحساب غير جاهز للعمل',
            subtitle: 'حالة الحساب الحالية: $status',
            onLogout: _logout,
          );
        }

        final available = data['available'] == true;
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ديرب للمندوبين', style: TextStyle(fontWeight: FontWeight.w900)),
                if (name.isNotEmpty) Text(name, style: const TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'تسجيل الخروج',
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: available
                        ? const [Color(0xFF14532D), Color(0xFF22A060)]
                        : const [Color(0xFF4B5563), Color(0xFF6B7280)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(
                      available ? Icons.delivery_dining_rounded : Icons.pause_circle_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            available ? 'متاح لاستقبال طلبات' : 'أنت غير متاح الآن',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17),
                          ),
                          const SizedBox(height: 4),
                          const Text('فعّل الحالة لما تكون جاهز للشغل', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Switch(value: available, onChanged: _setAvailable),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text('شغلك اليوم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.15,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _Tile(
                    Icons.assignment_rounded,
                    'طلبات متاحة',
                    'طلبات جاهزة للاستلام',
                    () {
                      if (available) {
                        _open(const RiderOrdersPage(mode: RiderOrdersMode.available));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فعّل حالة متاح أولاً')));
                      }
                    },
                  ),
                  _Tile(
                    Icons.store_mall_directory_rounded,
                    'استلمتها',
                    'طلباتك عند المتاجر',
                    () => _open(const RiderOrdersPage(mode: RiderOrdersMode.pickup)),
                  ),
                  _Tile(
                    Icons.route_rounded,
                    'في الطريق',
                    'طلبات معاك للتوصيل',
                    () => _open(const RiderOrdersPage(mode: RiderOrdersMode.delivering)),
                  ),
                  _Tile(
                    Icons.history_rounded,
                    'سجل التوصيل',
                    'طلبات تم تسليمها',
                    () => _open(const RiderOrdersPage(mode: RiderOrdersMode.history)),
                  ),
                  _Tile(
                    Icons.account_balance_wallet_rounded,
                    'الأرباح',
                    'راجع مستحقاتك',
                    () => _open(const RiderEarningsPage()),
                  ),
                  _Tile(
                    Icons.person_rounded,
                    'حسابي',
                    'بيانات الهاتف والعنوان',
                    () => _open(const RiderProfilePage()),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.title, this.subtitle, this.onTap);

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF166534), size: 31),
              const Spacer(),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      );
}

class _ApprovalState extends StatelessWidget {
  const _ApprovalState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onLogout,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ديرب للمندوبين', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [IconButton(onPressed: onLogout, icon: const Icon(Icons.logout_rounded))],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 68, color: const Color(0xFF166534)),
              const SizedBox(height: 16),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
