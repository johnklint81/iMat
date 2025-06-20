import 'package:flutter/material.dart';
import 'package:imat_app/widgets/shopping_cart_product_card.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../model/imat_data_handler.dart';
import '../pages/checkout_wizard_view.dart';

class ShoppingCartWidget extends StatelessWidget {
  const ShoppingCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final cart = iMat.getShoppingCart(); // add ()
    final items = cart.items;
    final total = items.fold<double>(
      0.0,
          (sum, item) => sum + item.total,
    );
    return Container(
      width: 300,
      color: const Color(0xFFFFEECE),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Center(
                child: Text(
                  'Varukorg',
                  style: AppTheme.LARGEHeading,
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () => iMat.shoppingCartClear(),
                  tooltip: 'Töm varukorgen',
                  icon: const Icon(Icons.delete, size: 36),
                  color: Colors.red.shade400,
                ),
              ),
            ],
          ),




          // const SizedBox(height: 4),

          Expanded(
            child: items.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket, size: 64, color: Colors.grey),
                const SizedBox(height: 8),
                Text("Din kundvagn är tom.",
                    style: AppTheme.mediumText.copyWith(color: Colors.black)),
                Text(
                  "Lägg till varor genom att klicka på 'Välj'.",
                  style: AppTheme.mediumText.copyWith(color: Colors.grey),
                ),
              ],
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ShoppingCartProductCard(items[index]);
                    },
                  ),
                ),
                const SizedBox(height: 8), // Space above "Totalt" box
              ],
            ),
          ),


          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black12, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Totalt:', style: AppTheme.mediumHeading),
                    Text('${total.toStringAsFixed(2)} kr', style: AppTheme.mediumLargeHeading),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (cart.items.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutWizard()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          title: const Text("Varukorgen är tom", style: AppTheme.largeHeading),
                          content: const Text("Du måste ha minst en vara i varukorgen för att gå till kassan.", style: AppTheme.mediumLargeText),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                backgroundColor: AppTheme.buttonColor2,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              child: Text("OK", style: AppTheme.mediumLargeHeading.copyWith(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.buttonColor1,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(color: AppTheme.borderColor, width: 0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Gå till kassan", style: AppTheme.mediumLargeHeading),
                ),
              ),
            ],
          ),
          // const SizedBox(height: AppTheme.paddingSmall),

        ],
      ),
    );
  }
}
