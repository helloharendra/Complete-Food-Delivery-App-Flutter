class ProductOption {
  const ProductOption({required this.id, required this.nameAr, required this.nameEn, this.priceDelta = 0, this.available = true});
  final String id;
  final String nameAr;
  final String nameEn;
  final double priceDelta;
  final bool available;
  factory ProductOption.fromMap(Map<String, dynamic> map) => ProductOption(
        id: map['id']?.toString() ?? '', nameAr: map['nameAr']?.toString() ?? '', nameEn: map['nameEn']?.toString() ?? '',
        priceDelta: (map['priceDelta'] as num?)?.toDouble() ?? 0, available: map['available'] != false,
      );
  Map<String, dynamic> toMap() => <String, dynamic>{'id': id, 'nameAr': nameAr, 'nameEn': nameEn, 'priceDelta': priceDelta, 'available': available};
}

class Product {
  const Product({
    required this.id, required this.storeId, required this.categoryId, required this.name,
    this.description = '', this.images = const <String>[], this.price = 0, this.salePrice,
    this.stock, this.options = const <ProductOption>[], this.available = true, this.featured = false,
    this.deliveryEligible = true,
  });
  final String id;
  final String storeId;
  final String categoryId;
  final String name;
  final String description;
  final List<String> images;
  final double price;
  final double? salePrice;
  final int? stock;
  final List<ProductOption> options;
  final bool available;
  final bool featured;
  final bool deliveryEligible;
  double get effectivePrice => salePrice != null && salePrice! < price ? salePrice! : price;

  factory Product.fromMap(String id, Map<String, dynamic> map) => Product(
        id: id,
        storeId: map['storeId']?.toString() ?? map['sellerUID']?.toString() ?? '',
        categoryId: map['categoryId']?.toString() ?? map['menuId']?.toString() ?? '',
        name: map['name']?.toString() ?? map['title']?.toString() ?? '',
        description: map['description']?.toString() ?? map['longDescription']?.toString() ?? '',
        images: map['images'] is List ? List<String>.from(map['images'] as List) : <String>[if (map['thumbnailUrl'] != null) map['thumbnailUrl'].toString()],
        price: (map['price'] as num?)?.toDouble() ?? 0, salePrice: (map['salePrice'] as num?)?.toDouble(),
        stock: (map['stock'] as num?)?.toInt(),
        options: (map['options'] as List? ?? const <dynamic>[]).whereType<Map>().map((value) => ProductOption.fromMap(Map<String, dynamic>.from(value))).toList(),
        available: map['available'] != false && map['status'] != 'unavailable', featured: map['featured'] == true,
        deliveryEligible: map['deliveryEligible'] != false,
      );
  Map<String, dynamic> toMap() => <String, dynamic>{
        'storeId': storeId, 'categoryId': categoryId, 'name': name, 'description': description,
        'images': images, 'price': price, if (salePrice != null) 'salePrice': salePrice, if (stock != null) 'stock': stock,
        'options': options.map((value) => value.toMap()).toList(), 'available': available,
        'featured': featured, 'deliveryEligible': deliveryEligible,
      };
}
