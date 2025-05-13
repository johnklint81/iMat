import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import '../../widgets/wizard_receipt_item_card.dart';

class CheckoutStepReceipt extends StatelessWidget {
  final VoidCallback onDone;
  final String paymentMethod;

  const CheckoutStepReceipt({
    required this.onDone,
    required this.paymentMethod,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<ImatDataHandler>().getShoppingCart();
    final items = cart.items;
    final total = items.fold<double>(0, (sum, item) => sum + item.total);
    const deliveryMethod = "Så fort som möjligt";
    final deliveryTime = DateTime.now().add(const Duration(hours: 2));

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.backgroundColor,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: AppTheme.paddingSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 600,
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.borderColor,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Tack för din beställning!",
                        style: AppTheme.largeHeading,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingMediumSmall),
                    ...items.map((item) => WizardReceiptItemCard(item)),
                    const SizedBox(height: AppTheme.paddingMediumSmall),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end, // flush right
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Betalningsmetod:", style: AppTheme.mediumText),
                              Text(paymentMethod, style: AppTheme.mediumText),
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
                ),
              ),
              const SizedBox(height: AppTheme.paddingMediumSmall),
              SizedBox(
                width: 600,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.read<ImatDataHandler>().placeOrder();
                      onDone();
                    },
                    child: const Text("Till startsidan"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
