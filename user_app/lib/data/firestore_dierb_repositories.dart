import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';

class FirestoreLocationRepository implements LocationRepository {
  FirestoreLocationRepository(this.firestore);
  final FirebaseFirestore firestore;

  @override
  Future<List<City>> activeCities() async {
    final result = await firestore.collection('cities').where('active', isEqualTo: true).orderBy('sortOrder').get();
    return result.docs.map((doc) => City.fromMap(doc.id, doc.data())).toList(growable: false);
  }

  @override
  Future<List<Area>> areasForCity(String cityId) async {
    final result = await firestore.collection('areas').where('cityId', isEqualTo: cityId).where('active', isEqualTo: true).orderBy('nameAr').get();
    return result.docs.map((doc) => Area.fromMap(doc.id, doc.data())).toList(growable: false);
  }

  @override
  Future<List<Village>> villagesForCity(String cityId, {String? areaId}) async {
    Query<Map<String, dynamic>> query = firestore.collection('villages').where('cityId', isEqualTo: cityId).where('active', isEqualTo: true);
    if (areaId != null) query = query.where('areaId', isEqualTo: areaId);
    final result = await query.orderBy('nameAr').get();
    return result.docs.map((doc) => Village.fromMap(doc.id, doc.data())).toList(growable: false);
  }

  @override
  Future<List<ServiceZone>> zonesForLocation(LocationRef location) async {
    final result = await firestore.collection('serviceZones').where('cityId', isEqualTo: location.cityId).where('active', isEqualTo: true).get();
    return result.docs.map((doc) => ServiceZone.fromMap(doc.id, doc.data())).where((zone) {
      final areaMatches = location.areaId == null || zone.areaIds.isEmpty || zone.areaIds.contains(location.areaId);
      final villageMatches = location.villageId == null || zone.villageIds.isEmpty || zone.villageIds.contains(location.villageId);
      return areaMatches && villageMatches;
    }).toList(growable: false);
  }
}

class FirestoreCategoryRepository implements CategoryRepository {
  FirestoreCategoryRepository(this.firestore);
  final FirebaseFirestore firestore;

  @override
  Future<List<Category>> activeCategories({CategoryType? type, bool? featured}) async {
    Query<Map<String, dynamic>> query = firestore.collection('categories').where('active', isEqualTo: true);
    if (type != null) query = query.where('type', isEqualTo: type.name);
    if (featured != null) query = query.where('featured', isEqualTo: featured);
    final result = await query.orderBy('sortOrder').get();
    return result.docs.map((doc) => Category.fromMap(doc.id, doc.data())).toList(growable: false);
  }
}

class FirestoreStoreRepository implements StoreRepository {
  FirestoreStoreRepository(this.firestore);
  final FirebaseFirestore firestore;

  @override
  Future<Store?> byId(String storeId) async {
    final doc = await firestore.collection('stores').doc(storeId).get();
    return doc.exists ? Store.fromMap(doc.id, doc.data()!) : null;
  }

  @override
  Future<PageResult<Store>> discoverApprovedStores(LocationRef location, PageRequest page, {String? categoryId}) async {
    Query<Map<String, dynamic>> query = firestore
        .collection('stores')
        .where('status', isEqualTo: MerchantStatus.approved.name)
        .where('cityId', isEqualTo: location.cityId);
    if (location.areaId != null) query = query.where('areaId', isEqualTo: location.areaId);
    if (location.villageId != null) query = query.where('villageId', isEqualTo: location.villageId);
    if (categoryId != null) query = query.where('categoryId', isEqualTo: categoryId);
    query = query.orderBy('featured', descending: true).orderBy(FieldPath.documentId).limit(page.limit);
    if (page.cursor is DocumentSnapshot<Map<String, dynamic>>) {
      query = query.startAfterDocument(page.cursor! as DocumentSnapshot<Map<String, dynamic>>);
    }
    final result = await query.get();
    return PageResult<Store>(
      items: result.docs.map((doc) => Store.fromMap(doc.id, doc.data())).toList(growable: false),
      nextCursor: result.docs.isEmpty ? null : result.docs.last,
      hasMore: result.docs.length == page.limit,
    );
  }
}

class FirestoreProductRepository implements ProductRepository {
  FirestoreProductRepository(this.firestore);
  final FirebaseFirestore firestore;

  @override
  Future<PageResult<Product>> productsForStore(String storeId, PageRequest page, {String? categoryId}) async {
    Query<Map<String, dynamic>> query = firestore.collection('products').where('storeId', isEqualTo: storeId).where('available', isEqualTo: true);
    if (categoryId != null) query = query.where('categoryId', isEqualTo: categoryId);
    query = query.orderBy('featured', descending: true).orderBy(FieldPath.documentId).limit(page.limit);
    if (page.cursor is DocumentSnapshot<Map<String, dynamic>>) {
      query = query.startAfterDocument(page.cursor! as DocumentSnapshot<Map<String, dynamic>>);
    }
    final result = await query.get();
    return PageResult<Product>(
      items: result.docs.map((doc) => Product.fromMap(doc.id, doc.data())).toList(growable: false),
      nextCursor: result.docs.isEmpty ? null : result.docs.last,
      hasMore: result.docs.length == page.limit,
    );
  }
}

class FirestoreCommunityRepository implements CommunityRepository {
  FirestoreCommunityRepository(this.firestore);
  final FirebaseFirestore firestore;

  @override
  Future<PageResult<CommunityPost>> publishedPosts(LocationRef location, PageRequest page, {CommunityPostType? type}) async {
    Query<Map<String, dynamic>> query = firestore.collection('communityPosts')
        .where('cityId', isEqualTo: location.cityId)
        .where('status', isEqualTo: CommunityContentStatus.published.name)
        .orderBy('sponsored', descending: true)
        .orderBy('createdAt', descending: true)
        .limit(page.limit);
    if (page.cursor is DocumentSnapshot<Map<String, dynamic>>) {
      query = query.startAfterDocument(page.cursor! as DocumentSnapshot<Map<String, dynamic>>);
    }
    final result = await query.get();
    final posts = result.docs
        .map((doc) => CommunityPost.fromMap(doc.id, doc.data()))
        .where((post) =>
            (location.areaId == null || post.areaId == location.areaId) &&
            (location.villageId == null || post.villageId == location.villageId) &&
            (type == null || post.type == type))
        .toList(growable: false);
    return PageResult<CommunityPost>(
      items: posts,
      nextCursor: result.docs.isEmpty ? null : result.docs.last,
      hasMore: result.docs.length == page.limit,
    );
  }

  @override
  Future<List<CommunityReply>> replies(String postId, {int limit = 50}) async {
    final result = await firestore.collection('communityPosts').doc(postId).collection('replies')
        .where('status', isEqualTo: CommunityContentStatus.published.name).orderBy('createdAt').limit(limit).get();
    return result.docs.map((doc) => CommunityReply.fromMap(doc.id, postId, doc.data())).toList(growable: false);
  }

  @override
  Future<String> publishPost(CommunityPost post) async {
    final document = firestore.collection('communityPosts').doc();
    final data = post.toMap()..addAll(<String, dynamic>{
      'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp(),
      'sponsored': false, 'helpfulCount': 0, 'replyCount': 0,
    });
    await document.set(data);
    return document.id;
  }

  @override
  Future<String> publishReply(CommunityReply reply) async {
    final post = firestore.collection('communityPosts').doc(reply.postId);
    final document = post.collection('replies').doc();
    final batch = firestore.batch();
    batch.set(document, <String, dynamic>{
      'authorId': reply.authorId, 'authorName': reply.authorName, 'authorType': reply.authorType.name,
      'authorVerified': reply.authorVerified, 'body': reply.body, 'createdAt': FieldValue.serverTimestamp(),
      'helpfulCount': 0, 'status': CommunityContentStatus.published.name,
    });
    batch.update(post, <String, dynamic>{'replyCount': FieldValue.increment(1), 'updatedAt': FieldValue.serverTimestamp()});
    await batch.commit();
    return document.id;
  }

  @override
  Future<void> markHelpful(String postId, String userId) async {
    final post = firestore.collection('communityPosts').doc(postId);
    final reaction = post.collection('helpful').doc(userId);
    await firestore.runTransaction((transaction) async {
      final existing = await transaction.get(reaction);
      if (existing.exists) return;
      transaction.set(reaction, <String, dynamic>{'userId': userId, 'createdAt': FieldValue.serverTimestamp()});
      transaction.update(post, <String, dynamic>{'helpfulCount': FieldValue.increment(1)});
    });
  }

  @override
  Future<void> reportContent({required String targetType, required String targetId, required String reason, required String reporterId}) async {
    await firestore.collection('reports').add(<String, dynamic>{
      'targetType': targetType, 'targetId': targetId, 'reason': reason, 'reporterId': reporterId,
      'status': 'open', 'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
