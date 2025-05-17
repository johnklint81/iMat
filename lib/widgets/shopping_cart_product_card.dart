import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/app_theme.dart';

class ShoppingCartProductCard extends StatelessWidget {
  final ShoppingItem item;

  const ShoppingCartProductCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = Provider.of<ImatDataHandler>(context, listen: false);
    String quantityStr = item.amount.toInt().toString();
    double baseSize = AppTheme.mediumHeading.fontSize ?? 16;
    double fontSize = quantityStr.length > 2 ? baseSize - 7 : baseSize;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name
          Text(
            item.product.name,
            style: AppTheme.mediumLargeHeading,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Price and quantity controls
          Row(
            children: [
              // Left: price
              Text(
                '${item.product.price.toStringAsFixed(2)} kr',
                style: AppTheme.mediumText,
              ),

              const Spacer(),

              // Right: quantity controls
              _squareButton(
                icon: Icons.remove,
                backgroundColor: AppTheme.buttonColor2,
                onPressed: () => iMat.shoppingCartUpdate(item, delta: -1),
              ),

              const SizedBox(width: 8),

              SizedBox(
                width: 24,
                child: Text(
                  quantityStr,
                  style: AppTheme.mediumHeading.copyWith(fontSize: fontSize),
                  textAlign: TextAlign.center,
                ),
              ),


              const SizedBox(width: 8),

              _squareButton(
                icon: Icons.add,
                backgroundColor: AppTheme.buttonColor2,
                onPressed: () => iMat.shoppingCartUpdate(item, delta: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _squareButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = AppTheme.buttonColor1,
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