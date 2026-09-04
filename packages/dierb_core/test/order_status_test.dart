import 'package:dierb_core/dierb_core.dart';
import 'package:test/test.dart';

void main() {
  test('legacy order statuses remain readable', () {
    expect(OrderStatusCodec.fromStorage('normal'), OrderStatus.waitingMerchantApproval);
    expect(OrderStatusCodec.fromStorage('picking'), OrderStatus.readyForPickup);
    expect(OrderStatusCodec.fromStorage('delivering'), OrderStatus.onTheWay);
    expect(OrderStatusCodec.fromStorage('ended'), OrderStatus.delivered);
  });

  test('new statuses round-trip through storage', () {
    for (final status in OrderStatus.values) {
      expect(OrderStatusCodec.fromStorage(OrderStatusCodec.toStorage(status)), status);
    }
  });

  test('allows only the canonical end-to-end lifecycle', () {
    const path = <OrderStatus>[
      OrderStatus.received,
      OrderStatus.waitingMerchantApproval,
      OrderStatus.acceptedByMerchant,
      OrderStatus.preparing,
      OrderStatus.readyForPickup,
      OrderStatus.pickedUpByRider,
      OrderStatus.onTheWay,
      OrderStatus.delivered,
    ];
    for (var index = 0; index < path.length - 1; index++) {
      expect(OrderStatusCodec.canTransition(path[index], path[index + 1]), isTrue);
    }
  });

  test('blocks skipped, reversed, and post-terminal transitions', () {
    expect(OrderStatusCodec.canTransition(OrderStatus.waitingMerchantApproval, OrderStatus.preparing), isFalse);
    expect(OrderStatusCodec.canTransition(OrderStatus.readyForPickup, OrderStatus.delivered), isFalse);
    expect(OrderStatusCodec.canTransition(OrderStatus.onTheWay, OrderStatus.pickedUpByRider), isFalse);
    expect(OrderStatusCodec.canTransition(OrderStatus.delivered, OrderStatus.cancelled), isFalse);
    expect(OrderStatusCodec.canTransition(OrderStatus.rejected, OrderStatus.waitingMerchantApproval), isFalse);
  });

  test('supports controlled cancellation and merchant rejection', () {
    expect(OrderStatusCodec.canTransition(OrderStatus.waitingMerchantApproval, OrderStatus.rejected), isTrue);
    expect(OrderStatusCodec.canTransition(OrderStatus.waitingMerchantApproval, OrderStatus.cancelled), isTrue);
    expect(OrderStatusCodec.canTransition(OrderStatus.preparing, OrderStatus.cancelled), isTrue);
    expect(OrderStatusCodec.canTransition(OrderStatus.readyForPickup, OrderStatus.cancelled), isFalse);
  });
}
