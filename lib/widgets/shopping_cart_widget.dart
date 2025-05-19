import 'package:flutter/material.dart';
import 'package:imat_app/widgets/shopping_cart_product_card.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../model/imat_data_handler.dart';
import '../pages/checkout_wizard.dart';

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
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Varukorg',
              style: AppTheme.LARGEHeading,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: items.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket, size: 64, color: Colors.grey),
                const SizedBox(height: 8),
                Text("Din kundvagn är tom.", style: AppTheme.mediumText.copyWith(color: Colors.black)),
                Text("Lägg till varor genom att klicka på 'Välj'.",
                    style: AppTheme.mediumText.copyWith(color: Colors.grey)),
              ],
            )
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ShoppingCartProductCard(items[index]);
              },
            ),
          ),
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    iMat.shoppingCartClear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(color: AppTheme.borderColor, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text(
                    "Töm varukorgen",
                    style: AppTheme.mediumHeading,
                  ),
                ),
              ),
            ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black12, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Totalt:',
                  style: AppTheme.mediumLargeHeading,
                ),
                Text('${total.toStringAsFixed(2)} kr', style: AppTheme.mediumLargeHeading),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.paddingLarge),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (cart.items.isNotEmpty){
                  //Går bara till kassan om man har något i varukorgen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutWizard()),
                );}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.buttonColor1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: AppTheme.borderColor, width: 2),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),

              child: const Text(
                  "\$   Gå till kassan",
                  style: AppTheme.mediumHeading),
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
        ],
      ),
    );
  }
}
