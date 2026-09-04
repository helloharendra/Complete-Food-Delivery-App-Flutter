import 'package:dierb_core/dierb_core.dart';
import 'package:test/test.dart';

void main() {
  group('payment state machine', () {
    test('online payment cannot jump from pending to paid', () {
      expect(PaymentStateMachine.canTransition(PaymentStatus.pending, PaymentStatus.paid), isFalse);
      expect(PaymentStateMachine.canTransition(PaymentStatus.pending, PaymentStatus.processing), isTrue);
      expect(PaymentStateMachine.canTransition(PaymentStatus.processing, PaymentStatus.paid), isTrue);
    });

    test('paid payment can enter refund lifecycle but cannot fail', () {
      expect(PaymentStateMachine.canTransition(PaymentStatus.paid, PaymentStatus.refundPending), isTrue);
      expect(PaymentStateMachine.canTransition(PaymentStatus.paid, PaymentStatus.failed), isFalse);
    });

    test('webhook idempotency key is deterministic', () {
      final first = WebhookReceipt(provider: 'gateway', eventId: 'evt-1', receivedAt: DateTime.utc(2026));
      final retry = WebhookReceipt(provider: 'gateway', eventId: 'evt-1', receivedAt: DateTime.utc(2026, 1, 2));
      expect(first.idempotencyKey, retry.idempotencyKey);
    });
  });

  test('COD record remains pending and is not online paid', () {
    const payment = PaymentRecord(
      id: 'p1',
      userId: 'u1',
      orderId: 'o1',
      purpose: PaymentPurpose.customerOrder,
      amountMinor: 12500,
      method: PaymentMethod.cashOnDelivery,
      status: PaymentStatus.pending,
    );
    expect(payment.isSettled, isFalse);
    expect(payment.toMap()['amountMinor'], 12500);
  });
}
