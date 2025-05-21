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
        constraints: const BoxConstraints(maxWidth: AppTheme.detailCardSize), // Adjust as needed
        child: DefaultTextStyle(
          style: AppTheme.largeText.copyWith(color: Colors.black),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Center(
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: iMat.getImage(product),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(product.name, style: AppTheme.largeHeading.copyWith(color: Colors.black)),
                  const SizedBox(height: 8),
                  Text("${product.price.toStringAsFixed(2)} ${product.unit}",
                      style: AppTheme.largeHeading.copyWith(color: Colors.black)),

                  if (detail != null) ...[
                    const SizedBox(height: 12),
                    const Divider(color: Colors.black, thickness: 1, height: 24),
                    RichText(
                      text: TextSpan(
                        style: AppTheme.largeText.copyWith(color: Colors.black),
                        children: [
                          const TextSpan(text: "Innehåll:", style: TextStyle(decoration: TextDecoration.underline)),
                          TextSpan(text: " ${detail!.contents}"),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: AppTheme.largeText.copyWith(color: Colors.black),
                        children: [
                          const TextSpan(text: "Ursprung:", style: TextStyle(decoration: TextDecoration.underline)),
                          TextSpan(text: " ${detail!.origin}"),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: AppTheme.largeText.copyWith(color: Colors.black),
                        children: [
                          const TextSpan(text: "Beskrivning:", style: TextStyle(decoration: TextDecoration.underline)),
                          TextSpan(text: " ${detail!.description}"),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppTheme.paddingMedium),
                  Center(
                    child: SizedBox(
                      width: AppTheme.productCardButtonWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          final item = ShoppingItem(product);
                          iMat.shoppingCartAdd(item);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.buttonColor2,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: const BorderSide(color: AppTheme.borderColor, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text("Välj", style: AppTheme.mediumHeading.copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
