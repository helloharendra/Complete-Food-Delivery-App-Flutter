import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});
  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  static final Uri _uploadEndpoint = Uri.parse('http://169.58.246.131:8091/upload?kind=stores');
  final _picker = ImagePicker();
  final name = TextEditingController();
  final description = TextEditingController();
  final phone = TextEditingController();
  final whatsapp = TextEditingController();
  final address = TextEditingController();
  final openingHours = TextEditingController();

  bool loading = true;
  bool saving = false;
  bool uploadingLogo = false;
  bool uploadingCover = false;
  bool isOpen = false;
  String status = 'pending';
  String logoUrl = '';
  String coverUrl = '';
  String categoryId = 'general';
  String categoryName = 'عام';

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (uid.isEmpty) return;
    try {
      final snap = await FirebaseFirestore.instance.collection('stores').doc(uid).get();
      final data = snap.data() ?? <String, dynamic>{};
      name.text = data['name']?.toString() ?? '';
      description.text = data['description']?.toString() ?? '';
      phone.text = data['phone']?.toString() ?? '';
      whatsapp.text = data['whatsapp']?.toString() ?? '';
      address.text = data['address']?.toString() ?? '';
      openingHours.text = data['openingHours']?.toString() ?? '';
      isOpen = data['isOpen'] == true;
      status = data['status']?.toString() ?? 'pending';
      logoUrl = (data['logo'] ?? data['logoUrl'] ?? '').toString();
      coverUrl = (data['cover'] ?? data['coverUrl'] ?? '').toString();
      categoryId = data['categoryId']?.toString() ?? 'general';
      categoryName = data['categoryName']?.toString() ?? 'عام';
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<ImageSource?> _chooseSource() => showModalBottomSheet<ImageSource>(
        context: context,
        builder: (_) => SafeArea(
          child: Wrap(children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('اختيار من المعرض'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('التقاط بالكاميرا'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ]),
        ),
      );

  Future<String?> _pickUpload({required bool logo}) async {
    final source = await _chooseSource();
    if (source == null) return null;
    final file = await _picker.pickImage(source: source, imageQuality: 84, maxWidth: logo ? 900 : 1800);
    if (file == null) return null;
    setState(() {
      if (logo) uploadingLogo = true;
      if (!logo) uploadingCover = true;
    });
    try {
      final req = http.MultipartRequest('POST', _uploadEndpoint);
      req.fields['folder'] = 'stores';
      req.fields['type'] = logo ? 'logo' : 'cover';
      req.files.add(http.MultipartFile.fromBytes('file', await file.readAsBytes(), filename: file.name));
      final res = await req.send().timeout(const Duration(seconds: 45));
      final body = await res.stream.bytesToString();
      if (res.statusCode < 200 || res.statusCode >= 300) throw Exception('HTTP ${res.statusCode}');
      final json = jsonDecode(body) as Map<String, dynamic>;
      final returnedUrl = json['url']?.toString().trim() ?? '';
      if (json['success'] != true || returnedUrl.isEmpty) throw Exception('invalid upload response');
      final url = returnedUrl.startsWith('http') ? returnedUrl : _uploadEndpoint.resolve(returnedUrl).toString();
      if (mounted) {
        setState(() {
          if (logo) logoUrl = url;
          if (!logo) coverUrl = url;
        });
      }
      return url;
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر رفع الصورة: $e')));
      return null;
    } finally {
      if (mounted) {
        setState(() {
          if (logo) uploadingLogo = false;
          if (!logo) uploadingCover = false;
        });
      }
    }
  }

  Future<void> _save() async {
    if (uid.isEmpty || name.text.trim().isEmpty || saving || uploadingLogo || uploadingCover) return;
    setState(() => saving = true);
    final ref = FirebaseFirestore.instance.collection('stores').doc(uid);
    final exists = (await ref.get()).exists;
    final payload = <String, dynamic>{
      'name': name.text.trim(),
      'description': description.text.trim(),
      'phone': phone.text.trim(),
      'whatsapp': whatsapp.text.trim(),
      'address': address.text.trim(),
      'openingHours': openingHours.text.trim(),
      'logo': logoUrl,
      'cover': coverUrl,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'isOpen': isOpen,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    try {
      if (exists) {
        await ref.update(payload);
      } else {
        await ref.set({
          ...payload,
          'ownerId': uid,
          'cityId': 'dierb-nigm',
          'areaId': '',
          'villageId': '',
          'latitude': 0,
          'longitude': 0,
          'deliveryEnabled': true,
          'pickupEnabled': true,
          'deliveryZones': <String>[],
          'minimumOrder': 0,
          'deliveryFee': 0,
          'verified': false,
          'featured': false,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ بيانات المتجر')));
    } on FirebaseException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر الحفظ: ${e.code}')));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    name.dispose(); description.dispose(); phone.dispose(); whatsapp.dispose(); address.dispose(); openingHours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ملف المتجر', style: TextStyle(fontWeight: FontWeight.w900))),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      onTap: uploadingCover ? null : () => _pickUpload(logo: false),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        height: 190,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(color: const Color(0xFFF0F4F8), borderRadius: BorderRadius.circular(24)),
                        child: coverUrl.isEmpty
                            ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add_photo_alternate_outlined, size: 42), SizedBox(height: 8), Text('إضافة غلاف للمتجر')]))
                            : Image.network(coverUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined, size: 42))),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: -42,
                      child: InkWell(
                        onTap: uploadingLogo ? null : () => _pickUpload(logo: true),
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          width: 92,
                          height: 92,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.white, width: 4), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, 7))]),
                          child: logoUrl.isEmpty ? const Icon(Icons.add_a_photo_outlined, size: 36) : Image.network(logoUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 56),
                Card(child: ListTile(
                  leading: const Icon(Icons.verified_user_outlined),
                  title: const Text('حالة المتجر', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(status == 'approved' ? 'معتمد ويظهر للعملاء' : status == 'rejected' ? 'مرفوض - راجع الإدارة' : status == 'suspended' ? 'موقوف' : 'قيد مراجعة الإدارة'),
                )),
                const SizedBox(height: 14),
                TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم المتجر')),
                const SizedBox(height: 10),
                TextField(controller: description, maxLines: 3, decoration: const InputDecoration(labelText: 'نبذة عن المتجر')),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('categories').where('active', isEqualTo: true).snapshots(),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs ?? const <QueryDocumentSnapshot<Map<String, dynamic>>>[];
                    final categories = docs.isEmpty
                        ? LaunchCategoryDefaults.values.where((item) => item.active).toList(growable: false)
                        : docs.map((doc) => Category.fromMap(doc.id, doc.data())).toList(growable: false);
                    final items = categories.map((item) => DropdownMenuItem(value: item.id, child: Text(item.nameAr))).toList();
                    final validValue = categories.any((item) => item.id == categoryId) ? categoryId : null;
                    return DropdownButtonFormField<String>(
                      value: validValue,
                      decoration: const InputDecoration(labelText: 'قسم المتجر'),
                      items: items,
                      onChanged: (value) {
                        if (value == null) return;
                        final selected = categories.where((item) => item.id == value).toList();
                        setState(() {
                          categoryId = value;
                          categoryName = selected.isEmpty ? value : selected.first.nameAr;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'الهاتف'))),
                  const SizedBox(width: 10),
                  Expanded(child: TextField(controller: whatsapp, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'واتساب'))),
                ]),
                const SizedBox(height: 10),
                TextField(controller: address, decoration: const InputDecoration(labelText: 'العنوان')),
                const SizedBox(height: 10),
                TextField(controller: openingHours, decoration: const InputDecoration(labelText: 'ساعات العمل', hintText: 'مثال: 9 ص - 11 م')),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: isOpen,
                  onChanged: status == 'approved' ? (value) => setState(() => isOpen = value) : null,
                  title: const Text('المتجر مفتوح الآن', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(status == 'approved' ? 'العملاء هيشوفوا حالة المتجر مباشرة' : 'يتاح بعد موافقة الإدارة'),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: saving || uploadingLogo || uploadingCover ? null : _save,
                  icon: saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_outlined),
                  label: Text(saving ? 'جاري الحفظ...' : 'حفظ ملف المتجر'),
                ),
              ],
            ),
    );
  }
}
