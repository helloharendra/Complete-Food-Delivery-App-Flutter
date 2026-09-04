import 'package:dierb_core/dierb_core.dart';
import 'package:flutter/material.dart';
import 'dierb_rider_orders_view.dart';

class ParcelInProgress extends StatelessWidget {
  const ParcelInProgress({super.key});

  @override
  Widget build(BuildContext context) => DierbRiderOrdersView(
        title: 'طلبات تم استلامها',
        statuses: [OrderStatus.pickedUpByRider.name],
      );
}
