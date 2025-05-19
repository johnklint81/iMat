import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/product_detail.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/app_theme.dart';

class ProductDetailDialog extends StatelessWidget {
  final Product product;
  final ProductDetail? detail;

  const ProductDetailDialog({super.key, required this.product, this.detail});

  @override
  Widget build(BuildContext context) {
    final iMat = Provider.of<ImatDataHandler>(context, listen: false);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppTheme.backgroundColor,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500), // Adjust as needed
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button top right
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Center(
                child: SizedBox(height: 200, child: iMat.getImage(product)),
              ),
              const SizedBox(height: 16),
              Text(product.name, style: AppTheme.mediumLargeHeading),
              const SizedBox(height: 8),
              Text(
                "${product.price.toStringAsFixed(2)} ${product.unit}",
                style: AppTheme.mediumLargeHeading,
              ),
              if (detail != null) ...[
                const SizedBox(height: 12),

                Text(
                  "Innehåll: ${detail!.contents}",
                  style: AppTheme.mediumText,
                ),
                Text("Ursprung: ${detail!.origin}", style: AppTheme.mediumText),
                Text(
                  "Beskrivning: ${detail!.description}",
                  style: AppTheme.mediumText,
                ),
              ],
              const SizedBox(height: AppTheme.paddingMedium),
              Center(
                child: SizedBox(
                  width: AppTheme.productCardButtonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      final item = ShoppingItem(
                        product,
                      ); // 1.0 items by default
                      iMat.shoppingCartAdd(item); // add to cart via backend
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.buttonColor2,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(
                        color: AppTheme.borderColor,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Välj",
                      style: AppTheme.mediumHeading.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
