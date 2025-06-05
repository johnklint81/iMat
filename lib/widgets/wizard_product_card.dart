import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/app_theme.dart';

class WizardCartItemCard extends StatelessWidget {
  final ShoppingItem item;

  const WizardCartItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = Provider.of<ImatDataHandler>(context, listen: false);
    final product = item.product;
    final subtotal = item.total;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: FittedBox(
                fit: BoxFit.cover,
                child: iMat.getImage(product),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Right side: product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and subtotal
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTheme.mediumText.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${subtotal.toStringAsFixed(2)} kr",
                      style: AppTheme.mediumText.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Price and quantity controls (right-aligned under subtotal)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${product.price.toStringAsFixed(2)} kr/st",
                        style: AppTheme.mediumText,
                      ),
                    ),
                    _squareButton(
                      icon: Icons.remove,
                      onPressed: () => iMat.shoppingCartUpdate(item, delta: -1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.amount.toInt()}',
                        style: AppTheme.mediumHeading,
                      ),
                    ),
                    _squareButton(
                      icon: Icons.add,
                      onPressed: () => iMat.shoppingCartUpdate(item, delta: 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _squareButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = AppTheme.backgroundColor,
    Color iconColor = Colors.black,
  }) {
    return SizedBox(
      width: 28,
      height: 28,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: const BorderSide(color: Colors.black12),
        ),
        onPressed: onPressed,
        child: Icon(icon, size: AppTheme.shoppingCartButtonFontSize, color: iconColor),
      ),
    );
  }

}
