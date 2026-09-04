// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/home_screen.dart';
import 'package:seller_app/model/menus.dart';

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;
  const ItemsUploadScreen({super.key, this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  static const String _uploadEndpoint = 'http://169.58.246.131:8091/upload';

  final ImagePicker _picker = ImagePicker();
  final TextEditingController shortInfoController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  XFile? imageXFile;
  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 88,
    );
    if (picked != null && mounted) {
      setState(() => imageXFile = picked);
    }
  }

  void _showImagePicker() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('اختيار صورة من المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('التقاط صورة بالكاميرا'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _uploadImageToVps(File imageFile) async {
    final request = http.MultipartRequest('POST', Uri.parse(_uploadEndpoint));
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: '$uniqueIdName.jpg',
      ),
    );

    final streamed = await request.send().timeout(const Duration(seconds: 45));
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('VPS upload failed (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map || decoded['success'] != true || decoded['url'] == null) {
      throw Exception('Invalid VPS upload response');
    }

    return decoded['url'].toString();
  }

  Future<void> validateUploadForm() async {
    if (uploading) return;

    if (imageXFile == null) {
      _showMessage('اختار صورة المنتج الأول');
      return;
    }
    if (titleController.text.trim().isEmpty ||
        shortInfoController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      _showMessage('كمّل بيانات المنتج المطلوبة');
      return;
    }

    final price = num.tryParse(priceController.text.trim());
    if (price == null || price <= 0) {
      _showMessage('اكتب سعر صحيح');
      return;
    }

    final uid = sharedPreferences?.getString('uid');
    if (uid == null || uid.isEmpty) {
      _showMessage('سجّل الدخول مرة أخرى');
      return;
    }
    if (widget.model?.menuId == null || widget.model!.menuId!.isEmpty) {
      _showMessage('اختار قسم المنتج مرة أخرى');
      return;
    }

    setState(() => uploading = true);

    try {
      final downloadUrl = await _uploadImageToVps(File(imageXFile!.path));
      await _saveInfo(downloadUrl, price);
      if (!mounted) return;
      _clearForm();
      _showMessage('تم إضافة المنتج ورفع الصورة على السيرفر');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        _showMessage('فشل رفع المنتج: $e');
      }
    } finally {
      if (mounted) setState(() => uploading = false);
    }
  }

  Future<void> _saveInfo(String downloadUrl, num price) async {
    final uid = sharedPreferences!.getString('uid')!;
    final sellerName = sharedPreferences!.getString('name') ?? '';
    final menuId = widget.model!.menuId!;

    final data = <String, dynamic>{
      'itemId': uniqueIdName,
      'menuId': menuId,
      'sellerUID': uid,
      'sellerName': sellerName,
      'shortInfo': shortInfoController.text.trim(),
      'longDescription': descriptionController.text.trim(),
      'price': price,
      'title': titleController.text.trim(),
      'publishedDate': FieldValue.serverTimestamp(),
      'status': 'available',
      'thumbnailUrl': downloadUrl,
      'imageUrl': downloadUrl,
    };

    final db = FirebaseFirestore.instance;
    final batch = db.batch();

    final sellerItem = db
        .collection('sellers')
        .doc(uid)
        .collection('menus')
        .doc(menuId)
        .collection('items')
        .doc(uniqueIdName);
    final publicItem = db.collection('items').doc(uniqueIdName);

    batch.set(sellerItem, data);
    batch.set(publicItem, data);
    await batch.commit();
  }

  void _clearForm() {
    shortInfoController.clear();
    titleController.clear();
    priceController.clear();
    descriptionController.clear();
    imageXFile = null;
    uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    shortInfoController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة منتج'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AbsorbPointer(
          absorbing: uploading,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              InkWell(
                onTap: _showImagePicker,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    image: imageXFile == null
                        ? null
                        : DecorationImage(
                            image: FileImage(File(imageXFile!.path)),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: imageXFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 54),
                            SizedBox(height: 10),
                            Text('اضغط لاختيار صورة المنتج'),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'اسم المنتج',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: shortInfoController,
                decoration: const InputDecoration(
                  labelText: 'وصف مختصر',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'تفاصيل المنتج',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'السعر بالجنيه',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: uploading ? null : validateUploadForm,
                  icon: uploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_upload_outlined),
                  label: Text(uploading ? 'جاري الرفع...' : 'رفع الصورة وإضافة المنتج'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
