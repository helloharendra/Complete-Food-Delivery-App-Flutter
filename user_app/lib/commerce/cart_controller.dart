import 'package:flutter/foundation.dart';

class CartLine {
  const CartLine({required this.productId, required this.name, required this.price, required this.quantity, this.image = ''});
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String image;
  CartLine copyWith({int? quantity}) => CartLine(productId: productId, name: name, price: price, quantity: quantity ?? this.quantity, image: image);
  Map<String, dynamic> toOrderMap() => {'productId': productId, 'name': name, 'price': price, 'quantity': quantity, 'image': image};
}

class CartController extends ChangeNotifier {
  String? storeId;
  String? merchantId;
  String? storeName;
  final List<CartLine> _items = [];
  List<CartLine> get items => List.unmodifiable(_items);
  int get count => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  bool get isEmpty => _items.isEmpty;

  bool add({required String targetStoreId, required String targetMerchantId, required String targetStoreName, required CartLine line}) {
    if (storeId != null && storeId != targetStoreId) return false;
    storeId = targetStoreId; merchantId = targetMerchantId; storeName = targetStoreName;
    final index = _items.indexWhere((item) => item.productId == line.productId);
    if (index == -1) _items.add(line); else _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    notifyListeners();
    return true;
  }

  void changeQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index == -1) return;
    if (quantity <= 0) _items.removeAt(index); else _items[index] = _items[index].copyWith(quantity: quantity);
    if (_items.isEmpty) { storeId = null; merchantId = null; storeName = null; }
    notifyListeners();
  }

  void clear() { _items.clear(); storeId = null; merchantId = null; storeName = null; notifyListeners(); }
}
