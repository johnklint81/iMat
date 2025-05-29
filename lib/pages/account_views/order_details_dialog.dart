import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/receipt_item_list.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/shopping_item.dart';

class OrderDetailsDialog extends StatelessWidget {
  final Order order;

  const OrderDetailsDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderDateFormatted = DateFormat('yyyy-MM-dd').format(order.date);
    final deliveryDateFormatted = order.deliveryOption == 'date' && order.deliveryDate != null
        ? DateFormat('yyyy-MM-dd').format(order.deliveryDate!)
        : null;

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
                Text("Orderdetaljer", style: AppTheme.largeHeading),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                _buildDetailRow("Ordernummer:", order.orderNumber.toString()),
                _buildDetailRow("Datum:", orderDateFormatted),
                // _buildDetailRow("Leveranssätt:", _formatDeliveryOption(order)),
                if (deliveryDateFormatted != null)
                  _buildDetailRow("Leveransdatum:", deliveryDateFormatted),
                const SizedBox(height: 24),
                ReceiptItemList(order: order),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final handler = context.read<ImatDataHandler>();
                        for (final item in order.items) {
                          handler.shoppingCartAdd(
                            ShoppingItem(item.product, amount: item.amount),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alla varor har lagts till i kundvagnen')),
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor1,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text(
                        "Lägg till i kundvagn",
                        style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                      ),
                    ),
                    TextButton(
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
                  ],
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
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTheme.mediumLargeText, // match font size below the image
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTheme.mediumLargeText, // match font size
              textAlign: TextAlign.right, // flush right
            ),
          ),
        ],
      ),
    );
  }


  String _formatDeliveryOption(Order order) {
    switch (order.deliveryOption) {
      case 'asap':
        return 'Så fort som möjligt';
      case 'pickup':
        return 'Hämta vid utlämning';
      case 'date':
        return 'På specifikt datum';
      default:
        return 'Okänt';
    }
  }
}
