import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool register = false;
  bool loading = false;
  String? error;

  Future<void> _submit() async {
    if (email.text.trim().isEmpty || password.text.length < 6 || (register && name.text.trim().isEmpty)) {
      setState(() => error = 'راجع البيانات، وكلمة المرور لازم تكون 6 حروف على الأقل.');
      return;
    }
    setState(() { loading = true; error = null; });
    try {
      UserCredential credential;
      if (register) {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
        final user = credential.user!;
        await user.updateDisplayName(name.text.trim());
        final uid = user.uid;
        final db = FirebaseFirestore.instance;
        final now = FieldValue.serverTimestamp();

        final userRef = db.collection('users').doc(uid);
        if (!(await userRef.get()).exists) {
          await userRef.set({
            'uid': uid,
            'email': email.text.trim(),
            'name': name.text.trim(),
            'phone': phone.text.trim(),
            'address': '',
            'photoUrl': '',
            'status': 'active',
            'cityId': 'dierb-nigm',
            'createdAt': now,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        await db.collection('merchantApplications').doc(uid).set({
          'userId': uid,
          'email': email.text.trim(),
          'name': name.text.trim(),
          'phone': phone.text.trim(),
          'cityId': 'dierb-nigm',
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Create the merchant's store immediately in pending state. This lets
        // the admin approval synchronize the application and store in one action.
        await db.collection('stores').doc(uid).set({
          'ownerId': uid,
          'name': name.text.trim(),
          'description': '',
          'phone': phone.text.trim(),
          'whatsapp': phone.text.trim(),
          'address': '',
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
      } else {
        credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
      }
      final user = credential.user!;
      await sharedPreferences?.setString('uid', user.uid);
      await sharedPreferences?.setString('email', user.email ?? '');
      await sharedPreferences?.setString('name', user.displayName ?? name.text.trim());
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() { loading = false; error = _authError(e.code); });
    } on FirebaseException catch (e) {
      if (mounted) setState(() { loading = false; error = 'تعذر تجهيز حساب التاجر (${e.code}).'; });
    } catch (_) {
      if (mounted) setState(() { loading = false; error = 'حصل خطأ غير متوقع. حاول مرة أخرى.'; });
    }
  }

  String _authError(String code) {
    if (code == 'invalid-credential' || code == 'wrong-password' || code == 'user-not-found') return 'البريد أو كلمة المرور غير صحيحة.';
    if (code == 'email-already-in-use') return 'البريد مستخدم بالفعل، جرّب تسجيل الدخول.';
    if (code == 'network-request-failed') return 'راجع اتصال الإنترنت وحاول تاني.';
    return 'تعذر تسجيل الدخول ($code).';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const CircleAvatar(radius: 38, backgroundColor: Color(0xFFE0F2E9), child: Icon(Icons.storefront_rounded, size: 42, color: Color(0xFF166534))),
                const SizedBox(height: 16),
                const Text('ديرب للتجار', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(register ? 'أنشئ حساب تاجر وأرسل طلبك للإدارة' : 'ادخل لإدارة متجرك ومنتجاتك وطلباتك', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 26),
                if (register) ...[
                  TextField(controller: name, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'اسم التاجر / المتجر', prefixIcon: Icon(Icons.store_outlined), border: OutlineInputBorder())),
                  const SizedBox(height: 10),
                  TextField(controller: phone, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone_outlined), border: OutlineInputBorder())),
                  const SizedBox(height: 10),
                ],
                TextField(controller: email, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: password, obscureText: true, onSubmitted: (_) => _submit(), decoration: const InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder())),
                if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.error))),
                const SizedBox(height: 18),
                FilledButton(onPressed: loading ? null : _submit, child: Padding(padding: const EdgeInsets.symmetric(vertical: 13), child: loading ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(register ? 'إنشاء حساب وإرسال الطلب' : 'تسجيل الدخول'))),
                TextButton(onPressed: loading ? null : () => setState(() { register = !register; error = null; }), child: Text(register ? 'عندي حساب تاجر بالفعل' : 'إنشاء حساب تاجر جديد')),
                const SizedBox(height: 12),
                const Text('إنشاء الحساب لا يفعّل المتجر تلقائيًا؛ ظهور المتجر للعملاء يحتاج موافقة الإدارة.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black54)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
