enum ListingStatus { draft, pending, published, rejected, expired, suspended }
enum PropertyType { sale, rent, land, shop, apartment, house, warehouse }

class LocalContact {
  const LocalContact({this.phone = '', this.whatsapp = '', this.latitude, this.longitude});
  final String phone; final String whatsapp; final double? latitude; final double? longitude;
  factory LocalContact.fromMap(Map<String, dynamic> map) => LocalContact(phone: map['phone']?.toString() ?? '', whatsapp: map['whatsapp']?.toString() ?? '', latitude: (map['latitude'] as num?)?.toDouble(), longitude: (map['longitude'] as num?)?.toDouble());
  Map<String, dynamic> toMap() => <String, dynamic>{'phone': phone, 'whatsapp': whatsapp, if (latitude != null) 'latitude': latitude, if (longitude != null) 'longitude': longitude};
}

DateTime? _optionalDate(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  try { final dynamic candidate = value; final result = candidate.toDate(); if (result is DateTime) return result; } catch (_) {}
  return DateTime.tryParse(value.toString());
}

class ServiceProvider {
  const ServiceProvider({required this.id, required this.ownerId, required this.name, required this.serviceCategoryId, required this.cityId, this.areaId, this.villageId, this.description = '', this.logo, this.contact = const LocalContact(), this.rating = 0, this.reviewCount = 0, this.verified = false, this.featured = false, this.available = true, this.status = ListingStatus.pending});
  final String id, ownerId, name, serviceCategoryId, cityId, description; final String? areaId, villageId, logo; final LocalContact contact; final double rating; final int reviewCount; final bool verified, featured, available; final ListingStatus status;
  factory ServiceProvider.fromMap(String id, Map<String, dynamic> map) => ServiceProvider(id: id, ownerId: map['ownerId']?.toString() ?? '', name: map['name']?.toString() ?? '', serviceCategoryId: map['serviceCategoryId']?.toString() ?? '', cityId: map['cityId']?.toString() ?? '', areaId: map['areaId']?.toString(), villageId: map['villageId']?.toString(), description: map['description']?.toString() ?? '', logo: map['logo']?.toString(), contact: LocalContact.fromMap(map), rating: (map['rating'] as num?)?.toDouble() ?? 0, reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0, verified: map['verified'] == true, featured: map['featured'] == true, available: map['available'] != false, status: ListingStatus.values.firstWhere((value) => value.name == map['status'], orElse: () => ListingStatus.pending));
}

class PropertyListing {
  const PropertyListing({required this.id, required this.ownerId, required this.title, required this.type, required this.cityId, required this.price, this.areaId, this.villageId, this.areaSize, this.images = const <String>[], this.description = '', this.contact = const LocalContact(), this.featured = false, this.createdAt, this.expiresAt, this.status = ListingStatus.pending});
  final String id, ownerId, title, cityId, description; final PropertyType type; final String? areaId, villageId; final double price; final double? areaSize; final List<String> images; final LocalContact contact; final bool featured; final DateTime? createdAt, expiresAt; final ListingStatus status;
  factory PropertyListing.fromMap(String id, Map<String, dynamic> map) => PropertyListing(id: id, ownerId: map['ownerId']?.toString() ?? '', title: map['title']?.toString() ?? '', type: PropertyType.values.firstWhere((value) => value.name == map['type'], orElse: () => PropertyType.sale), cityId: map['cityId']?.toString() ?? '', areaId: map['areaId']?.toString(), villageId: map['villageId']?.toString(), price: (map['price'] as num?)?.toDouble() ?? 0, areaSize: (map['areaSize'] as num?)?.toDouble(), images: List<String>.from(map['images'] as List? ?? const <String>[]), description: map['description']?.toString() ?? '', contact: LocalContact.fromMap(map), featured: map['featured'] == true, createdAt: _optionalDate(map['createdAt']), expiresAt: _optionalDate(map['expiresAt']), status: ListingStatus.values.firstWhere((value) => value.name == map['status'], orElse: () => ListingStatus.pending));
}

class JobListing {
  const JobListing({required this.id, required this.ownerId, required this.title, required this.employer, required this.cityId, this.areaId, this.villageId, this.salary, this.description = '', this.contact = const LocalContact(), this.createdAt, this.expiresAt, this.featured = false, this.status = ListingStatus.pending});
  final String id, ownerId, title, employer, cityId, description; final String? areaId, villageId; final double? salary; final LocalContact contact; final DateTime? createdAt, expiresAt; final bool featured; final ListingStatus status;
  factory JobListing.fromMap(String id, Map<String, dynamic> map) => JobListing(id: id, ownerId: map['ownerId']?.toString() ?? '', title: map['title']?.toString() ?? '', employer: map['employer']?.toString() ?? '', cityId: map['cityId']?.toString() ?? '', areaId: map['areaId']?.toString(), villageId: map['villageId']?.toString(), salary: (map['salary'] as num?)?.toDouble(), description: map['description']?.toString() ?? '', contact: LocalContact.fromMap(map), createdAt: _optionalDate(map['createdAt']), expiresAt: _optionalDate(map['expiresAt']), featured: map['featured'] == true, status: ListingStatus.values.firstWhere((value) => value.name == map['status'], orElse: () => ListingStatus.pending));
}

class DirectoryEntry {
  const DirectoryEntry({required this.id, required this.name, required this.categoryId, required this.cityId, this.areaId, this.villageId, this.description = '', this.logo, this.contact = const LocalContact(), this.verified = false, this.featured = false, this.status = ListingStatus.pending});
  final String id, name, categoryId, cityId, description; final String? areaId, villageId, logo; final LocalContact contact; final bool verified, featured; final ListingStatus status;
  factory DirectoryEntry.fromMap(String id, Map<String, dynamic> map) => DirectoryEntry(id: id, name: map['name']?.toString() ?? '', categoryId: map['categoryId']?.toString() ?? '', cityId: map['cityId']?.toString() ?? '', areaId: map['areaId']?.toString(), villageId: map['villageId']?.toString(), description: map['description']?.toString() ?? '', logo: map['logo']?.toString(), contact: LocalContact.fromMap(map), verified: map['verified'] == true, featured: map['featured'] == true, status: ListingStatus.values.firstWhere((value) => value.name == map['status'], orElse: () => ListingStatus.pending));
}

class MarketplacePackageSettings {
  const MarketplacePackageSettings({this.merchantMonthly = 0, this.orderCommissionPercent = 0, this.deliveryCommissionPercent = 0, this.featuredStoreDaily = 0, this.featuredProductDaily = 0, this.sponsoredPostDaily = 0, this.propertyPackage = 0, this.jobPackage = 0, this.servicePackage = 0});
  final double merchantMonthly, orderCommissionPercent, deliveryCommissionPercent, featuredStoreDaily, featuredProductDaily, sponsoredPostDaily, propertyPackage, jobPackage, servicePackage;
  factory MarketplacePackageSettings.fromMap(Map<String, dynamic> map) => MarketplacePackageSettings(merchantMonthly: (map['merchantMonthly'] as num?)?.toDouble() ?? 0, orderCommissionPercent: (map['orderCommissionPercent'] as num?)?.toDouble() ?? 0, deliveryCommissionPercent: (map['deliveryCommissionPercent'] as num?)?.toDouble() ?? 0, featuredStoreDaily: (map['featuredStoreDaily'] as num?)?.toDouble() ?? 0, featuredProductDaily: (map['featuredProductDaily'] as num?)?.toDouble() ?? 0, sponsoredPostDaily: (map['sponsoredPostDaily'] as num?)?.toDouble() ?? 0, propertyPackage: (map['propertyPackage'] as num?)?.toDouble() ?? 0, jobPackage: (map['jobPackage'] as num?)?.toDouble() ?? 0, servicePackage: (map['servicePackage'] as num?)?.toDouble() ?? 0);
}
