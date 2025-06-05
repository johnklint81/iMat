import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/wizard_receipt_item_card.dart';

class ReceiptItemList extends StatelessWidget {
  final Order order;

  const ReceiptItemList({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final items = order.items;
    final total = items.fold<double>(0, (sum, item) => sum + item.total);

    final paymentLabel = _formatPayment(order.paymentMethod);
    final deliveryMethod = _formatDelivery(order.deliveryOption);
    final deliveryTime = order.deliveryDate != null
        ? "${order.deliveryDate!.hour.toString().padLeft(2, '0')}:${order.deliveryDate!.minute.toString().padLeft(2, '0')}"
        : "Okänt";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...items.map((item) => WizardReceiptItemCard(item)),
        const SizedBox(height: AppTheme.paddingMediumSmall),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildRow("Betalningsmetod:", paymentLabel),
              const SizedBox(height: AppTheme.paddingTiny),
              _buildRow("Leveranssätt:", deliveryMethod),
              const SizedBox(height: AppTheme.paddingTiny),
              _buildRow("Beräknad leveranstid:", deliveryTime),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.paddingSmall),
        Align(
          alignment: Alignment.centerRight,
          child: Text("Totalt: ${total.toStringAsFixed(2)} kr", style: AppTheme.largeHeading),
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
}
