import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dierb_core/dierb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/dierb_states.dart';
import 'cart_controller.dart';

class ModernCartPage extends StatelessWidget {
  const ModernCartPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('السلة', style: TextStyle(fontWeight: FontWeight.w900))),
        body: Consumer<CartController>(
          builder: (_, cart, __) {
            if (cart.isEmpty) {
              return const DierbMessage(
                icon: Icons.shopping_cart_outlined,
                title: 'السلة فاضية',
                subtitle: 'اختار منتجات من متجر معتمد وبعدين ارجع هنا لإتمام الطلب.',
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.items.length,
                    itemBuilder: (_, index) {
                      final item = cart.items[index];
                      return Card(
                        child: ListTile(
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text('${item.price.toStringAsFixed(2)} ج.م'),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(onPressed: () => cart.changeQuantity(item.productId, item.quantity - 1), icon: const Icon(Icons.remove_circle_outline)),
                            Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w900)),
                            IconButton(onPressed: () => cart.changeQuantity(item.productId, item.quantity + 1), icon: const Icon(Icons.add_circle_outline)),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Expanded(child: Text('الإجمالي: ${cart.subtotal.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
                      FilledButton(onPressed: () => _checkout(context, cart), child: const Text('إتمام الطلب')),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

Future<void> _checkout(BuildContext cartContext, CartController cart) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(cartContext).showSnackBar(const SnackBar(content: Text('سجّل الدخول من حسابي قبل إتمام الطلب')));
    return;
  }
  if ((cart.storeId ?? '').isEmpty || (cart.merchantId ?? '').isEmpty) {
    ScaffoldMessenger.of(cartContext).showSnackBar(const SnackBar(content: Text('بيانات المتجر غير مكتملة. ارجع للمتجر وأضف المنتجات تاني.')));
    return;
  }

  try {
    final storeDoc = await FirebaseFirestore.instance.collection('stores').doc(cart.storeId).get();
    final store = storeDoc.data();
    if (store == null || Store.merchantStatusFrom(store['status']) != MerchantStatus.approved) {
      if (cartContext.mounted) {
        ScaffoldMessenger.of(cartContext).showSnackBar(const SnackBar(content: Text('المتجر غير متاح للطلب حاليًا.')));
      }
      return;
    }
    if (store['isOpen'] != true) {
      if (cartContext.mounted) {
        ScaffoldMessenger.of(cartContext).showSnackBar(const SnackBar(content: Text('المتجر مغلق حاليًا.')));
      }
      return;
    }

    final profile = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final monetizationDoc = await FirebaseFirestore.instance.collection('appSettings').doc('monetization').get();
    final monetization = MonetizationSettings.fromMap(monetizationDoc.data());
    final financials = OrderFinancialSnapshot.calculate(
      subtotal: cart.subtotal,
      deliveryFee: (store['deliveryFee'] as num?)?.toDouble() ?? 0,
      settings: monetization,
      merchantCommissionBps: (store['platformCommissionBps'] as num?)?.toInt(),
      riderPayoutPiasters: (store['riderPayoutPiasters'] as num?)?.toInt(),
    );
    final data = profile.data() ?? <String, dynamic>{};
    if (!cartContext.mounted) return;
    await showModalBottomSheet<void>(
      context: cartContext,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => _CheckoutSheet(
        cartContext: cartContext,
        name: TextEditingController(text: data['name']?.toString() ?? user.displayName ?? ''),
        phone: TextEditingController(text: data['phone']?.toString() ?? ''),
        address: TextEditingController(text: data['address']?.toString() ?? ''),
        notes: TextEditingController(),
        cart: cart,
        user: user,
        ownerId: store['ownerId']?.toString() ?? cart.merchantId!,
        deliveryFee: (store['deliveryFee'] as num?)?.toDouble() ?? 0,
        cityId: store['cityId']?.toString() ?? '',
        areaId: store['areaId']?.toString() ?? '',
        villageId: store['villageId']?.toString() ?? '',
        financials: financials,
      ),
    );
  } on FirebaseException catch (error) {
    if (cartContext.mounted) {
      ScaffoldMessenger.of(cartContext).showSnackBar(SnackBar(content: Text(firestoreErrorMessage(error))));
    }
  }
}

class _CheckoutSheet extends StatefulWidget {
  const _CheckoutSheet({
    required this.cartContext,
    required this.name,
    required this.phone,
    required this.address,
    required this.notes,
    required this.cart,
    required this.user,
    required this.ownerId,
    required this.deliveryFee,
    required this.cityId,
    required this.areaId,
    required this.villageId,
    required this.financials,
  });

  final BuildContext cartContext;
  final TextEditingController name;
  final TextEditingController phone;
  final TextEditingController address;
  final TextEditingController notes;
  final CartController cart;
  final User user;
  final String ownerId;
  final double deliveryFee;
  final String cityId;
  final String areaId;
  final String villageId;
  final OrderFinancialSnapshot financials;

  @override
  State<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<_CheckoutSheet> {
  bool saving = false;
  String? error;

  Future<void> _submit() async {
    if (widget.name.text.trim().isEmpty || widget.phone.text.trim().isEmpty || widget.address.text.trim().isEmpty) {
      setState(() => error = 'أكمل بيانات التوصيل');
      return;
    }
    setState(() {
      saving = true;
      error = null;
    });
    try {
      final ref = FirebaseFirestore.instance.collection('orders').doc();
      await ref.set(<String, dynamic>{
        'orderId': ref.id,
        'orderedBy': widget.user.uid,
        'customerName': widget.name.text.trim(),
        'customerPhone': widget.phone.text.trim(),
        'addressText': widget.address.text.trim(),
        'notes': widget.notes.text.trim(),
        'paymentMethod': 'cashOnDelivery',
        'paymentStatus': 'awaitingCashCollection',
        'cashCollected': false,
        'storeId': widget.cart.storeId,
        'storeName': widget.cart.storeName,
        'sellerUID': widget.ownerId,
        'riderUID': '',
        'items': widget.cart.items.map((item) => item.toOrderMap()).toList(),
        ...widget.financials.toMap(),
        'status': OrderStatus.waitingMerchantApproval.name,
        'financialSnapshotVersion': 1,
        'cityId': widget.cityId.isEmpty ? LaunchLocationDefaults.cityId : widget.cityId,
        'areaId': widget.areaId,
        'villageId': widget.villageId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      widget.cart.clear();
      if (mounted) Navigator.pop(context);
      if (widget.cartContext.mounted) {
        ScaffoldMessenger.of(widget.cartContext).showSnackBar(const SnackBar(content: Text('تم تسجيل طلبك بنجاح. تقدر تتابعه من طلباتي.')));
        Navigator.pop(widget.cartContext);
      }
    } on FirebaseException catch (exception) {
      setState(() {
        saving = false;
        error = firestoreErrorMessage(exception);
      });
    } catch (_) {
      setState(() {
        saving = false;
        error = 'تعذر تسجيل الطلب. حاول مرة أخرى.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.viewInsetsOf(context).bottom + 18),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('بيانات التوصيل', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          TextField(controller: widget.name, decoration: const InputDecoration(labelText: 'الاسم')),
          TextField(controller: widget.phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'الهاتف')),
          TextField(controller: widget.address, decoration: const InputDecoration(labelText: 'العنوان بالتفصيل')),
          TextField(controller: widget.notes, maxLines: 2, decoration: const InputDecoration(labelText: 'ملاحظات للمتجر (اختياري)')),
          const SizedBox(height: 10),
          const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.payments_outlined), title: Text('الدفع عند الاستلام')),
          if (widget.deliveryFee > 0)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('رسوم التوصيل'),
              trailing: Text('${widget.deliveryFee.toStringAsFixed(2)} ج.م'),
            ),
          if (error != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          FilledButton(
            onPressed: saving ? null : _submit,
            child: saving
                ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : Text('تأكيد الطلب • ${(widget.cart.subtotal + widget.deliveryFee).toStringAsFixed(2)} ج.م'),
          ),
        ]),
      ),
    );
  }
}
