import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/pages/account_views/order_list_item.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context
        .watch<ImatDataHandler>()
        .orders;

    // Debug print
    for (final order in orders) {
      print('Order ${order.orderNumber}: ${order.items.length} items');
      for (final item in order.items) {
        print(' - ${item.product.name} x${item.amount}');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dina ordrar:", style: AppTheme.LARGEHeading),
        const SizedBox(height: 8),
        const Divider(color: Colors.black),
        const SizedBox(height: 12),
        ...orders.map((order) => OrderListItem(order: order)),
      ],
    );
  }
}
