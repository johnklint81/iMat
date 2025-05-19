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
    final total = items.fold<double>(0, (sum, item) => sum + item.total);

    return Container(
      color: AppTheme.backgroundColor, // ← background behind the frame
      width: double.infinity,
      height: double.infinity,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: AppTheme.paddingSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cart Frame
              Container(
                width: AppTheme.wizardCardSize,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...items.map((item) => WizardCartItemCard(item)),
                    const SizedBox(height: AppTheme.paddingMediumSmall),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Totalt: ${total.toStringAsFixed(2)} kr",
                        style: AppTheme.mediumHeading,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.paddingMediumSmall),

              // Button Row
              SizedBox(
                width: AppTheme.wizardCardSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor2,
                        foregroundColor: Colors.black
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
                          foregroundColor: Colors.black
                      ),
                      child: Text(
                          "Nästa",
                          style: AppTheme.mediumHeading.copyWith(color: Colors.white),
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
}