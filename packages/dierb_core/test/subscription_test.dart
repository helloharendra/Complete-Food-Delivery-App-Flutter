import 'package:dierb_core/dierb_core.dart';
import 'package:test/test.dart';

void main() {
  test('trial access expires using authoritative time', () {
    final subscription = MerchantSubscription(
      id: 's1', merchantId: 'm1', planId: 'monthly', status: SubscriptionStatus.trial,
      trialEndsAt: DateTime.utc(2026, 2, 1),
    );
    expect(subscription.canReceiveOrders(DateTime.utc(2026, 1, 31), gracePeriodDays: 3), isTrue);
    expect(subscription.canReceiveOrders(DateTime.utc(2026, 2, 1), gracePeriodDays: 3), isFalse);
  });

  test('ledger snapshot must balance in minor units', () {
    const entry = MerchantLedgerEntry(
      id: 'l1', merchantId: 'm1', orderId: 'o1', grossMinor: 10000,
      platformCommissionMinor: 1000, gatewayFeeMinor: 250,
      merchantNetMinor: 8750, type: 'sale', settlementStatus: 'pending',
    );
    expect(entry.isBalanced, isTrue);
  });
}
