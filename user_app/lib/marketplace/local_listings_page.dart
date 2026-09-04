import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../commerce/store_details_page.dart';

class LocalListingsPage extends StatelessWidget {
  const LocalListingsPage({super.key, required this.category}); final Category category;
  String get collection { switch (category.type) { case CategoryType.service: return 'services'; case CategoryType.property: return 'properties'; case CategoryType.job: return 'jobs'; case CategoryType.directory: return 'directoryEntries'; case CategoryType.offer: return 'offers'; default: return 'stores'; } }
  Query<Map<String, dynamic>> get query {
    Query<Map<String, dynamic>> value = FirebaseFirestore.instance.collection(collection)
        .where('status', isEqualTo: category.type == CategoryType.store ? 'approved' : 'published')
        .where('cityId', isEqualTo: LaunchLocationDefaults.cityId);
    if (category.type == CategoryType.store) value = value.where('categoryId', isEqualTo: category.id);
    return value.limit(50);
  }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(category.nameAr)), body: Firebase.apps.isEmpty ? const _Empty() : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: query.snapshots(), builder: (_, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
    if (snapshot.hasError) return const _Empty(message: 'تعذر تحميل البيانات الآن. حاول مرة أخرى.');
    final docs = snapshot.data?.docs ?? const <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    if (docs.isEmpty) return const _Empty();
    return ListView.separated(padding: const EdgeInsets.all(14), itemCount: docs.length, separatorBuilder: (_, __) => const SizedBox(height: 9), itemBuilder: (_, index) { final data = docs[index].data(); final title = data['name'] ?? data['title'] ?? data['employer'] ?? ''; final phone = (data['phone'] ?? data['contact'] ?? '').toString(); return Card(child: ListTile(onTap: category.type == CategoryType.store ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreDetailsPage(storeId: docs[index].id, store: data))) : () => _showListing(context, title.toString(), data), leading: CircleAvatar(backgroundImage: (data['logo'] ?? '').toString().isEmpty ? null : NetworkImage(data['logo'].toString()), child: (data['logo'] ?? '').toString().isEmpty ? Icon(_iconForType(category.type)) : null), title: Text(title.toString(), style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(data['description']?.toString() ?? ''), trailing: category.type == CategoryType.store ? const Icon(Icons.chevron_left_rounded) : phone.isEmpty ? const Icon(Icons.chevron_left_rounded) : IconButton(onPressed: () => launchUrl(Uri.parse('tel:$phone')), icon: const Icon(Icons.phone_rounded)))); });
  }));

  IconData _iconForType(CategoryType type) { switch (type) { case CategoryType.service: return Icons.handyman_rounded; case CategoryType.property: return Icons.apartment_rounded; case CategoryType.job: return Icons.work_rounded; case CategoryType.offer: return Icons.local_offer_rounded; case CategoryType.directory: return Icons.location_city_rounded; default: return Icons.storefront_rounded; } }

  void _showListing(BuildContext context, String title, Map<String, dynamic> data) {
    final contact = (data['phone'] ?? data['contact'] ?? '').toString();
    showModalBottomSheet<void>(context: context, isScrollControlled: true, useSafeArea: true, builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        if ((data['employer'] ?? '').toString().isNotEmpty) Text(data['employer'].toString(), style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Text((data['description'] ?? 'لا يوجد وصف إضافي').toString(), style: const TextStyle(height: 1.55)),
        if ((data['price'] ?? data['salary']) != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text('${data['price'] ?? data['salary']} ج.م', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
        if ((data['address'] ?? '').toString().isNotEmpty) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.location_on_outlined), title: Text(data['address'].toString())),
        if (contact.isNotEmpty) FilledButton.icon(onPressed: () => launchUrl(Uri.parse('tel:$contact')), icon: const Icon(Icons.phone_rounded), label: const Text('اتصال')),
      ]),
    ));
  }
}
class _Empty extends StatelessWidget { const _Empty({this.message = 'لا توجد نتائج في منطقتك حاليًا'}); final String message; @override Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.search_off_rounded, size: 56, color: Colors.grey), const SizedBox(height: 10), Text(message) ])); }
