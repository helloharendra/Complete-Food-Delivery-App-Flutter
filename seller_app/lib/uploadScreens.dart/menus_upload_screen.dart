import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenusUploadScreen extends StatelessWidget {
  const MenusUploadScreen({super.key});

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    if (uid.isEmpty) return const Scaffold(body: Center(child: Text('سجّل الدخول كتاجر أولاً')));
    return Scaffold(
      appBar: AppBar(
        title: const Text('منتجات المتجر', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [IconButton(onPressed: () => _openEditor(context), icon: const Icon(Icons.add_rounded), tooltip: 'إضافة منتج')],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _openEditor(context), icon: const Icon(Icons.add_rounded), label: const Text('إضافة منتج')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('products').where('ownerId', isEqualTo: uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('تعذر تحميل المنتجات. حاول مرة أخرى.'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs.toList();
          if (docs.isEmpty) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.inventory_2_outlined, size: 70, color: Color(0xFF166534)),
              const SizedBox(height: 12),
              const Text('لسه مفيش منتجات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text('أضف أول منتج وهيظهر للعملاء بعد اعتماد المتجر.'),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: () => _openEditor(context), icon: const Icon(Icons.add), label: const Text('إضافة أول منتج')),
            ]));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();
              final images = (data['images'] as List?)?.map((e) => e.toString()).toList() ?? const <String>[];
              final price = (data['price'] as num?)?.toDouble() ?? 0;
              final sale = (data['salePrice'] as num?)?.toDouble();
              final available = data['available'] == true;
              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: images.isEmpty ? const SizedBox(width: 56, height: 56, child: Icon(Icons.image_outlined)) : Image.network(images.first, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(width: 56, height: 56, child: Icon(Icons.broken_image_outlined))),
                  ),
                  title: Text(data['name']?.toString() ?? 'منتج', style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${sale != null && sale > 0 ? sale : price} ج.م • ${available ? 'متاح' : 'موقوف'}'),
                  onTap: () => _openEditor(context, doc: doc),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'toggle') {
                        await doc.reference.update({'available': !available, 'updatedAt': FieldValue.serverTimestamp()});
                      } else if (value == 'edit') {
                        if (context.mounted) _openEditor(context, doc: doc);
                      } else if (value == 'delete') {
                        await doc.reference.delete();
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('تعديل')),
                      PopupMenuItem(value: 'toggle', child: Text(available ? 'إيقاف المنتج' : 'تفعيل المنتج')),
                      const PopupMenuItem(value: 'delete', child: Text('حذف')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openEditor(BuildContext context, {QueryDocumentSnapshot<Map<String, dynamic>>? doc}) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _ProductEditor(existing: doc)));
  }
}

class _ProductEditor extends StatefulWidget {
  const _ProductEditor({this.existing});
  final QueryDocumentSnapshot<Map<String, dynamic>>? existing;
  @override
  State<_ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<_ProductEditor> {
  final name = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final salePrice = TextEditingController();
  final stock = TextEditingController(text: '0');
  final categoryId = TextEditingController(text: 'general');
  final imageUrl = TextEditingController();
  bool available = true;
  bool saving = false;

  XFile? pickedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool uploadingImage = false;
  String? imageUploadError;

  static final Uri _uploadEndpoint = Uri.parse('http://169.58.246.131:8091/upload');

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    final data = widget.existing?.data();
    if (data != null) {
      name.text = data['name']?.toString() ?? '';
      description.text = data['description']?.toString() ?? '';
      price.text = (data['price'] as num?)?.toString() ?? '';
      salePrice.text = (data['salePrice'] as num?)?.toString() ?? '';
      stock.text = (data['stock'] as num?)?.toString() ?? '0';
      categoryId.text = data['categoryId']?.toString() ?? 'general';
      available = data['available'] == true;
      final images = (data['images'] as List?)?.map((e) => e.toString()).toList() ?? const <String>[];
      imageUrl.text = images.isEmpty ? '' : images.first;
    }
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    price.dispose();
    salePrice.dispose();
    stock.dispose();
    categoryId.dispose();
    imageUrl.dispose();
    super.dispose();
  }

  Future<void> _chooseImageSource() async {
    if (uploadingImage) return;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('إضافة صورة المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.photo_library_outlined)),
                title: const Text('اختيار من الصور'),
                subtitle: const Text('اختار صورة محفوظة على الجهاز'),
                onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
              ),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.camera_alt_outlined)),
                title: const Text('فتح الكاميرا'),
                subtitle: const Text('صوّر المنتج وارفع الصورة مباشرة'),
                onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
    if (source != null) await _pickAndUploadImage(source);
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? selected = await _imagePicker.pickImage(
        source: source,
        imageQuality: 82,
        maxWidth: 1600,
      );
      if (selected == null) return;

      setState(() {
        pickedImage = selected;
        uploadingImage = true;
        imageUploadError = null;
      });

      final request = http.MultipartRequest('POST', _uploadEndpoint);
      request.fields['type'] = 'products';
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          await selected.readAsBytes(),
          filename: selected.name,
        ),
      );

      final response = await request.send().timeout(const Duration(seconds: 45));
      final body = await response.stream.bytesToString();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('VPS HTTP ${response.statusCode}');
      }

      final data = jsonDecode(body) as Map<String, dynamic>;
      if (data['success'] != true || data['url'] == null || data['url'].toString().trim().isEmpty) {
        throw Exception('Invalid VPS response');
      }

      final returnedUrl = data['url'].toString().trim();
      final uploadedUrl = returnedUrl.startsWith('http') ? returnedUrl : _uploadEndpoint.resolve(returnedUrl).toString();
      if (!mounted) return;
      setState(() {
        imageUrl.text = uploadedUrl;
        uploadingImage = false;
        imageUploadError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع الصورة على سيرفر ديرب')));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        uploadingImage = false;
        imageUploadError = 'تعذر رفع الصورة. تأكد أن سيرفر الصور يعمل ثم حاول مرة أخرى.';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر رفع الصورة: $e')));
    }
  }

  Future<void> _save() async {
    if (uploadingImage) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('انتظر حتى يكتمل رفع الصورة')));
      return;
    }
    final parsedPrice = double.tryParse(price.text.trim());
    if (name.text.trim().isEmpty || parsedPrice == null || parsedPrice < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اكتب اسم وسعر صحيح للمنتج')));
      return;
    }
    setState(() => saving = true);
    final ref = widget.existing?.reference ?? FirebaseFirestore.instance.collection('products').doc();
    try {
      final stores = await FirebaseFirestore.instance.collection('stores').where('ownerId', isEqualTo: uid).limit(1).get();
      if (stores.docs.isEmpty) {
        throw StateError('لا يوجد متجر مرتبط بهذا الحساب. أكمل طلب التاجر وانتظر موافقة الإدارة.');
      }
      final storeDocument = stores.docs.first;
      final store = storeDocument.data();
      if (store['status']?.toString() != 'approved') {
        throw StateError('المتجر لم تتم الموافقة عليه بعد.');
      }
      final image = imageUrl.text.trim();
      final payload = <String, dynamic>{
        'name': name.text.trim(),
        'description': description.text.trim(),
        'images': image.isEmpty ? <String>[] : <String>[image],
        'price': parsedPrice,
        'salePrice': double.tryParse(salePrice.text.trim()) ?? 0,
        'stock': int.tryParse(stock.text.trim()) ?? 0,
        'categoryId': categoryId.text.trim().isEmpty ? 'general' : categoryId.text.trim(),
        'options': <Map<String, dynamic>>[],
        'available': available,
        'deliveryEligible': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (widget.existing == null) {
        await ref.set({
          ...payload,
          'productId': ref.id,
          'ownerId': uid,
          'storeId': storeDocument.id,
          'cityId': store['cityId']?.toString() ?? '',
          'areaId': store['areaId']?.toString() ?? '',
          'villageId': store['villageId']?.toString() ?? '',
          'featured': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await ref.update(payload);
      }
      if (mounted) Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر حفظ المنتج: ${e.code}')));
    } on StateError catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر حفظ المنتج الآن. تأكد من الاتصال وحاول مرة أخرى.')));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewUrl = imageUrl.text.trim();
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'إضافة منتج' : 'تعديل المنتج', style: const TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        InkWell(
          onTap: uploadingImage ? null : _chooseImageSource,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 180,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: const Color(0xFFEFF6EE), borderRadius: BorderRadius.circular(18)),
            child: previewUrl.isEmpty
                ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.add_photo_alternate_outlined, size: 58, color: Color(0xFF166534)),
                    SizedBox(height: 8),
                    Text('اضغط لإضافة صورة'),
                  ])
                : Image.network(previewUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined, size: 54))),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: uploadingImage ? null : _chooseImageSource,
          icon: uploadingImage
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.add_a_photo_outlined),
          label: Text(uploadingImage ? 'جارٍ رفع الصورة...' : (previewUrl.isEmpty ? 'إضافة صورة' : 'تغيير الصورة')),
        ),
        if (imageUrl.text.trim().isNotEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 6),
              Text('الصورة محفوظة على سيرفر ديرب'),
            ]),
          ),
        if (imageUploadError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(children: [
              const Icon(Icons.error_outline_rounded, color: Colors.red),
              const SizedBox(width: 6),
              Expanded(child: Text(imageUploadError!, style: const TextStyle(color: Colors.red))),
              TextButton(onPressed: uploadingImage ? null : _chooseImageSource, child: const Text('إعادة المحاولة')),
            ]),
          ),
        const SizedBox(height: 14),
        TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم المنتج', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: description, maxLines: 3, decoration: const InputDecoration(labelText: 'الوصف', border: OutlineInputBorder())),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'السعر', border: OutlineInputBorder()))),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: salePrice, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'سعر العرض', border: OutlineInputBorder()))),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: TextField(controller: stock, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المخزون', border: OutlineInputBorder()))),
          const SizedBox(width: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('categories').where('active', isEqualTo: true).orderBy('sortOrder').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LinearProgressIndicator();
                final documents = snapshot.data!.docs;
                final categories = documents.isEmpty
                    ? LaunchCategoryDefaults.values.where((item) => item.active).toList(growable: false)
                    : documents.map((doc) => Category.fromMap(doc.id, doc.data())).toList(growable: false);
                final current = categories.any((category) => category.id == categoryId.text) ? categoryId.text : null;
                return DropdownButtonFormField<String>(
                  value: current,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'القسم', border: OutlineInputBorder()),
                  items: categories.map((category) => DropdownMenuItem(value: category.id, child: Text(category.nameAr, overflow: TextOverflow.ellipsis))).toList(),
                  onChanged: (value) => setState(() => categoryId.text = value ?? ''),
                );
              },
            ),
          ),
        ]),
        SwitchListTile(value: available, onChanged: (v) => setState(() => available = v), title: const Text('المنتج متاح للعملاء')),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: saving || uploadingImage ? null : _save, icon: const Icon(Icons.save_outlined), label: Text(saving ? 'جاري الحفظ...' : 'حفظ المنتج')),
      ]),
    );
  }
}
