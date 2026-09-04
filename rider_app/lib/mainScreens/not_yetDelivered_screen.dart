import 'package:dierb_core/dierb_core.dart';
import 'package:flutter/material.dart';
import 'dierb_rider_orders_view.dart';

class NotYetDeliveredScreen extends StatelessWidget {
  const NotYetDeliveredScreen({super.key});

  @override
  Widget build(BuildContext context) => DierbRiderOrdersView(
        title: 'طلبات في الطريق',
        statuses: [OrderStatus.onTheWay.name],
      );
}
