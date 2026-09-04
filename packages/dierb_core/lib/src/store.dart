enum MerchantStatus { pending, approved, rejected, suspended }

class OpeningHours {
  const OpeningHours({required this.day, required this.open, required this.close, this.closed = false});
  final int day;
  final String open;
  final String close;
  final bool closed;
  factory OpeningHours.fromMap(Map<String, dynamic> map) => OpeningHours(
        day: (map['day'] as num?)?.toInt() ?? 1,
        open: map['open']?.toString() ?? '09:00',
        close: map['close']?.toString() ?? '22:00',
        closed: map['closed'] == true,
      );
  Map<String, dynamic> toMap() => <String, dynamic>{'day': day, 'open': open, 'close': close, 'closed': closed};
}

class Store {
  const Store({
    required this.id, required this.ownerId, required this.name, required this.categoryId, required this.cityId,
    this.description = '', this.logo, this.cover, this.areaId, this.villageId, this.address = '',
    this.latitude, this.longitude, this.phone = '', this.whatsapp = '', this.openingHours = const <OpeningHours>[],
    this.openingHoursLabel = '',
    this.isOpen = false, this.deliveryEnabled = true, this.pickupEnabled = true,
    this.deliveryZoneIds = const <String>[], this.minimumOrder = 0, this.deliveryFee = 0,
    this.rating = 0, this.reviewCount = 0, this.verified = false, this.featured = false,
    this.status = MerchantStatus.pending,
  });
  final String id, ownerId, name, description, categoryId, cityId, address, phone, whatsapp;
  final String? logo, cover, areaId, villageId;
  final double? latitude, longitude;
  final List<OpeningHours> openingHours;
  final String openingHoursLabel;
  final bool isOpen, deliveryEnabled, pickupEnabled, verified, featured;
  final List<String> deliveryZoneIds;
  final double minimumOrder, deliveryFee, rating;
  final int reviewCount;
  final MerchantStatus status;

  bool get publiclyDiscoverable => status == MerchantStatus.approved;
  String get displayHours {
    final active = openingHours.where((hours) => !hours.closed).toList();
    if (active.isEmpty) return openingHoursLabel;
    final first = active.first;
    return '${first.open} - ${first.close}';
  }

  static MerchantStatus merchantStatusFrom(Object? value) {
    final raw = value?.toString().trim();
    if (raw == 'Approved') return MerchantStatus.approved;
    if (raw == 'Blocked') return MerchantStatus.suspended;
    return MerchantStatus.values.firstWhere(
      (status) => status.name.toLowerCase() == raw?.toLowerCase(),
      orElse: () => MerchantStatus.pending,
    );
  }

  factory Store.fromMap(String id, Map<String, dynamic> map) => Store(
        id: id, ownerId: map['ownerId']?.toString() ?? map['sellerUID']?.toString() ?? '',
        name: map['name']?.toString() ?? map['sellerName']?.toString() ?? '',
        description: map['description']?.toString() ?? '', logo: map['logo']?.toString() ?? map['sellerAvtar']?.toString(),
        cover: map['cover']?.toString(), categoryId: map['categoryId']?.toString() ?? 'restaurants',
        cityId: map['cityId']?.toString() ?? '', areaId: map['areaId']?.toString(), villageId: map['villageId']?.toString(),
        address: map['address']?.toString() ?? '', latitude: (map['latitude'] as num?)?.toDouble(),
        longitude: (map['longitude'] as num?)?.toDouble(), phone: map['phone']?.toString() ?? '',
        whatsapp: map['whatsapp']?.toString() ?? '',
        openingHours: (map['openingHours'] is List ? map['openingHours'] as List : const <dynamic>[]).whereType<Map>().map((v) => OpeningHours.fromMap(Map<String, dynamic>.from(v))).toList(),
        openingHoursLabel: map['openingHours'] is String ? map['openingHours'].toString() : '',
        isOpen: map['isOpen'] == true, deliveryEnabled: map['deliveryEnabled'] != false, pickupEnabled: map['pickupEnabled'] != false,
        deliveryZoneIds: List<String>.from(map['deliveryZones'] as List? ?? const <String>[]),
        minimumOrder: (map['minimumOrder'] as num?)?.toDouble() ?? 0, deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0,
        rating: (map['rating'] as num?)?.toDouble() ?? 0, reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
        verified: map['verified'] == true, featured: map['featured'] == true, status: merchantStatusFrom(map['status']),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'ownerId': ownerId, 'name': name, 'description': description, if (logo != null) 'logo': logo,
        if (cover != null) 'cover': cover, 'categoryId': categoryId, 'cityId': cityId,
        if (areaId != null) 'areaId': areaId, if (villageId != null) 'villageId': villageId,
        'address': address, if (latitude != null) 'latitude': latitude, if (longitude != null) 'longitude': longitude,
        'phone': phone, 'whatsapp': whatsapp,
        'openingHours': openingHours.isEmpty && openingHoursLabel.isNotEmpty
            ? openingHoursLabel
            : openingHours.map((value) => value.toMap()).toList(),
        'isOpen': isOpen, 'deliveryEnabled': deliveryEnabled, 'pickupEnabled': pickupEnabled,
        'deliveryZones': deliveryZoneIds, 'minimumOrder': minimumOrder, 'deliveryFee': deliveryFee,
        'rating': rating, 'reviewCount': reviewCount, 'verified': verified, 'featured': featured, 'status': status.name,
      };
}
