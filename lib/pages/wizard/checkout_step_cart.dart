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

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: AppTheme.paddingSmall),
        child: Align(
          alignment: Alignment.topCenter,
          child: LayoutBuilder(builder: (context, constraints) {
            final fullH = constraints.maxHeight;
            const buttonH = 48.0;
            const buttonSpacing = AppTheme.paddingMediumSmall;
            const totalRowH = 32.0;
            const extraPadding = 16.0 * 2;

            final maxListH = fullH - buttonH - buttonSpacing - totalRowH - extraPadding;
            const itemH = 72.0;

            return SizedBox(
              width: AppTheme.wizardCardSize,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── White frame with scrollable product list ──
                  Container(
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
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: itemH,
                            maxHeight: maxListH,
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: AppTheme.paddingSmall),
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

                  const SizedBox(height: buttonSpacing),

                  // ── Button row ──
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
            );
          }),
        ),
      ),
    );
  }
}
