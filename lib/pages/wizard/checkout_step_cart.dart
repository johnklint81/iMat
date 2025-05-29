import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/app_theme.dart';
import '../../widgets/wizard_product_card.dart';

class CheckoutStepCart extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onCancel;

  const CheckoutStepCart({
    required this.onNext,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<ImatDataHandler>().getShoppingCart();
    final items = cart.items;
    final total = items.fold<double>(0, (sum, i) => sum + i.total);

    final estimatedHeight = items.length * 84.0; // ≈ item height incl. spacing

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingSmall),
          child: SizedBox(
            width: AppTheme.wizardCardSize,
            child: Column(
              children: [
                // ── White card with collapsing/scrolling list ──
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 120,
                      maxHeight: estimatedHeight > 600 ? 600 : estimatedHeight + 120,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 0),
                              itemBuilder: (context, index) => WizardCartItemCard(items[index]),
                            ),
                          ),
                          const SizedBox(height: AppTheme.paddingMediumSmall),
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
                  ),
                ),

                const SizedBox(height: AppTheme.paddingMediumSmall),

                // ── Buttons ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor2,
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        "Avbryt",
                        style: AppTheme.mediumHeading.copyWith(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor1,
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        "Nästa",
                        style: AppTheme.mediumHeading.copyWith(color: Colors.white),
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
}
