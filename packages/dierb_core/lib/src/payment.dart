enum PaymentPurpose { customerOrder, merchantSubscription, settlementAdjustment }

enum PaymentMethod { cashOnDelivery, online }

enum PaymentStatus {
  pending,
  processing,
  paid,
  failed,
  cancelled,
  refundPending,
  refunded,
  partiallyRefunded,
}

class PaymentRecord {
  const PaymentRecord({
    required this.id,
    required this.userId,
    required this.purpose,
    required this.amountMinor,
    this.currency = 'EGP',
    required this.method,
    required this.status,
    this.merchantId,
    this.orderId,
    this.provider,
    this.providerTransactionId,
    this.providerEventId,
    this.createdAt,
    this.paidAt,
    this.failedAt,
    this.refundedMinor = 0,
    this.metadata = const <String, Object?>{},
  });

  final String id;
  final String userId;
  final String? merchantId;
  final String? orderId;
  final PaymentPurpose purpose;
  final int amountMinor;
  final String currency;
  final String? provider;
  final String? providerTransactionId;
  final String? providerEventId;
  final PaymentStatus status;
  final PaymentMethod method;
  final DateTime? createdAt;
  final DateTime? paidAt;
  final DateTime? failedAt;
  final int refundedMinor;
  final Map<String, Object?> metadata;

  bool get isSettled => status == PaymentStatus.paid || status == PaymentStatus.refunded || status == PaymentStatus.partiallyRefunded;

  Map<String, Object?> toMap() => <String, Object?>{
        'userId': userId,
        if (merchantId != null) 'merchantId': merchantId,
        if (orderId != null) 'orderId': orderId,
        'purpose': purpose.name,
        'amountMinor': amountMinor,
        'currency': currency,
        if (provider != null) 'provider': provider,
        if (providerTransactionId != null) 'providerTransactionId': providerTransactionId,
        if (providerEventId != null) 'providerEventId': providerEventId,
        'status': status.name,
        'paymentMethod': method.name,
        if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
        if (paidAt != null) 'paidAt': paidAt!.toUtc().toIso8601String(),
        if (failedAt != null) 'failedAt': failedAt!.toUtc().toIso8601String(),
        'refundedMinor': refundedMinor,
        'metadata': metadata,
      };
}

class PaymentStateMachine {
  PaymentStateMachine._();
  static const Map<PaymentStatus, Set<PaymentStatus>> _allowed = <PaymentStatus, Set<PaymentStatus>>{
    PaymentStatus.pending: <PaymentStatus>{PaymentStatus.processing, PaymentStatus.cancelled, PaymentStatus.failed},
    PaymentStatus.processing: <PaymentStatus>{PaymentStatus.paid, PaymentStatus.failed, PaymentStatus.cancelled},
    PaymentStatus.failed: <PaymentStatus>{PaymentStatus.processing, PaymentStatus.cancelled},
    PaymentStatus.paid: <PaymentStatus>{PaymentStatus.refundPending, PaymentStatus.partiallyRefunded, PaymentStatus.refunded},
    PaymentStatus.refundPending: <PaymentStatus>{PaymentStatus.paid, PaymentStatus.partiallyRefunded, PaymentStatus.refunded, PaymentStatus.failed},
    PaymentStatus.partiallyRefunded: <PaymentStatus>{PaymentStatus.refundPending, PaymentStatus.refunded},
    PaymentStatus.cancelled: <PaymentStatus>{},
    PaymentStatus.refunded: <PaymentStatus>{},
  };

  static bool canTransition(PaymentStatus from, PaymentStatus to) => from == to || (_allowed[from]?.contains(to) ?? false);
}

class PaymentSessionRequest {
  const PaymentSessionRequest({required this.paymentId, required this.amountMinor, required this.currency, required this.idempotencyKey, required this.returnUrl});
  final String paymentId;
  final int amountMinor;
  final String currency;
  final String idempotencyKey;
  final Uri returnUrl;
}

class PaymentSession {
  const PaymentSession({required this.providerReference, required this.checkoutUrl});
  final String providerReference;
  final Uri checkoutUrl;
}

/// Server-side contract only. Provider secrets and webhook verification must
/// never be implemented in a Flutter/mobile or public web bundle.
abstract class PaymentGateway {
  Future<PaymentSession> createPayment(PaymentSessionRequest request);
  Future<PaymentStatus> queryPayment(String providerReference);
  Future<void> refundPayment({required String providerReference, required int amountMinor, required String idempotencyKey});
  Future<bool> verifyWebhookSignature({required List<int> rawBody, required Map<String, String> headers});
}

class WebhookReceipt {
  const WebhookReceipt({required this.provider, required this.eventId, required this.receivedAt});
  final String provider;
  final String eventId;
  final DateTime receivedAt;
  String get idempotencyKey => '$provider:$eventId';
}
