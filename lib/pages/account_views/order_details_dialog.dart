import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/receipt_item_list.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import '../../widgets/order_summary_items_only.dart';


class OrderDetailsDialog extends StatelessWidget {
  final Order order;

  const OrderDetailsDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderDateFormatted = DateFormat('yyyy-MM-dd').format(order.date);
    final details = [
      ("Ordernummer:", order.orderNumber.toString()),
      ("Datum för beställning:", orderDateFormatted),
      ("Betalningsmetod:", _formatPayment(order.paymentMethod)),
      ("Leveranssätt:", _formatDeliveryOption(order)),
      ("Beräknat leveransdatum:", _formatDeliveryDate(order)),
      ("Beräknad leveranstid:", _formatDeliveryTime(order)),
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Orderdetaljer", style: AppTheme.largeHeading),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Rutor med alternerande färg
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor, // ändrat från Colors.white
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderColor),
                        ),

                        child: Column(
                          children: List.generate(details.length, (i) {
                            final (label, value) = details[i];
                            final bgColor = i % 2 == 0 ? AppTheme.stripeLight : AppTheme.stripeDark;

                            return Container(
                              color: bgColor,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(label, style: AppTheme.mediumLargeText),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(value,
                                        style: AppTheme.mediumLargeText,
                                        textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 24),
                      OrderSummaryItemsOnly(order: order),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Fixed bottom buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
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
                        style: AppTheme.largeHeading.copyWith(color: Colors.white),
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
                        style: AppTheme.largeHeading.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPayment(String? key) {
    final normalized = key?.toLowerCase();
    return {
      'card': 'VISA/Mastercard',
      'swish': 'Swish',
      'invoice': 'Faktura',
      'klarna': 'Klarna',
      'qliro': 'Qliro',
    }[normalized] ?? 'Okänt';
  }

  String _formatDeliveryOption(Order order) {
    final option = order.deliveryOption?.toLowerCase();
    switch (option) {
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


  String _formatDeliveryDate(Order order) {
    final dt = order.deliveryDate ?? DateTime.now().add(const Duration(hours: 2));
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  String _formatDeliveryTime(Order order) {
    final dt = order.deliveryDate ?? DateTime.now().add(const Duration(hours: 2));
    return DateFormat('HH:mm').format(dt);
  }
}
