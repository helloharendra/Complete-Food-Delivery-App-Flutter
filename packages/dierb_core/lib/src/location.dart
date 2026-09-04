class LocationRef {
  const LocationRef({
    required this.cityId,
    this.areaId,
    this.villageId,
    this.serviceZoneId,
  });

  final String cityId;
  final String? areaId;
  final String? villageId;
  final String? serviceZoneId;

  factory LocationRef.fromMap(Map<String, dynamic> map) => LocationRef(
        cityId: map['cityId']?.toString() ?? '',
        areaId: map['areaId']?.toString(),
        villageId: map['villageId']?.toString(),
        serviceZoneId: map['serviceZoneId']?.toString(),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'cityId': cityId,
        if (areaId != null) 'areaId': areaId,
        if (villageId != null) 'villageId': villageId,
        if (serviceZoneId != null) 'serviceZoneId': serviceZoneId,
      };
}

class City {
  const City({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.governorateCode,
    this.active = true,
    this.sortOrder = 0,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String governorateCode;
  final bool active;
  final int sortOrder;

  factory City.fromMap(String id, Map<String, dynamic> map) => City(
        id: id,
        nameAr: map['nameAr']?.toString() ?? '',
        nameEn: map['nameEn']?.toString() ?? '',
        governorateCode: map['governorateCode']?.toString() ?? '',
        active: map['active'] != false,
        sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'nameAr': nameAr,
        'nameEn': nameEn,
        'governorateCode': governorateCode,
        'active': active,
        'sortOrder': sortOrder,
      };
}

class Area {
  const Area({required this.id, required this.cityId, required this.nameAr, required this.nameEn, this.active = true});
  final String id;
  final String cityId;
  final String nameAr;
  final String nameEn;
  final bool active;

  factory Area.fromMap(String id, Map<String, dynamic> map) => Area(
        id: id,
        cityId: map['cityId']?.toString() ?? '',
        nameAr: map['nameAr']?.toString() ?? '',
        nameEn: map['nameEn']?.toString() ?? '',
        active: map['active'] != false,
      );
  Map<String, dynamic> toMap() => <String, dynamic>{'cityId': cityId, 'nameAr': nameAr, 'nameEn': nameEn, 'active': active};
}

class Village {
  const Village({required this.id, required this.cityId, required this.nameAr, required this.nameEn, this.areaId, this.active = true});
  final String id;
  final String cityId;
  final String? areaId;
  final String nameAr;
  final String nameEn;
  final bool active;

  factory Village.fromMap(String id, Map<String, dynamic> map) => Village(
        id: id,
        cityId: map['cityId']?.toString() ?? '',
        areaId: map['areaId']?.toString(),
        nameAr: map['nameAr']?.toString() ?? '',
        nameEn: map['nameEn']?.toString() ?? '',
        active: map['active'] != false,
      );
  Map<String, dynamic> toMap() => <String, dynamic>{'cityId': cityId, if (areaId != null) 'areaId': areaId, 'nameAr': nameAr, 'nameEn': nameEn, 'active': active};
}

class ServiceZone {
  const ServiceZone({
    required this.id,
    required this.nameAr,
    required this.cityId,
    this.areaIds = const <String>[],
    this.villageIds = const <String>[],
    this.active = true,
    this.baseDeliveryFee = 0,
  });
  final String id;
  final String nameAr;
  final String cityId;
  final List<String> areaIds;
  final List<String> villageIds;
  final bool active;
  final double baseDeliveryFee;

  factory ServiceZone.fromMap(String id, Map<String, dynamic> map) => ServiceZone(
        id: id,
        nameAr: map['nameAr']?.toString() ?? '',
        cityId: map['cityId']?.toString() ?? '',
        areaIds: List<String>.from(map['areaIds'] as List? ?? const <String>[]),
        villageIds: List<String>.from(map['villageIds'] as List? ?? const <String>[]),
        active: map['active'] != false,
        baseDeliveryFee: (map['baseDeliveryFee'] as num?)?.toDouble() ?? 0,
      );
  Map<String, dynamic> toMap() => <String, dynamic>{
        'nameAr': nameAr, 'cityId': cityId, 'areaIds': areaIds, 'villageIds': villageIds,
        'active': active, 'baseDeliveryFee': baseDeliveryFee,
      };
}

abstract class LaunchLocationDefaults {
  static const String cityId = 'dierb-nigm';
  static const City city = City(
    id: cityId,
    nameAr: 'ديرب نجم',
    nameEn: 'Dierb Nigm',
    governorateCode: 'EG-SHR',
  );
}
