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
    final quantityStr = item.amount.toInt().toString();

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
          // Top row with product name and trash button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product name
              Expanded(
                child: Text(
                  item.product.name,
                  style: AppTheme.mediumLargeHeading,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Trash icon button
              SizedBox(
                width: 28,
                height: 28,
                child: RawMaterialButton(
                  onPressed: () => iMat.shoppingCartRemove(item),
                  shape: const CircleBorder(),
                  fillColor: Colors.white,
                  elevation: 0,
                  constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                  padding: EdgeInsets.zero,
                  child: const Icon(Icons.close, size: AppTheme.cartButtonSize, color: Colors.black),
                ),
              ),

            ],
          ),

          const SizedBox(height: 4),

          // Price and quantity controls
          Row(
            children: [
              // Price
              Text(
                '${item.product.price.toStringAsFixed(2)} kr',
                style: AppTheme.mediumText,
              ),
              const Spacer(),

              _squareButton(
                icon: Icons.remove,
                onPressed: () => iMat.shoppingCartUpdate(item, delta: -1),
              ),
              const SizedBox(width: 6),

              SizedBox(
                width: 42,
                height: 28,
                child: TextField(
                  controller: TextEditingController(text: quantityStr),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTheme.mediumHeading.copyWith(fontSize: 16),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed > 0) {
                      final delta = parsed - item.amount.toInt();
                      if (delta != 0) {
                        iMat.shoppingCartUpdate(item, delta: delta.toDouble());
                      }
                    }
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _squareButton(
                icon: Icons.add,
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
