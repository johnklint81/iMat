import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_detail_dialog.dart';
import '../model/imat/shopping_item.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ImatDataHandler iMat;

  const ProductCard(this.product, this.iMat, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFFFF),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Colors.white,
          width: AppTheme.paddingMedium,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image + Star
            // TOP: Image + Star → takes 2/3 of the available height
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1) Image fills the available space except room for the star
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                final detail = iMat.getDetailWithId(product.productId);
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (_) => ProductDetailDialog(
                                    product: product,
                                    detail: detail,
                                  ),
                                );
                              },
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: iMat.getImage(product),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ),
                  ),

                  // 2) Star sits *inside* this flex, at its bottom
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => iMat.toggleFavorite(product),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                size: 38,
                                color: iMat.isFavorite(product) ? Colors.amber : Colors.transparent,
                              ),
                              const Icon(Icons.star_border, size: 48, color: Colors.black),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            // Text and Button
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTheme.mediumHeading,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(2)} ${product.unit}',
                    style: AppTheme.mediumLargeHeading,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: SizedBox(
                      width: AppTheme.productCardButtonWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          final item = ShoppingItem(product); // 1.0 items by default
                          iMat.shoppingCartAdd(item);         // add to cart via backend
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.buttonColor2,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: const BorderSide(color: AppTheme.borderColor, width: 2),
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Välj",
                          style: AppTheme.mediumHeading
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}