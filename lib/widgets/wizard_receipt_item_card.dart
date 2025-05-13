import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/app_theme.dart';

class WizardReceiptItemCard extends StatelessWidget {
  final ShoppingItem item;

  const WizardReceiptItemCard(this.item, {super.key});

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
          SizedBox(
            width: 48,
            height: 48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: iMat.getImage(product),
            ),
          ),
          const SizedBox(width: 12),

          // Name and quantity info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: AppTheme.smallText.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 4),
                Text(
                  "${product.price.toStringAsFixed(2)} kr/st × ${item.amount.toInt()}",
                  style: AppTheme.smallText,
                ),
              ],
            ),
          ),

          // Subtotal
          Text(
            "${subtotal.toStringAsFixed(2)} kr",
            style: AppTheme.smallText.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
