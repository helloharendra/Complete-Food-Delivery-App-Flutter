import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dierb/app_config.dart';
import '../widgets/dierb_states.dart';
import 'cart_controller.dart';
import 'modern_cart_page.dart';

class StoreDetailsPage extends StatelessWidget {
  const StoreDetailsPage({super.key, required this.storeId, required this.store});
  final String storeId;
  final Map<String, dynamic> store;

  bool _addToCart(BuildContext context, Store parsed, Product product) {
    final ownerId = parsed.ownerId.isNotEmpty ? parsed.ownerId : storeId;
    final added = context.read<CartController>().add(
      targetStoreId: storeId,
      targetMerchantId: ownerId,
      targetStoreName: parsed.name,
      line: CartLine(
        productId: product.id,
        name: product.name,
        price: product.effectivePrice,
        quantity: 1,
        image: product.images.isEmpty ? '' : product.images.first,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(added ? 'تمت الإضافة للسلة' : 'أكمل طلب المتجر الحالي أو امسح السلة أولًا'),
    ));
    return added;
  }

  Future<void> _showProduct(BuildContext context, Store parsed, Product product) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Center(child: Container(width: 44, height: 4, decoration: BoxDecoration(color: const Color(0xFFD9E1EA), borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 16),
            Container(
              height: 260,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: AppConfig.surfaceAlt, borderRadius: BorderRadius.circular(24)),
              child: product.images.isEmpty
                  ? const Icon(Icons.inventory_2_outlined, size: 72, color: AppConfig.brandColor)
                  : Image.network(product.images.first, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.inventory_2_outlined, size: 72, color: AppConfig.brandColor)),
            ),
            const SizedBox(height: 18),
            Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppConfig.textPrimary)),
            if (product.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(product.description, style: const TextStyle(fontSize: 15, height: 1.6, color: AppConfig.textSecondary)),
            ],
            const SizedBox(height: 14),
            Text('${product.effectivePrice.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppConfig.brandColor)),
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: !parsed.isOpen ? null : () { if (_addToCart(context, parsed, product)) Navigator.pop(sheetContext); },
                icon: const Icon(Icons.add_shopping_cart_rounded),
                label: Text(parsed.isOpen ? 'إضافة للسلة' : 'المتجر مغلق حاليًا'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parsed = Store.fromMap(storeId, store);
    final isOpen = parsed.isOpen;
    final cover = parsed.cover ?? '';
    final logo = (store['logo'] ?? store['logoUrl'] ?? '').toString();
    final category = (store['categoryName'] ?? '').toString();
    final whatsapp = (store['whatsapp'] ?? '').toString();

    return Scaffold(
      backgroundColor: AppConfig.background,
      floatingActionButton: Consumer<CartController>(
        builder: (_, cart, __) => cart.isEmpty
            ? const SizedBox.shrink()
            : FloatingActionButton.extended(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ModernCartPage())),
                icon: const Icon(Icons.shopping_bag_rounded),
                label: Text('السلة (${cart.count})'),
              ),
      ),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 255,
          pinned: true,
          backgroundColor: AppConfig.brandColor,
          foregroundColor: Colors.white,
          title: Text(parsed.name, style: const TextStyle(fontWeight: FontWeight.w900)),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              if (cover.isNotEmpty)
                Image.network(cover, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _coverFallback())
              else
                _coverFallback(),
              const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xAA0B1F3A)]))),
            ]),
          ),
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -22),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppConfig.border),
                boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 10))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 78,
                    height: 78,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(color: AppConfig.surfaceAlt, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white, width: 3)),
                    child: logo.isEmpty
                        ? const Icon(Icons.storefront_rounded, size: 38, color: AppConfig.brandColor)
                        : Image.network(logo, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.storefront_rounded, size: 38, color: AppConfig.brandColor)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(parsed.name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: AppConfig.textPrimary))),
                      if (parsed.verified) const Icon(Icons.verified_rounded, color: AppConfig.brandColor, size: 21),
                    ]),
                    const SizedBox(height: 5),
                    if (category.isNotEmpty) Text(category, style: const TextStyle(color: AppConfig.textSecondary, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _statusChip(isOpen),
                  ])),
                ]),
                if (parsed.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(parsed.description, style: const TextStyle(height: 1.6, color: AppConfig.textSecondary)),
                ],
                const SizedBox(height: 18),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  if (parsed.address.isNotEmpty) _infoChip(Icons.location_on_rounded, parsed.address),
                  if (parsed.displayHours.isNotEmpty) _infoChip(Icons.schedule_rounded, parsed.displayHours),
                  if (parsed.phone.isNotEmpty) _infoChip(Icons.call_rounded, parsed.phone),
                  if (whatsapp.isNotEmpty) _infoChip(Icons.chat_rounded, 'واتساب'),
                ]),
              ]),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(18, 0, 18, 12),
            child: Text('المنتجات', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: AppConfig.textPrimary)),
          ),
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('products').where('storeId', isEqualTo: storeId).where('available', isEqualTo: true).limit(80).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.all(18),
                child: DierbMessage(
                  icon: Icons.inventory_2_outlined,
                  title: 'المنتجات غير متاحة للعرض دلوقتي',
                  subtitle: 'بنراجع بيانات المتجر، جرّب تحديث الصفحة بعد لحظات.',
                ),
              ));
            }
            if (!snapshot.hasData) {
              return const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(30), child: Center(child: CircularProgressIndicator())));
            }
            final docs = snapshot.data!.docs.where((doc) => Product.fromMap(doc.id, doc.data()).available).toList();
            if (docs.isEmpty) {
              return const SliverToBoxAdapter(child: Padding(
                padding: EdgeInsets.all(20),
                child: DierbMessage(icon: Icons.inventory_2_outlined, title: 'مفيش منتجات متاحة حاليًا', subtitle: 'أول ما التاجر يضيف منتجات هتظهر هنا فورًا.'),
              ));
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 110),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 430, mainAxisExtent: 128, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: docs.length,
                itemBuilder: (_, index) {
                  final doc = docs[index];
                  final product = Product.fromMap(doc.id, doc.data());
                  return InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => _showProduct(context, parsed, product),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppConfig.border)),
                      child: Row(children: [
                        Container(
                          width: 102,
                          height: 102,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(color: AppConfig.surfaceAlt, borderRadius: BorderRadius.circular(17)),
                          child: product.images.isEmpty
                              ? const Icon(Icons.inventory_2_outlined, color: AppConfig.brandColor)
                              : Image.network(product.images.first, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.inventory_2_outlined, color: AppConfig.brandColor)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppConfig.textPrimary)),
                          if (product.description.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, height: 1.35, color: AppConfig.textSecondary)),
                          ],
                          const Spacer(),
                          Row(children: [
                            Expanded(child: Text('${product.effectivePrice.toStringAsFixed(2)} ج.م', style: const TextStyle(fontWeight: FontWeight.w900, color: AppConfig.brandColor))),
                            const Icon(Icons.add_circle_rounded, color: AppConfig.accentColor, size: 28),
                          ]),
                        ])),
                      ]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ]),
    );
  }

  static Widget _coverFallback() => Container(
    decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppConfig.brandColor, AppConfig.brandColor2])),
    child: const Center(child: Icon(Icons.storefront_rounded, size: 82, color: Colors.white70)),
  );

  static Widget _statusChip(bool open) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: open ? const Color(0xFFE8F5EF) : const Color(0xFFFDECEC), borderRadius: BorderRadius.circular(999)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.circle, size: 9, color: open ? AppConfig.success : AppConfig.danger),
      const SizedBox(width: 6),
      Text(open ? 'مفتوح الآن' : 'مغلق حاليًا', style: TextStyle(fontWeight: FontWeight.w800, color: open ? AppConfig.success : AppConfig.danger)),
    ]),
  );

  static Widget _infoChip(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(color: AppConfig.surfaceAlt, borderRadius: BorderRadius.circular(12)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 17, color: AppConfig.brandColor),
      const SizedBox(width: 6),
      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 220), child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppConfig.textSecondary))),
    ]),
  );
}
