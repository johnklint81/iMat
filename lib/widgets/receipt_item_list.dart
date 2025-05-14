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

    // Use dummy delivery info for now, adjust if needed
    const deliveryMethod = "Så fort som möjligt";
    final deliveryTime = order.date.add(const Duration(hours: 2));

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Betalningsmetod:", style: AppTheme.mediumText),
                  Text("Kort", style: AppTheme.mediumText),
                ],
              ),
              const SizedBox(height: AppTheme.paddingTiny),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Leveranssätt:", style: AppTheme.mediumText),
                  Text(deliveryMethod, style: AppTheme.mediumText),
                ],
              ),
              const SizedBox(height: AppTheme.paddingTiny),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Beräknad leveranstid:", style: AppTheme.mediumText),
                  Text(
                    "${deliveryTime.hour}:${deliveryTime.minute.toString().padLeft(2, '0')}",
                    style: AppTheme.mediumText,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.paddingSmall),
        Align(
          alignment: Alignment.centerRight,
          child: Text("Totalt: ${total.toStringAsFixed(2)} kr", style: AppTheme.mediumHeading),
        ),
      ],
    );
  }
}
