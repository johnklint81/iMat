import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/receipt_item_list.dart';

class OrderDetailsDialog extends StatelessWidget {
  final Order order;

  const OrderDetailsDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('yyyy-MM-dd').format(order.date);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Orderdetaljer", style: AppTheme.mediumHeading),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                _buildDetailRow("Ordernummer:", order.orderNumber.toString()),
                _buildDetailRow("Datum:", dateFormatted),
                _buildDetailRow("Status:", "På väg"),
                const SizedBox(height: 24),
                ReceiptItemList(order: order),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.buttonColor2,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(
                      "Stäng",
                      style: AppTheme.mediumHeading.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: AppTheme.smallText)),
          Expanded(flex: 3, child: Text(value, style: AppTheme.smallText)),
        ],
      ),
    );
  }
}
