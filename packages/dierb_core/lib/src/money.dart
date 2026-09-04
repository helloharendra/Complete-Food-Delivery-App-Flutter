class Money {
  const Money._(this.piasters);
  final int piasters;

  factory Money.fromEgp(num value) => Money._((value * 100).round());
  factory Money.fromPiasters(int value) => Money._(value);
  double get egp => piasters / 100;
  String get formattedEgp => egp.toStringAsFixed(2);
}

class MonetizationSettings {
  const MonetizationSettings({
    this.commissionEnabled = false,
    this.defaultCommissionBps = 0,
    this.deliveryRevenueEnabled = false,
    this.defaultRiderPayoutPiasters = 0,
  });

  final bool commissionEnabled;
  final int defaultCommissionBps;
  final bool deliveryRevenueEnabled;
  final int defaultRiderPayoutPiasters;

  factory MonetizationSettings.fromMap(Map<String, dynamic>? map) {
    final data = map ?? const <String, dynamic>{};
    return MonetizationSettings(
      commissionEnabled: data['commissionEnabled'] == true,
      defaultCommissionBps: _clampBps((data['defaultCommissionBps'] as num?)?.toInt() ?? 0),
      deliveryRevenueEnabled: data['deliveryRevenueEnabled'] == true,
      defaultRiderPayoutPiasters: ((data['defaultRiderPayoutPiasters'] as num?)?.toInt() ?? 0).clamp(0, 1000000000).toInt(),
    );
  }

  static int _clampBps(int value) => value.clamp(0, 10000).toInt();
}

class OrderFinancialSnapshot {
  const OrderFinancialSnapshot({
    required this.subtotalPiasters,
    required this.deliveryFeePiasters,
    required this.discountPiasters,
    required this.customerTotalPiasters,
    required this.platformCommissionBps,
    required this.platformCommissionPiasters,
    required this.merchantNetPiasters,
    required this.riderPayoutPiasters,
    required this.platformDeliveryRevenuePiasters,
  });

  final int subtotalPiasters;
  final int deliveryFeePiasters;
  final int discountPiasters;
  final int customerTotalPiasters;
  final int platformCommissionBps;
  final int platformCommissionPiasters;
  final int merchantNetPiasters;
  final int riderPayoutPiasters;
  final int platformDeliveryRevenuePiasters;

  factory OrderFinancialSnapshot.calculate({
    required num subtotal,
    required num deliveryFee,
    num discount = 0,
    required MonetizationSettings settings,
    int? merchantCommissionBps,
    int? riderPayoutPiasters,
  }) {
    final subtotalPiasters = Money.fromEgp(subtotal).piasters;
    final deliveryPiasters = Money.fromEgp(deliveryFee).piasters;
    final discountPiasters = Money.fromEgp(discount).piasters.clamp(0, subtotalPiasters + deliveryPiasters).toInt();
    final rate = settings.commissionEnabled ? (merchantCommissionBps ?? settings.defaultCommissionBps).clamp(0, 10000).toInt() : 0;
    final commission = ((subtotalPiasters * rate) / 10000).round();
    final riderPayout = settings.deliveryRevenueEnabled
        ? (riderPayoutPiasters ?? settings.defaultRiderPayoutPiasters).clamp(0, deliveryPiasters).toInt()
        : deliveryPiasters;
    return OrderFinancialSnapshot(
      subtotalPiasters: subtotalPiasters,
      deliveryFeePiasters: deliveryPiasters,
      discountPiasters: discountPiasters,
      customerTotalPiasters: subtotalPiasters + deliveryPiasters - discountPiasters,
      platformCommissionBps: rate,
      platformCommissionPiasters: commission,
      merchantNetPiasters: subtotalPiasters - commission,
      riderPayoutPiasters: riderPayout,
      platformDeliveryRevenuePiasters: deliveryPiasters - riderPayout,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'subtotal': Money.fromPiasters(subtotalPiasters).egp,
        'deliveryFee': Money.fromPiasters(deliveryFeePiasters).egp,
        'discount': Money.fromPiasters(discountPiasters).egp,
        'customerTotal': Money.fromPiasters(customerTotalPiasters).egp,
        'total': Money.fromPiasters(customerTotalPiasters).egp,
        'platformCommissionRate': platformCommissionBps / 100,
        'platformCommissionAmount': Money.fromPiasters(platformCommissionPiasters).egp,
        'merchantNetAmount': Money.fromPiasters(merchantNetPiasters).egp,
        'riderFee': Money.fromPiasters(riderPayoutPiasters).egp,
        'platformDeliveryRevenue': Money.fromPiasters(platformDeliveryRevenuePiasters).egp,
        'subtotalPiasters': subtotalPiasters,
        'deliveryFeePiasters': deliveryFeePiasters,
        'discountPiasters': discountPiasters,
        'customerTotalPiasters': customerTotalPiasters,
        'platformCommissionBps': platformCommissionBps,
        'platformCommissionPiasters': platformCommissionPiasters,
        'merchantNetPiasters': merchantNetPiasters,
        'riderPayoutPiasters': riderPayoutPiasters,
        'platformDeliveryRevenuePiasters': platformDeliveryRevenuePiasters,
        'financialRecognition': 'onDelivery',
      };
}
