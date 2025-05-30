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
    final orderDateFormatted = DateFormat('yyyy-MM-dd').format(order.date);

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
                  Text("Ordernr: ${order.orderNumber}", style: AppTheme.mediumLargeText),
                  const SizedBox(height: 4),
                  Text("Beställd: $orderDateFormatted", style: AppTheme.mediumLargeText),
                  const SizedBox(height: 4),
                  Text("Leveranssätt: ${_formatDeliveryOption(order)}", style: AppTheme.mediumLargeText),
                  if (order.deliveryDate != null)
                    Text(
                      "Beräknad leveranstid: ${DateFormat('yyyy-MM-dd HH:mm').format(order.deliveryDate!)}",
                      style: AppTheme.mediumLargeText,
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
                backgroundColor: AppTheme.buttonColor2,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: const BorderSide(color: AppTheme.borderColor),
                ),
              ),
              child: Text(
                "Visa order",
                style: AppTheme.largeHeading.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(color: Colors.black),
        const SizedBox(height: 12),
      ],
    );
  }

  String _formatDeliveryOption(Order order) {
    switch (order.deliveryOption) {
      case 'asap':
        return 'Så fort som möjligt';
      case 'pickup':
        return 'Hämta vid utlämning';
      case 'date':
        return 'På ett specifikt datum';
      default:
        return 'Okänt';
    }
  }
}
