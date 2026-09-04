import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final Uri _uploadEndpoint = Uri.parse('http://169.58.246.131:8091/upload');
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _storeName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _description = TextEditingController();
  final _picker = ImagePicker();
  XFile? _logo;
  XFile? _banner;
  bool _saving = false;
  String? _categoryId;
  String? _categoryName;

  @override void dispose() { _name.dispose(); _storeName.dispose(); _email.dispose(); _password.dispose(); _phone.dispose(); _address.dispose(); _description.dispose(); super.dispose(); }

  Future<XFile?> _pick() => _picker.pickImage(source: ImageSource.gallery, imageQuality: 82, maxWidth: 1800);

  Future<String> _upload(XFile file) async {
    final request = http.MultipartRequest('POST', _uploadEndpoint);
    request.files.add(http.MultipartFile.fromBytes('file', await file.readAsBytes(), filename: file.name));
    final response = await request.send().timeout(const Duration(seconds: 45));
    final body = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('VPS upload HTTP ${response.statusCode}');
    final data = jsonDecode(body) as Map<String,dynamic>;
    final url = data['url']?.toString().trim() ?? '';
    if (data['success'] != true || url.isEmpty) throw Exception('Invalid VPS upload response');
    return url;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختار قسم المتجر')));
      return;
    }
    setState(() => _saving = true);
    User? user;
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text.trim(), password: _password.text.trim());
      user = credential.user!;
      await user.updateDisplayName(_name.text.trim());

      // Images are deliberately optional. The merchant account must remain
      // creatable while the external image service is unavailable.
      String logoUrl = '';
      String bannerUrl = '';
      if (_logo != null) logoUrl = await _upload(_logo!);
      if (_banner != null) bannerUrl = await _upload(_banner!);
      final now = FieldValue.serverTimestamp();
      final store = <String,dynamic>{
        'storeId': user.uid, 'ownerId': user.uid, 'name': _storeName.text.trim(), 'description': _description.text.trim(),
        'logo': logoUrl, 'cover': bannerUrl,
        'logoUrl': logoUrl, 'imageUrl': logoUrl, 'bannerUrl': bannerUrl, 'coverUrl': bannerUrl,
        'categoryId': _categoryId, 'categoryName': _categoryName, 'phone': _phone.text.trim(), 'whatsapp': _phone.text.trim(), 'address': _address.text.trim(),
        'cityId': LaunchLocationDefaults.cityId, 'areaId': '', 'villageId': '',
        'latitude': 0, 'longitude': 0, 'openingHours': '',
        'deliveryEnabled': true, 'pickupEnabled': true, 'deliveryZones': <String>[],
        'minimumOrder': 0, 'deliveryFee': 0,
        'status': 'pending', 'verified': false, 'featured': false, 'isOpen': false,
        'createdAt': now, 'updatedAt': now,
      };
      final batch = FirebaseFirestore.instance.batch();
      batch.set(FirebaseFirestore.instance.collection('users').doc(user.uid), {'uid':user.uid,'name':_name.text.trim(),'email':_email.text.trim(),'phone':_phone.text.trim(),'address':_address.text.trim(),'photoUrl':logoUrl,'status':'active','cityId':LaunchLocationDefaults.cityId,'createdAt':now,'updatedAt':now});
      batch.set(FirebaseFirestore.instance.collection('sellers').doc(user.uid), {'sellerUID':user.uid,'sellerEmail':_email.text.trim(),'sellerName':_name.text.trim(),'sellerAvtar':logoUrl,'phone':_phone.text.trim(),'address':_address.text.trim(),'status':'pending','cityId':LaunchLocationDefaults.cityId}, SetOptions(merge:true));
      batch.set(FirebaseFirestore.instance.collection('merchantApplications').doc(user.uid), {'userId':user.uid,'ownerId':user.uid,'merchantName':_name.text.trim(),'name':_name.text.trim(),'storeName':_storeName.text.trim(),'categoryId':_categoryId,'categoryName':_categoryName,'logoUrl':logoUrl,'bannerUrl':bannerUrl,'phone':_phone.text.trim(),'address':_address.text.trim(),'cityId':LaunchLocationDefaults.cityId,'status':'pending','createdAt':now,'updatedAt':now});
      batch.set(FirebaseFirestore.instance.collection('stores').doc(user.uid), store, SetOptions(merge:true));
      await batch.commit();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء طلب المتجر. انتظر موافقة الإدارة.')));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (user != null) { try { await user.delete(); } catch (_) {} }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تعذر إنشاء المتجر: $e')));
    } finally { if (mounted) setState(() => _saving = false); }
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(labelText: label, prefixIcon: Icon(icon));

  @override Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(18),
    child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const Text('افتح متجرك على ديرب', style: TextStyle(fontSize:24,fontWeight:FontWeight.w900)),
      const SizedBox(height:6), const Text('بيانات واضحة وصور قوية تخلي متجرك يظهر بشكل احترافي.'), const SizedBox(height:18),
      Row(children:[Expanded(child:_ImagePickCard(title:'لوجو المتجر', file:_logo, onTap:() async { final x=await _pick(); if(x!=null)setState(()=>_logo=x); })), const SizedBox(width:10), Expanded(child:_ImagePickCard(title:'بانر المتجر', file:_banner, onTap:() async { final x=await _pick(); if(x!=null)setState(()=>_banner=x); }))]),
      const SizedBox(height:16),
      TextFormField(controller:_name, decoration:_dec('اسم صاحب المتجر',Icons.person_outline), validator:(v)=>v==null||v.trim().isEmpty?'مطلوب':null), const SizedBox(height:10),
      TextFormField(controller:_storeName, decoration:_dec('اسم المتجر',Icons.storefront_outlined), validator:(v)=>v==null||v.trim().isEmpty?'مطلوب':null), const SizedBox(height:10),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('categories').where('active', isEqualTo: true).orderBy('sortOrder').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('تعذر تحميل الأقسام. حاول مرة أخرى.', style: TextStyle(color: Colors.red));
          }
          if (!snapshot.hasData) return const LinearProgressIndicator();
          final documents = snapshot.data!.docs;
          final categories = documents.isEmpty
              ? LaunchCategoryDefaults.values.where((item) => item.active).toList(growable: false)
              : documents.map((doc) => Category.fromMap(doc.id, doc.data())).toList(growable: false);
          return DropdownButtonFormField<String>(
            value: categories.any((category) => category.id == _categoryId) ? _categoryId : null,
            decoration: _dec('قسم المتجر', Icons.grid_view_rounded),
            items: categories.map((category) => DropdownMenuItem(value: category.id, child: Text(category.nameAr))).toList(),
            onChanged: (value) {
              Category? selected;
              for (final category in categories) {
                if (category.id == value) {
                  selected = category;
                  break;
                }
              }
              setState(() {
                _categoryId = value;
                _categoryName = selected?.nameAr;
              });
            },
            validator: (value) => value == null ? 'اختار قسم المتجر' : null,
          );
        },
      ), const SizedBox(height:10),
      TextFormField(controller:_description, maxLines:3, decoration:_dec('نبذة عن المتجر',Icons.notes_rounded)), const SizedBox(height:10),
      TextFormField(controller:_phone, keyboardType:TextInputType.phone, decoration:_dec('رقم الهاتف / واتساب',Icons.phone_outlined), validator:(v)=>v==null||v.trim().isEmpty?'مطلوب':null), const SizedBox(height:10),
      TextFormField(controller:_address, decoration:_dec('العنوان',Icons.location_on_outlined), validator:(v)=>v==null||v.trim().isEmpty?'مطلوب':null), const SizedBox(height:10),
      TextFormField(controller:_email, keyboardType:TextInputType.emailAddress, decoration:_dec('البريد الإلكتروني',Icons.email_outlined), validator:(v)=>v!=null&&v.contains('@')?null:'بريد غير صحيح'), const SizedBox(height:10),
      TextFormField(controller:_password, obscureText:true, decoration:_dec('كلمة المرور',Icons.lock_outline), validator:(v)=>(v?.length??0)>=6?null:'6 أحرف على الأقل'), const SizedBox(height:18),
      FilledButton.icon(onPressed:_saving?null:_submit, icon:_saving?const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.storefront), label:Text(_saving?'جارٍ إنشاء المتجر...':'إرسال طلب المتجر')),
      const SizedBox(height:24),
    ])),
  );
}

class _ImagePickCard extends StatelessWidget {
  const _ImagePickCard({required this.title, required this.file, required this.onTap});
  final String title; final XFile? file; final VoidCallback onTap;
  @override Widget build(BuildContext context) => InkWell(onTap:onTap, borderRadius:BorderRadius.circular(18), child:Container(height:120, decoration:BoxDecoration(color:Theme.of(context).colorScheme.surface, borderRadius:BorderRadius.circular(18), border:Border.all(color:Theme.of(context).dividerColor)), child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(file==null?Icons.add_photo_alternate_outlined:Icons.check_circle_outline,size:34,color:Theme.of(context).colorScheme.primary),const SizedBox(height:8),Text(file==null?title:'تم اختيار $title',textAlign:TextAlign.center,style:const TextStyle(fontWeight:FontWeight.w800))])));
}
