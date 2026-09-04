enum CommunityPostType { question, productRequest, serviceRequest, localInquiry, recommendation, propertyRequest, jobRequest }
enum CommunityAuthorType { user, merchant, serviceProvider, admin }
enum CommunityContentStatus { published, pendingReview, hidden, removed }

DateTime _dateFromValue(Object? value) {
  if (value is DateTime) return value;
  try {
    final dynamic candidate = value;
    final converted = candidate?.toDate();
    if (converted is DateTime) return converted;
  } catch (_) {}
  return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
}

T _enumValue<T extends Enum>(List<T> values, Object? value, T fallback) =>
    values.firstWhere((item) => item.name == value?.toString(), orElse: () => fallback);

class CommunityPost {
  const CommunityPost({
    required this.id, required this.authorId, required this.authorName, required this.authorType,
    required this.title, required this.body, required this.type, required this.cityId,
    required this.createdAt, required this.updatedAt, this.areaId, this.villageId, this.categoryId,
    this.replyCount = 0, this.helpfulCount = 0, this.status = CommunityContentStatus.published,
    this.sponsored = false, this.images = const <String>[], this.authorVerified = false,
  });
  final String id;
  final String authorId;
  final String authorName;
  final CommunityAuthorType authorType;
  final bool authorVerified;
  final String title;
  final String body;
  final CommunityPostType type;
  final String? categoryId;
  final String cityId;
  final String? areaId;
  final String? villageId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int replyCount;
  final int helpfulCount;
  final CommunityContentStatus status;
  final bool sponsored;
  final List<String> images;

  factory CommunityPost.fromMap(String id, Map<String, dynamic> map) => CommunityPost(
        id: id, authorId: map['authorId']?.toString() ?? '', authorName: map['authorName']?.toString() ?? 'مستخدم ديرب',
        authorType: _enumValue(CommunityAuthorType.values, map['authorType'], CommunityAuthorType.user),
        authorVerified: map['authorVerified'] == true, title: map['title']?.toString() ?? '', body: map['body']?.toString() ?? '',
        type: _enumValue(CommunityPostType.values, map['type'] ?? map['category'], CommunityPostType.question),
        categoryId: map['categoryId']?.toString(), cityId: map['cityId']?.toString() ?? '', areaId: map['areaId']?.toString(),
        villageId: map['villageId']?.toString(), createdAt: _dateFromValue(map['createdAt']), updatedAt: _dateFromValue(map['updatedAt']),
        replyCount: (map['replyCount'] as num?)?.toInt() ?? 0, helpfulCount: (map['helpfulCount'] as num?)?.toInt() ?? 0,
        status: _enumValue(CommunityContentStatus.values, map['status'], CommunityContentStatus.published),
        sponsored: map['sponsored'] == true, images: List<String>.from(map['images'] as List? ?? const <String>[]),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'authorId': authorId, 'authorName': authorName, 'authorType': authorType.name, 'authorVerified': authorVerified,
        'title': title, 'body': body, 'type': type.name, if (categoryId != null) 'categoryId': categoryId,
        'cityId': cityId, if (areaId != null) 'areaId': areaId, if (villageId != null) 'villageId': villageId,
        'createdAt': createdAt, 'updatedAt': updatedAt, 'replyCount': replyCount, 'helpfulCount': helpfulCount,
        'status': status.name, 'sponsored': sponsored, 'images': images,
      };
}

class CommunityReply {
  const CommunityReply({
    required this.id, required this.postId, required this.authorId, required this.authorName,
    required this.authorType, required this.body, required this.createdAt,
    this.authorVerified = false, this.helpfulCount = 0, this.status = CommunityContentStatus.published,
  });
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final CommunityAuthorType authorType;
  final bool authorVerified;
  final String body;
  final DateTime createdAt;
  final int helpfulCount;
  final CommunityContentStatus status;

  factory CommunityReply.fromMap(String id, String postId, Map<String, dynamic> map) => CommunityReply(
        id: id, postId: postId, authorId: map['authorId']?.toString() ?? '', authorName: map['authorName']?.toString() ?? 'مستخدم ديرب',
        authorType: _enumValue(CommunityAuthorType.values, map['authorType'], CommunityAuthorType.user),
        authorVerified: map['authorVerified'] == true, body: map['body']?.toString() ?? '', createdAt: _dateFromValue(map['createdAt']),
        helpfulCount: (map['helpfulCount'] as num?)?.toInt() ?? 0,
        status: _enumValue(CommunityContentStatus.values, map['status'], CommunityContentStatus.published),
      );
}
