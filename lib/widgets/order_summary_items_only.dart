import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/widgets/wizard_receipt_item_card.dart';
import 'package:imat_app/app_theme.dart';

class OrderSummaryItemsOnly extends StatelessWidget {
  final Order order;

  const OrderSummaryItemsOnly({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final items = order.items;
    final total = items.fold<double>(
      0.0,
          (sum, item) => sum + item.total,
    );

    final paymentLabel = _formatPayment(order.paymentMethod);
    final deliveryMethod = _formatDelivery(order.deliveryOption);
    final deliveryTime = _formatDeliveryTime(order);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🛒 Product cards
        Column(
          children: items.map((item) => WizardReceiptItemCard(item)).toList(),
        ),
        const SizedBox(height: AppTheme.paddingMediumSmall),


        const SizedBox(height: AppTheme.paddingSmall),

        // 💰 Total
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Totalt: ${total.toStringAsFixed(2)} kr",
            style: AppTheme.largeHeading,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.mediumLargeText),
        Text(value, style: AppTheme.mediumLargeText),
      ],
    );
  }

  String _formatPayment(String? key) {
    return {
      'card': 'VISA/Mastercard',
      'swish': 'Swish',
      'invoice': 'Faktura',
      'klarna': 'Klarna',
      'qliro': 'Qliro',
    }[key] ?? 'Okänt';
  }

  String _formatDelivery(String? key) {
    switch (key) {
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

  String _formatDeliveryTime(Order order) {
    final dt = order.deliveryDate ?? DateTime.now().add(const Duration(hours: 2));
    return DateFormat('HH:mm').format(dt);
  }
}
