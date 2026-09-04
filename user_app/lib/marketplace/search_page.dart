import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:flutter/material.dart';

import '../commerce/store_details_page.dart';
import '../widgets/dierb_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  String query = '';
  @override void dispose() { controller.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: TextField(
      controller: controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(hintText: 'ابحث عن متجر أو منتج', border: InputBorder.none),
      onChanged: (value) => setState(() => query = value.trim().toLowerCase()),
    )),
    body: query.length < 2 ? const DierbMessage(icon: Icons.search_rounded, title: 'ابحث في ديرب', subtitle: 'اكتب حرفين على الأقل من اسم المتجر أو المنتج.') : _results(),
  );

  Widget _results() => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: FirebaseFirestore.instance.collection('stores').where('status', isEqualTo: 'approved').where('cityId', isEqualTo: LaunchLocationDefaults.cityId).limit(80).snapshots(),
    builder: (context, storeSnapshot) {
      if (storeSnapshot.hasError) return DierbMessage(icon: Icons.cloud_off_rounded, title: firestoreErrorMessage(storeSnapshot.error!));
      if (!storeSnapshot.hasData) return const Center(child: CircularProgressIndicator());
      final allStores = storeSnapshot.data!.docs;
      final stores = allStores.where((doc) {
        final data = doc.data();
        return '${data['name'] ?? ''} ${data['description'] ?? ''} ${data['address'] ?? ''}'.toLowerCase().contains(query);
      }).toList();
      final approvedStoreIds = allStores.map((doc) => doc.id).toSet();
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('products').where('available', isEqualTo: true).limit(80).snapshots(),
        builder: (context, productSnapshot) {
          if (productSnapshot.hasError) return DierbMessage(icon: Icons.cloud_off_rounded, title: firestoreErrorMessage(productSnapshot.error!));
          if (!productSnapshot.hasData) return const Center(child: CircularProgressIndicator());
          final products = productSnapshot.data!.docs.where((doc) {
            final data = doc.data();
            if (!approvedStoreIds.contains(data['storeId']?.toString())) return false;
            return '${data['name'] ?? ''} ${data['description'] ?? ''}'.toLowerCase().contains(query);
          }).toList();
          if (stores.isEmpty && products.isEmpty) return const DierbMessage(icon: Icons.search_off_rounded, title: 'لا توجد نتائج مطابقة');
          return ListView(padding: const EdgeInsets.all(14), children: [
            if (stores.isNotEmpty) const _ResultTitle('المتاجر'),
            ...stores.map((doc) => _storeTile(context, doc)),
            if (products.isNotEmpty) const _ResultTitle('المنتجات'),
            ...products.map((doc) => _productTile(context, doc, allStores)),
          ]);
        },
      );
    },
  );

  Widget _storeTile(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final store = Store.fromMap(doc.id, doc.data());
    return Card(child: ListTile(
      leading: const CircleAvatar(child: Icon(Icons.storefront_rounded)),
      title: Text(store.name, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(store.isOpen ? 'مفتوح الآن' : 'مغلق حاليًا'),
      trailing: const Icon(Icons.chevron_left_rounded),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreDetailsPage(storeId: doc.id, store: doc.data()))),
    ));
  }

  Widget _productTile(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> doc, List<QueryDocumentSnapshot<Map<String, dynamic>>> stores) {
    final product = Product.fromMap(doc.id, doc.data());
    QueryDocumentSnapshot<Map<String, dynamic>>? store;
    for (final candidate in stores) { if (candidate.id == product.storeId) { store = candidate; break; } }
    final selectedStore = store;
    return Card(child: ListTile(
      leading: product.images.isEmpty ? const CircleAvatar(child: Icon(Icons.inventory_2_outlined)) : ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(product.images.first, width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(width: 48, height: 48, child: Icon(Icons.broken_image_outlined)))),
      title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text('${product.effectivePrice.toStringAsFixed(2)} ج.م'),
      trailing: const Icon(Icons.chevron_left_rounded),
      onTap: selectedStore == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreDetailsPage(storeId: selectedStore.id, store: selectedStore.data()))),
    ));
  }
}

class _ResultTitle extends StatelessWidget {
  const _ResultTitle(this.title); final String title;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(4, 14, 4, 8), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)));
}
