import 'package:dierb_core/dierb_core.dart';
import 'package:test/test.dart';

void main() {
  test('order snapshot balances customer merchant rider and platform totals', () {
    final snapshot = OrderFinancialSnapshot.calculate(
      subtotal: 250,
      deliveryFee: 30,
      settings: const MonetizationSettings(
        commissionEnabled: true,
        defaultCommissionBps: 1000,
        deliveryRevenueEnabled: true,
        defaultRiderPayoutPiasters: 2000,
      ),
    );

    expect(snapshot.customerTotalPiasters, 28000);
    expect(snapshot.platformCommissionPiasters, 2500);
    expect(snapshot.merchantNetPiasters, 22500);
    expect(snapshot.riderPayoutPiasters, 2000);
    expect(snapshot.platformDeliveryRevenuePiasters, 1000);
    expect(snapshot.merchantNetPiasters + snapshot.platformCommissionPiasters, snapshot.subtotalPiasters);
    expect(snapshot.riderPayoutPiasters + snapshot.platformDeliveryRevenuePiasters, snapshot.deliveryFeePiasters);
  });

  test('configured values are clamped to safe financial ranges', () {
    final snapshot = OrderFinancialSnapshot.calculate(
      subtotal: 100,
      deliveryFee: 10,
      settings: const MonetizationSettings(
        commissionEnabled: true,
        defaultCommissionBps: 20000,
        deliveryRevenueEnabled: true,
        defaultRiderPayoutPiasters: 5000,
      ),
    );

    expect(snapshot.platformCommissionBps, 10000);
    expect(snapshot.merchantNetPiasters, 0);
    expect(snapshot.riderPayoutPiasters, 1000);
    expect(snapshot.platformDeliveryRevenuePiasters, 0);
  });
}
