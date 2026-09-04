import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('حسابي', style: TextStyle(fontWeight: FontWeight.w900))),
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) => snapshot.data == null
                ? const _GuestAccount()
                : _SignedInAccount(user: snapshot.data!),
          ),
        ),
      );
}

class _GuestAccount extends StatelessWidget {
  const _GuestAccount();
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 34),
          const CircleAvatar(radius: 42, child: Icon(Icons.person_outline_rounded, size: 44)),
          const SizedBox(height: 18),
          const Text('أهلاً بيك في ديرب', textAlign: TextAlign.center, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('تقدر تتصفح كضيف، وسجّل الدخول للطلب والمشاركة مع أهل ديرب.', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton(onPressed: () => _showAuth(context, register: false), child: const Text('تسجيل الدخول')),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: () => _showAuth(context, register: true), child: const Text('إنشاء حساب جديد')),
        ],
      );
}

Future<void> _showAuth(BuildContext context, {required bool register}) async {
  await showModalBottomSheet<void>(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => _AuthSheet(register: register));
}

class _AuthSheet extends StatefulWidget {
  const _AuthSheet({required this.register});
  final bool register;
  @override State<_AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends State<_AuthSheet> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  late bool register;
  bool saving = false;
  String? error;

  @override void initState() { super.initState(); register = widget.register; }

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.length < 6 || (register && name.text.trim().isEmpty)) {
      setState(() => error = 'راجع البيانات وكلمة المرور لازم تكون 6 حروف على الأقل.');
      return;
    }
    setState(() { saving = true; error = null; });
    try {
      if (register) {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text);
        await credential.user!.updateDisplayName(name.text.trim());
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': email.text.trim(),
          'name': name.text.trim(),
          'phone': phone.text.trim(),
          'address': address.text.trim(),
          'photoUrl': '',
          'status': 'active',
          'cityId': 'dierb-nigm',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: password.text);
      }
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (exception) {
      setState(() { saving = false; error = _authMessage(exception.code); });
    } catch (_) {
      setState(() { saving = false; error = 'حصل خطأ أثناء حفظ الحساب. حاول تاني.'; });
    }
  }

  @override Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
        child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(register ? 'إنشاء حساب' : 'تسجيل الدخول', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          if (register) ...[
            TextField(controller: name, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'الاسم', prefixIcon: Icon(Icons.person_outline))),
            TextField(controller: phone, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone_outlined))),
            TextField(controller: address, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'العنوان', prefixIcon: Icon(Icons.location_on_outlined))),
          ],
          TextField(controller: email, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined))),
          TextField(controller: password, obscureText: true, onSubmitted: (_) => submit(), decoration: const InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock_outline))),
          if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          const SizedBox(height: 18),
          FilledButton(onPressed: saving ? null : submit, child: saving ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(register ? 'إنشاء الحساب' : 'دخول')),
          TextButton(onPressed: saving ? null : () => setState(() { register = !register; error = null; }), child: Text(register ? 'عندي حساب بالفعل' : 'إنشاء حساب جديد')),
        ])),
      );
}

String _authMessage(String code) {
  if (code == 'invalid-credential' || code == 'wrong-password' || code == 'user-not-found') return 'البريد أو كلمة المرور غير صحيحة.';
  if (code == 'email-already-in-use') return 'البريد مستخدم في حساب آخر.';
  if (code == 'network-request-failed') return 'تأكد من اتصال الإنترنت وحاول تاني.';
  return 'تعذر تسجيل الدخول الآن ($code).';
}

class _SignedInAccount extends StatelessWidget {
  const _SignedInAccount({required this.user});
  final User user;

  @override Widget build(BuildContext context) => StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() ?? <String, dynamic>{};
          final name = data['name']?.toString() ?? user.displayName ?? 'مستخدم ديرب';
          return ListView(padding: const EdgeInsets.all(16), children: [
            Card(child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
              const CircleAvatar(radius: 32, child: Icon(Icons.person_rounded, size: 34)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                Text(user.email ?? ''),
                if ((data['phone'] ?? '').toString().isNotEmpty) Text(data['phone'].toString()),
              ])),
              IconButton(onPressed: () => _editProfile(context, user, data), icon: const Icon(Icons.edit_outlined)),
            ]))),
            ListTile(leading: const Icon(Icons.location_on_outlined), title: const Text('العنوان'), subtitle: Text((data['address'] ?? 'لم يتم إضافة عنوان').toString()), onTap: () => _editProfile(context, user, data)),
            ListTile(leading: const Icon(Icons.storefront_outlined), title: const Text('انضم كتاجر'), subtitle: const Text('قدّم طلب فتح متجر على ديرب'), onTap: () => _merchantApplication(context, user, data)),
            const Divider(),
            ListTile(leading: const Icon(Icons.logout_rounded), title: const Text('تسجيل الخروج'), onTap: () => FirebaseAuth.instance.signOut()),
          ]);
        },
      );
}

Future<void> _editProfile(BuildContext context, User user, Map<String, dynamic> data) async {
  final name = TextEditingController(text: data['name']?.toString() ?? user.displayName ?? '');
  final phone = TextEditingController(text: data['phone']?.toString() ?? '');
  final address = TextEditingController(text: data['address']?.toString() ?? '');
  await showModalBottomSheet<void>(context: context, isScrollControlled: true, useSafeArea: true, builder: (sheetContext) => Padding(
    padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.viewInsetsOf(sheetContext).bottom + 20),
    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('تعديل بياناتي', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
      TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم')),
      TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'الهاتف')),
      TextField(controller: address, decoration: const InputDecoration(labelText: 'العنوان')),
      const SizedBox(height: 16),
      FilledButton(onPressed: () async {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'name': name.text.trim(), 'phone': phone.text.trim(), 'address': address.text.trim(), 'updatedAt': FieldValue.serverTimestamp()});
        await user.updateDisplayName(name.text.trim());
        if (sheetContext.mounted) Navigator.pop(sheetContext);
      }, child: const Text('حفظ')),
    ]),
  ));
}

Future<void> _merchantApplication(BuildContext context, User user, Map<String, dynamic> profile) async {
  final db = FirebaseFirestore.instance;
  final applicationRef = db.collection('merchantApplications').doc(user.uid);
  final existing = await applicationRef.get();
  if (existing.exists) {
    final status = existing.data()?['status']?.toString() ?? 'pending';
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حالة طلب التاجر: $status')));
    return;
  }

  final merchantName = (profile['name'] ?? user.displayName ?? '').toString();
  final merchantPhone = (profile['phone'] ?? '').toString();
  await applicationRef.set({
    'userId': user.uid,
    'email': user.email,
    'name': merchantName,
    'phone': merchantPhone,
    'cityId': 'dierb-nigm',
    'status': 'pending',
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  final storeRef = db.collection('stores').doc(user.uid);
  if (!(await storeRef.get()).exists) {
    await storeRef.set({
      'ownerId': user.uid,
      'name': merchantName.isEmpty ? 'متجر ديرب' : merchantName,
      'description': '',
      'phone': merchantPhone,
      'whatsapp': merchantPhone,
      'address': (profile['address'] ?? '').toString(),
      'openingHours': '',
      'logo': '',
      'cover': '',
      'categoryId': 'general',
      'cityId': 'dierb-nigm',
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
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلب التاجر للمراجعة.')));
}
