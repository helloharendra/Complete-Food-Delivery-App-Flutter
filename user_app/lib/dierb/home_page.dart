import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:flutter/material.dart';
import '../community/ask_dierb_page.dart';
import '../marketplace/categories_page.dart';
import '../marketplace/local_listings_page.dart';
import '../marketplace/search_page.dart';
import 'app_config.dart';

class DierbHomePage extends StatelessWidget {
  const DierbHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppConfig.backgroundColor,
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 14),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppConfig.borderColor),
                    boxShadow: const [BoxShadow(color: Color(0x0D172033), blurRadius: 20, offset: Offset(0, 8))],
                  ),
                  child: TextField(
                    readOnly: true,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())),
                    decoration: InputDecoration(
                      hintText: 'بتدور على إيه في ديرب؟',
                      hintStyle: const TextStyle(color: AppConfig.textSecondary, fontWeight: FontWeight.w600),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppConfig.brandColor),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(7),
                        decoration: BoxDecoration(color: AppConfig.brandColorSoft, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.tune_rounded, color: AppConfig.brandColor),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _OfferBanner()),
            SliverToBoxAdapter(child: _SectionTitle(title: 'كل احتياجاتك', action: 'عرض الكل', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage())))),
            const SliverToBoxAdapter(child: _HomeCategories()),
            SliverToBoxAdapter(child: _SectionTitle(title: 'اكتشف ديرب', action: 'كل الأقسام', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage())))),
            SliverToBoxAdapter(child: _HorizontalCards(onOpen: (category) => Navigator.push(context, MaterialPageRoute(builder: (_) => LocalListingsPage(category: category))))),
            SliverToBoxAdapter(child: _SectionTitle(title: 'اسأل أهل ديرب', action: 'كل الأسئلة', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AskDierbPage())))),
            SliverToBoxAdapter(child: _CommunityCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AskDierbPage())))),
            SliverToBoxAdapter(child: _SectionTitle(title: 'المتاجر والمنتجات', action: 'عرض الكل', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage())))),
            SliverToBoxAdapter(child: _StoreCard(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage())))),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }

  static Color _categoryColor(int index) {
    const colors = <Color>[
      Color(0xFFF4EDE4), Color(0xFFEAF4F0), Color(0xFFEAF1F8), Color(0xFFF8F1E6),
      Color(0xFFF0ECF7), Color(0xFFF7ECEE), Color(0xFFEAF5F8), Color(0xFFF0F3F6),
    ];
    return colors[index % colors.length];
  }

  static IconData _categoryIcon(String icon) {
    const icons = <String, IconData>{
      'restaurant': Icons.restaurant_rounded,
      'shopping_basket': Icons.shopping_basket_rounded,
      'local_pharmacy': Icons.local_pharmacy_rounded,
      'handyman': Icons.handyman_rounded,
      'apartment': Icons.apartment_rounded,
      'work': Icons.work_rounded,
      'smartphone': Icons.smartphone_rounded,
      'location_city': Icons.location_city_rounded,
    };
    return icons[icon] ?? Icons.category_rounded;
  }
}

class _HomeCategories extends StatelessWidget {
  const _HomeCategories();
  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('categories').where('active', isEqualTo: true).orderBy('sortOrder').limit(8).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return SizedBox(
              height: 92,
              child: Center(child: snapshot.hasError ? const Text('تعذر تحميل الأقسام') : const CircularProgressIndicator()),
            );
          }
          final remote = snapshot.data!.docs.map((doc) => Category.fromMap(doc.id, doc.data())).toList(growable: false);
          final categories = remote.isEmpty ? LaunchCategoryDefaults.values.where((item) => item.active && item.featured).take(8).toList(growable: false) : remote;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisExtent: 108, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LocalListingsPage(category: category))),
                borderRadius: BorderRadius.circular(18),
                child: Column(children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: DierbHomePage._categoryColor(index),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(DierbHomePage._categoryIcon(category.icon), color: AppConfig.brandColor, size: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(category.nameAr, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppConfig.textPrimary, fontWeight: FontWeight.w800)),
                ]),
              );
            },
          );
        },
      );
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [AppConfig.brandColor, AppConfig.secondaryColor]),
              borderRadius: BorderRadius.circular(17),
              boxShadow: const [BoxShadow(color: Color(0x25123A63), blurRadius: 18, offset: Offset(0, 7))],
            ),
            child: const Center(child: Text('د', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('أهلاً بيك في ديرب', style: TextStyle(fontSize: 19, color: AppConfig.textPrimary, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Row(children: [const Icon(Icons.location_on_rounded, size: 15, color: AppConfig.accentColor), const SizedBox(width: 3), Text(LaunchLocationDefaults.city.nameAr, style: const TextStyle(color: AppConfig.textSecondary, fontWeight: FontWeight.w700))]),
          ])),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppConfig.borderColor)),
            child: const Icon(Icons.location_city_rounded, color: AppConfig.brandColor),
          ),
        ]),
      );
}

class _OfferBanner extends StatelessWidget {
  const _OfferBanner();
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFF0F2F50), Color(0xFF1D527E)]),
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [BoxShadow(color: Color(0x32123A63), blurRadius: 26, offset: Offset(0, 12))],
        ),
        child: Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ديرب كلها في إيدك', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
            SizedBox(height: 8),
            Text('محلات، طلبات، خدمات وأهل بلدك في تجربة واحدة', style: TextStyle(color: Color(0xFFDCE8F3), height: 1.45, fontWeight: FontWeight.w600)),
            SizedBox(height: 14),
            _PremiumPill(),
          ])),
          const SizedBox(width: 12),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: const Color(0x18FFFFFF), borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0x33FFFFFF))),
            child: const Icon(Icons.storefront_rounded, color: AppConfig.accentColor, size: 40),
          ),
        ]),
      );
}

class _PremiumPill extends StatelessWidget {
  const _PremiumPill();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(color: const Color(0x1AFFFFFF), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0x33FFFFFF))),
    child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.bolt_rounded, color: AppConfig.accentColor, size: 16), SizedBox(width: 5), Text('كل ديرب • أسرع وأسهل', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800))]),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action, required this.onTap});
  final String title;
  final String action;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 25, 16, 12),
        child: Row(children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 19, color: AppConfig.textPrimary, fontWeight: FontWeight.w900))),
          TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(color: AppConfig.brandColor, fontWeight: FontWeight.w800))),
        ]),
      );
}

class _HorizontalCards extends StatelessWidget {
  const _HorizontalCards({required this.onOpen});
  final ValueChanged<Category> onOpen;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 150,
        child: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), scrollDirection: Axis.horizontal, children: [
          _MiniCard(title: 'العروض المنشورة', subtitle: 'شاهد العروض المتاحة حاليًا', icon: Icons.local_offer_rounded, color: const Color(0xFFF7EFE4), onTap: () => onOpen(_categoryOf(CategoryType.offer))),
          _MiniCard(title: 'الخدمات المحلية', subtitle: 'تواصل مع مقدمي الخدمات', icon: Icons.handyman_rounded, color: const Color(0xFFEAF4F0), onTap: () => onOpen(_categoryOf(CategoryType.service))),
          _MiniCard(title: 'عقارات محلية', subtitle: 'إعلانات منشورة داخل مدينتك', icon: Icons.apartment_rounded, color: const Color(0xFFEAF1F8), onTap: () => onOpen(_categoryOf(CategoryType.property))),
          _MiniCard(title: 'وظائف محلية', subtitle: 'فرص العمل المنشورة', icon: Icons.work_rounded, color: const Color(0xFFF0ECF7), onTap: () => onOpen(_categoryOf(CategoryType.job))),
        ]),
      );

  Category _categoryOf(CategoryType type) => LaunchCategoryDefaults.values.firstWhere((item) => item.type == type);
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Container(
        width: 220,
        margin: const EdgeInsetsDirectional.only(end: 12),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white), boxShadow: const [BoxShadow(color: Color(0x0D172033), blurRadius: 14, offset: Offset(0, 6))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: AppConfig.brandColor, size: 24)),
          const Spacer(),
          Text(title, style: const TextStyle(color: AppConfig.textPrimary, fontSize: 15, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppConfig.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ));
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppConfig.borderColor), boxShadow: const [BoxShadow(color: Color(0x0B172033), blurRadius: 18, offset: Offset(0, 8))]),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [CircleAvatar(backgroundColor: AppConfig.brandColorSoft, child: Icon(Icons.forum_rounded, color: AppConfig.brandColor)), SizedBox(width: 10), Expanded(child: Text('مجتمع أهل ديرب', style: TextStyle(color: AppConfig.textPrimary, fontWeight: FontWeight.w900))), Icon(Icons.arrow_back_ios_new_rounded, color: AppConfig.brandColor, size: 17)]),
          SizedBox(height: 14),
          Text('اقرأ الأسئلة المنشورة، اطلب منتجًا أو خدمة، وشارك أهل بلدك بتجربتك.', style: TextStyle(fontSize: 15, color: AppConfig.textPrimary, height: 1.55, fontWeight: FontWeight.w700)),
        ]),
      ));
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppConfig.borderColor), boxShadow: const [BoxShadow(color: Color(0x0B172033), blurRadius: 18, offset: Offset(0, 8))]),
        child: const Row(children: [
          CircleAvatar(radius: 31, backgroundColor: AppConfig.brandColorSoft, child: Icon(Icons.store_rounded, color: AppConfig.brandColor, size: 30)),
          SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('تصفح المتاجر المعتمدة', style: TextStyle(color: AppConfig.textPrimary, fontWeight: FontWeight.w900, fontSize: 16)), SizedBox(height: 5), Text('اختر القسم وشاهد المتاجر والمنتجات الحقيقية المتاحة', style: TextStyle(color: AppConfig.textSecondary, fontWeight: FontWeight.w600))])),
          Icon(Icons.arrow_back_ios_new_rounded, color: AppConfig.brandColor, size: 18),
        ]),
      ));
}
