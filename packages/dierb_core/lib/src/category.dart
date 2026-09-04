enum CategoryType { store, product, service, property, job, offer, directory }

class Category {
  const Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.type,
    this.image,
    this.sortOrder = 0,
    this.active = true,
    this.featured = false,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String? image;
  final int sortOrder;
  final bool active;
  final bool featured;
  final CategoryType type;

  factory Category.fromMap(String id, Map<String, dynamic> map) => Category(
        id: id,
        nameAr: map['nameAr']?.toString() ?? map['title']?.toString() ?? '',
        nameEn: map['nameEn']?.toString() ?? '',
        icon: map['icon']?.toString() ?? 'category',
        image: map['image']?.toString(),
        sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
        active: map['active'] != false,
        featured: map['featured'] == true,
        type: CategoryType.values.firstWhere(
          (value) => value.name == map['type']?.toString(),
          orElse: () => CategoryType.store,
        ),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'nameAr': nameAr, 'nameEn': nameEn, 'icon': icon, if (image != null) 'image': image,
        'sortOrder': sortOrder, 'active': active, 'featured': featured, 'type': type.name,
      };
}

abstract class LaunchCategoryDefaults {
  static const List<Category> values = <Category>[
    Category(id: 'restaurants', nameAr: 'مطاعم', nameEn: 'Restaurants', icon: 'restaurant', type: CategoryType.store, featured: true, sortOrder: 10),
    Category(id: 'grocery', nameAr: 'سوبر ماركت وبقالة', nameEn: 'Grocery', icon: 'shopping_basket', type: CategoryType.store, featured: true, sortOrder: 20),
    Category(id: 'pharmacies', nameAr: 'صيدليات', nameEn: 'Pharmacies', icon: 'local_pharmacy', type: CategoryType.store, featured: true, sortOrder: 30),
    Category(id: 'bakery', nameAr: 'حلويات ومخبوزات', nameEn: 'Sweets & Bakery', icon: 'bakery_dining', type: CategoryType.store, sortOrder: 40),
    Category(id: 'clothing', nameAr: 'ملابس', nameEn: 'Clothing', icon: 'checkroom', type: CategoryType.store, sortOrder: 50),
    Category(id: 'shoes', nameAr: 'أحذية', nameEn: 'Shoes', icon: 'steps', type: CategoryType.store, sortOrder: 60),
    Category(id: 'mobiles', nameAr: 'موبايلات', nameEn: 'Mobile Phones', icon: 'smartphone', type: CategoryType.store, sortOrder: 70),
    Category(id: 'electronics', nameAr: 'إلكترونيات', nameEn: 'Electronics', icon: 'devices', type: CategoryType.store, sortOrder: 80),
    Category(id: 'appliances', nameAr: 'أجهزة منزلية', nameEn: 'Home Appliances', icon: 'kitchen', type: CategoryType.store, sortOrder: 90),
    Category(id: 'furniture', nameAr: 'أثاث', nameEn: 'Furniture', icon: 'chair', type: CategoryType.store, sortOrder: 100),
    Category(id: 'home-supplies', nameAr: 'مستلزمات منزل', nameEn: 'Home Supplies', icon: 'home', type: CategoryType.store, sortOrder: 110),
    Category(id: 'services', nameAr: 'خدمات وصنايعية', nameEn: 'Services', icon: 'handyman', type: CategoryType.service, featured: true, sortOrder: 120),
    Category(id: 'doctors', nameAr: 'أطباء وعيادات', nameEn: 'Doctors & Clinics', icon: 'medical_services', type: CategoryType.directory, sortOrder: 130),
    Category(id: 'properties', nameAr: 'عقارات', nameEn: 'Properties', icon: 'apartment', type: CategoryType.property, featured: true, sortOrder: 140),
    Category(id: 'jobs', nameAr: 'وظائف', nameEn: 'Jobs', icon: 'work', type: CategoryType.job, featured: true, sortOrder: 150),
    Category(id: 'cars', nameAr: 'سيارات', nameEn: 'Cars', icon: 'directions_car', type: CategoryType.store, sortOrder: 160),
    Category(id: 'spare-parts', nameAr: 'قطع غيار', nameEn: 'Spare Parts', icon: 'car_repair', type: CategoryType.store, sortOrder: 170),
    Category(id: 'education', nameAr: 'تعليم ومدرسين', nameEn: 'Education', icon: 'school', type: CategoryType.service, sortOrder: 180),
    Category(id: 'offers', nameAr: 'عروض ديرب', nameEn: 'Dierb Offers', icon: 'local_offer', type: CategoryType.offer, sortOrder: 190),
    Category(id: 'directory', nameAr: 'دليل ديرب', nameEn: 'Dierb Directory', icon: 'location_city', type: CategoryType.directory, featured: true, sortOrder: 200),
  ];
}
