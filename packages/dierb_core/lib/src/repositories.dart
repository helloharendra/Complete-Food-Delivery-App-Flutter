import 'category.dart';
import 'community.dart';
import 'location.dart';
import 'product.dart';
import 'store.dart';

class PageRequest {
  const PageRequest({this.limit = 20, this.cursor});
  final int limit;
  final Object? cursor;
}

class PageResult<T> {
  const PageResult({required this.items, this.nextCursor, required this.hasMore});
  final List<T> items;
  final Object? nextCursor;
  final bool hasMore;
}

abstract class LocationRepository {
  Future<List<City>> activeCities();
  Future<List<Area>> areasForCity(String cityId);
  Future<List<Village>> villagesForCity(String cityId, {String? areaId});
  Future<List<ServiceZone>> zonesForLocation(LocationRef location);
}

abstract class CategoryRepository {
  Future<List<Category>> activeCategories({CategoryType? type, bool? featured});
}

abstract class StoreRepository {
  Future<PageResult<Store>> discoverApprovedStores(LocationRef location, PageRequest page, {String? categoryId});
  Future<Store?> byId(String storeId);
}

abstract class ProductRepository {
  Future<PageResult<Product>> productsForStore(String storeId, PageRequest page, {String? categoryId});
}

abstract class CommunityRepository {
  Future<PageResult<CommunityPost>> publishedPosts(LocationRef location, PageRequest page, {CommunityPostType? type});
  Future<List<CommunityReply>> replies(String postId, {int limit = 50});
  Future<String> publishPost(CommunityPost post);
  Future<String> publishReply(CommunityReply reply);
  Future<void> markHelpful(String postId, String userId);
  Future<void> reportContent({required String targetType, required String targetId, required String reason, required String reporterId});
}
