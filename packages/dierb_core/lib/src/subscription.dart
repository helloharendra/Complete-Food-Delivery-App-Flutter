enum SubscriptionStatus { trial, active, gracePeriod, pastDue, suspended, cancelled }

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.nameAr,
    required this.priceMinor,
    this.currency = 'EGP',
    this.billingPeriodDays = 30,
    this.trialDays = 30,
    this.gracePeriodDays = 3,
    this.active = true,
  });

  final String id;
  final String nameAr;
  final int priceMinor;
  final String currency;
  final int billingPeriodDays;
  final int trialDays;
  final int gracePeriodDays;
  final bool active;

  Map<String, Object?> toMap() => <String, Object?>{
        'nameAr': nameAr,
        'priceMinor': priceMinor,
        'currency': currency,
        'billingPeriodDays': billingPeriodDays,
        'trialDays': trialDays,
        'gracePeriodDays': gracePeriodDays,
        'active': active,
      };
}

class MerchantSubscription {
  const MerchantSubscription({
    required this.id,
    required this.merchantId,
    required this.planId,
    required this.status,
    this.trialStartedAt,
    this.trialEndsAt,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.nextPaymentDueAt,
    this.lastPaymentId,
    this.manualOverride = false,
  });

  final String id;
  final String merchantId;
  final String planId;
  final SubscriptionStatus status;
  final DateTime? trialStartedAt;
  final DateTime? trialEndsAt;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime? nextPaymentDueAt;
  final String? lastPaymentId;
  final bool manualOverride;

  bool canReceiveOrders(DateTime authoritativeNow, {required int gracePeriodDays}) {
    if (status == SubscriptionStatus.suspended || status == SubscriptionStatus.cancelled || status == SubscriptionStatus.pastDue) return false;
    if (manualOverride) return true;
    if (status == SubscriptionStatus.trial) return trialEndsAt != null && authoritativeNow.isBefore(trialEndsAt!);
    if (status == SubscriptionStatus.active) return currentPeriodEnd != null && authoritativeNow.isBefore(currentPeriodEnd!);
    if (status == SubscriptionStatus.gracePeriod) {
      return currentPeriodEnd != null && authoritativeNow.isBefore(currentPeriodEnd!.add(Duration(days: gracePeriodDays)));
    }
    return false;
  }
}

class MerchantLedgerEntry {
  const MerchantLedgerEntry({
    required this.id,
    required this.merchantId,
    required this.orderId,
    required this.grossMinor,
    required this.platformCommissionMinor,
    required this.gatewayFeeMinor,
    required this.merchantNetMinor,
    required this.type,
    required this.settlementStatus,
  });

  final String id;
  final String merchantId;
  final String orderId;
  final int grossMinor;
  final int platformCommissionMinor;
  final int gatewayFeeMinor;
  final int merchantNetMinor;
  final String type;
  final String settlementStatus;

  bool get isBalanced => grossMinor - platformCommissionMinor - gatewayFeeMinor == merchantNetMinor;
}
