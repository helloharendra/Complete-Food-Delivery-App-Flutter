import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:flutter/material.dart';

import 'local_listings_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  @override Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: const Text('الأقسام', style: TextStyle(fontWeight: FontWeight.w900))),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('categories').where('active', isEqualTo: true).orderBy('sortOrder').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const _CategoryState(icon: Icons.cloud_off_rounded, message: 'تعذر تحميل الأقسام الآن');
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final remote = snapshot.data!.docs.map((doc) => Category.fromMap(doc.id, doc.data())).toList(growable: false);
          final categories = remote.isEmpty ? LaunchCategoryDefaults.values.where((item) => item.active).toList(growable: false) : remote;
          return GridView.builder(
            padding: const EdgeInsets.all(14),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.35, crossAxisSpacing: 11, mainAxisSpacing: 11),
            itemCount: categories.length,
            itemBuilder: (_, index) {
              final category = categories[index];
              return InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LocalListingsPage(category: category))), borderRadius: BorderRadius.circular(20), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(_icon(category.type), color: const Color(0xFF166534), size: 31), const Spacer(), Text(category.nameAr, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), Text(category.nameEn, style: const TextStyle(fontSize: 11, color: Colors.grey))])));
            },
          );
        },
      ),
    ));
  }
  IconData _icon(CategoryType type) { switch (type) { case CategoryType.service: return Icons.handyman_rounded; case CategoryType.property: return Icons.apartment_rounded; case CategoryType.job: return Icons.work_rounded; case CategoryType.directory: return Icons.location_city_rounded; case CategoryType.offer: return Icons.local_offer_rounded; default: return Icons.storefront_rounded; } }
}

class _CategoryState extends StatelessWidget {
  const _CategoryState({required this.icon, required this.message});
  final IconData icon;
  final String message;
  @override Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 58, color: Colors.grey), const SizedBox(height: 10), Text(message)]));
}
