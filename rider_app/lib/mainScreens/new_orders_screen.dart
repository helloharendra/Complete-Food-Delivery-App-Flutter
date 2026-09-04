import 'package:dierb_core/dierb_core.dart';
import 'package:flutter/material.dart';
import 'dierb_rider_orders_view.dart';

class NewOrdersScreen extends StatelessWidget {
  const NewOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) => DierbRiderOrdersView(
        title: 'طلبات توصيل متاحة',
        statuses: [OrderStatus.readyForPickup.name],
        availableOrders: true,
      );
}
