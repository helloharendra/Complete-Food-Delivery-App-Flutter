enum OrderStatus { received, waitingMerchantApproval, acceptedByMerchant, preparing, readyForPickup, pickedUpByRider, onTheWay, delivered, rejected, cancelled }

extension OrderStatusText on OrderStatus {
  String get labelAr {
    switch (this) {
      case OrderStatus.received: return 'تم استلام الطلب';
      case OrderStatus.waitingMerchantApproval: return 'بانتظار قبول المتجر';
      case OrderStatus.acceptedByMerchant: return 'تم قبول الطلب';
      case OrderStatus.preparing: return 'جاري التجهيز';
      case OrderStatus.readyForPickup: return 'جاهز للاستلام';
      case OrderStatus.pickedUpByRider: return 'استلمه المندوب';
      case OrderStatus.onTheWay: return 'في الطريق';
      case OrderStatus.delivered: return 'تم التسليم';
      case OrderStatus.rejected: return 'رفض المتجر الطلب';
      case OrderStatus.cancelled: return 'ملغي';
    }
  }
  bool get isTerminal => this == OrderStatus.delivered || this == OrderStatus.rejected || this == OrderStatus.cancelled;
  bool get isActive => !isTerminal;
}

abstract class OrderStatusCodec {
  static OrderStatus fromStorage(Object? value) {
    final raw = value?.toString();
    switch (raw) {
      case 'normal': return OrderStatus.waitingMerchantApproval;
      case 'accepted': return OrderStatus.acceptedByMerchant;
      case 'picking': return OrderStatus.readyForPickup;
      case 'delivering': return OrderStatus.onTheWay;
      case 'ended': return OrderStatus.delivered;
      default: return OrderStatus.values.firstWhere((status) => status.name == raw, orElse: () => OrderStatus.received);
    }
  }
  static String toStorage(OrderStatus status) => status.name;
  static bool isIncoming(Object? value) => fromStorage(value) == OrderStatus.waitingMerchantApproval;
  static bool isInProgress(Object? value) {
    final status = fromStorage(value);
    return status == OrderStatus.acceptedByMerchant || status == OrderStatus.preparing || status == OrderStatus.readyForPickup || status == OrderStatus.pickedUpByRider || status == OrderStatus.onTheWay;
  }

  /// Single source of truth for the production order state machine.
  /// Role-specific clients and backend rules must never skip these edges.
  static bool canTransition(OrderStatus current, OrderStatus next) {
    if (current.isTerminal || current == next) return false;
    switch (current) {
      case OrderStatus.received:
        return next == OrderStatus.waitingMerchantApproval || next == OrderStatus.cancelled;
      case OrderStatus.waitingMerchantApproval:
        return next == OrderStatus.acceptedByMerchant ||
            next == OrderStatus.rejected ||
            next == OrderStatus.cancelled;
      case OrderStatus.acceptedByMerchant:
        return next == OrderStatus.preparing || next == OrderStatus.cancelled;
      case OrderStatus.preparing:
        return next == OrderStatus.readyForPickup || next == OrderStatus.cancelled;
      case OrderStatus.readyForPickup:
        return next == OrderStatus.pickedUpByRider;
      case OrderStatus.pickedUpByRider:
        return next == OrderStatus.onTheWay;
      case OrderStatus.onTheWay:
        return next == OrderStatus.delivered;
      case OrderStatus.delivered:
      case OrderStatus.rejected:
      case OrderStatus.cancelled:
        return false;
    }
  }
}
