import 'package:flutter/material.dart';
import 'package:imat_app/widgets/shopping_cart_product_card.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../model/imat_data_handler.dart';
import 'checkout_wizard.dart';

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
      width: 250,
      color: const Color(0xFFFFEECE),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Varukorg',
              style: AppTheme.largeHeading,
            ),
          ),

          const SizedBox(height: 12),

          items.isEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Din varukorg är tom.", style: AppTheme.mediumText),
              Text(
                "Lägg till varor genom att klicka på 'Välj'.",
                style: AppTheme.smallText.copyWith(color: Colors.grey),
              ),
            ],
          )
              : Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ShoppingCartProductCard(items[index]);
              },

            ),
          ),


          const Spacer(),

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
                  style: AppTheme.mediumHeading,
                ),
                Text('${total.toStringAsFixed(2)} kr', style: AppTheme.mediumHeading),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.paddingLarge),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutWizard()),
                );
              },

              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.buttonColor1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: Colors.black12, width: 2),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                  "Gå till kassan",
                  style: AppTheme.mediumHeading),
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
        ],
      ),
    );
  }
}
