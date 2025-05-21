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
            const totalRowH = 32.0; // adjust if your total‐text row is taller
            const extraPadding = 16.0 * 2; // Container’s vertical padding

            // Compute how tall our list can get at most, so we never exceed the screen minus everything else:
            final maxListH = fullH
                - buttonH
                - buttonSpacing
                - totalRowH
                - extraPadding;

            // Rough item height—tweak to match your card’s actual height
            const itemH = 72.0;
            // Clamp
            final listH = (items.length * itemH).clamp(0.0, maxListH);

            return SizedBox(
              width: AppTheme.wizardCardSize,
              // Let the Column be only as tall as its content (list + total + buttons + spacings)
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // ── White frame with dynamic list + total ──
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
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    // The only scrollable bit
                    SizedBox(
                      height: listH,
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: AppTheme.paddingSmall),
                        itemBuilder: (c, i) =>
                            WizardCartItemCard(items[i]),
                      ),
                    ),

                    const SizedBox(height: AppTheme.paddingMediumSmall),

                    // Total row stays inside the white frame
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Totalt: ${total.toStringAsFixed(2)} kr",
                        style: AppTheme.mediumHeading,
                      ),
                    ),
                  ]),
                ),

                // ── Spacing before buttons ──
                const SizedBox(height: buttonSpacing),

                // ── Button row, always visible below the frame ──
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
                        style: AppTheme
                            .mediumHeading
                            .copyWith(color: Colors.white),
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
                        style: AppTheme
                            .mediumHeading
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ]),
            );
          }),
        ),
      ),
    );
  }
}