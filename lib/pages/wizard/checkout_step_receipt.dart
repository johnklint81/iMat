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
    final deliveryMethod = handler.deliveryDescription;
    final deliveryTime = handler.deliveryDate ??
        DateTime.now().add(const Duration(hours: 2));

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
              // Kortet med alla varor + info
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Tack för din beställning!",
                        style: AppTheme.LARGEHeading,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingMediumSmall),

                    // Lista med varor
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                        child: Column(
                          children: items
                              .map((item) => WizardReceiptItemCard(item))
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.paddingMediumSmall),

                    // Betalningsmetod + leveransinfo
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildInfoRow("Betalningsmetod:", paymentMethod),
                          const SizedBox(height: AppTheme.paddingTiny),
                          _buildInfoRow("Leveranssätt:", deliveryMethod),
                          const SizedBox(height: AppTheme.paddingTiny),
                          _buildInfoRow(
                            "Beräknad leveranstid:",
                            "${deliveryTime.hour.toString().padLeft(2, '0')}:${deliveryTime.minute.toString().padLeft(2, '0')}",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppTheme.paddingSmall),

                    // Totalt
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Totalt: ${total.toStringAsFixed(2)} kr",
                        style: AppTheme.largeHeading,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.paddingMediumSmall),

              // Knappen som bara tar dig hem
              SizedBox(
                width: AppTheme.wizardCardSize,
                child: ElevatedButton(
                  onPressed: () async {
                    // Vi har redan lagt ordern, inga fler kontroller
                    await context.read<ImatDataHandler>().placeOrder();
                    onDone();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.buttonColor2,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Till startsidan",
                    style:
                    AppTheme.mediumHeading.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.mediumLargeText),
        Text(value, style: AppTheme.mediumLargeText),
      ],
    );
  }
}
