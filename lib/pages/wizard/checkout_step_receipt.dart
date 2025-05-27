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
    final handler = context.watch<ImatDataHandler>();
    final deliveryMethod = handler.deliveryOption == 'date' && handler.deliveryDate != null
        ? handler.deliveryDate!.toLocal().toString().split(' ')[0]
        : handler.deliveryOption == 'pickup'
        ? 'Hämtas vid utlämning'
        : 'Så fort som möjligt';

    final deliveryTime = handler.deliveryOption == 'date' && handler.deliveryDate != null
        ? handler.deliveryDate!
        : DateTime.now().add(const Duration(hours: 2));


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
                width: AppTheme.wizardCardSize,
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
                        style: AppTheme.LARGEHeading,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingMediumSmall),
                    SizedBox(
                      height: 500, // Adjust height as needed or use a responsive value
                      child: SingleChildScrollView(
                        child: Column(
                          children: items.map((item) => WizardReceiptItemCard(item)).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.paddingMediumSmall),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end, // flush right
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Betalningsmetod:", style: AppTheme.mediumLargeText),
                              Text(paymentMethod, style: AppTheme.mediumLargeText),
                            ],
                          ),
                          const SizedBox(height: AppTheme.paddingTiny),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Leveranssätt:", style: AppTheme.mediumLargeText),
                              Text(deliveryMethod, style: AppTheme.mediumLargeText),
                            ],
                          ),
                          const SizedBox(height: AppTheme.paddingTiny),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Beräknad leveranstid:", style: AppTheme.mediumLargeText),
                              Text(
                                "${deliveryTime.hour}:${deliveryTime.minute.toString().padLeft(2, '0')}",
                                style: AppTheme.mediumLargeText,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppTheme.paddingSmall),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("Totalt: ${total.toStringAsFixed(2)} kr", style: AppTheme.largeHeading),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.paddingMediumSmall),
              SizedBox(
                width: AppTheme.wizardCardSize,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      final cart = context.read<ImatDataHandler>().getShoppingCart();
                      if (cart.items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Kundvagnen är tom!"))
                        );
                        return;
                      }

                      await context.read<ImatDataHandler>().placeOrder();
                      onDone();
                    },

                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor2,
                        foregroundColor: Colors.black    // Text/icon color
                    ),
                    child: Text(
                        "Till startsidan",
                        style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                    ),
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
