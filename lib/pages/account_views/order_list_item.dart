import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/pages/account_views/order_details_dialog.dart';

class OrderListItem extends StatelessWidget {
  final Order order;
  const OrderListItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('yyyy-MM-dd').format(order.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Left column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ordernr: ${order.orderNumber}", style: AppTheme.smallText),
                  const SizedBox(height: 4),
                  Text("Datum: $dateFormatted", style: AppTheme.smallText),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10),
                      const SizedBox(width: 6),
                      Text("Status: På väg", style: AppTheme.smallText),
                    ],
                  ),
                ],
              ),
            ),
            // Right button
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => OrderDetailsDialog(order: order),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text("Visa order"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(color: Colors.black),
        const SizedBox(height: 12),
      ],
    );
  }
}
