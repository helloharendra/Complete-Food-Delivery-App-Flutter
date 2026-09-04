import 'package:dierb_core/dierb_core.dart';
import 'package:flutter/material.dart';
import 'dierb_rider_orders_view.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => DierbRiderOrdersView(
        title: 'سجل التوصيل',
        statuses: [OrderStatus.delivered.name, OrderStatus.cancelled.name],
      );
}
