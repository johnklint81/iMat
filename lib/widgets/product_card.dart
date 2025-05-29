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
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Product image with hover + click
                  Expanded(
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
                ],
              ),
            ),

            // Text and Button
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
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
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Text(
                                  product.name,
                                  style: AppTheme.largeHeading,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),
                            Text(
                              '${product.price.toStringAsFixed(2)} ${product.unit}',
                              style: AppTheme.mediumLargeHeading,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => iMat.toggleFavorite(product),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                size: 42,
                                color: iMat.isFavorite(product) ? Colors.amber : Colors.transparent,
                              ),
                              const Icon(Icons.star_border, size: 44, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: SizedBox(
                      width: AppTheme.productCardButtonWidth,
                      child: ElevatedButton(
                        onPressed: () {
                          final item = ShoppingItem(product);
                          iMat.shoppingCartAdd(item);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(AppTheme.buttonColor2),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.25)), // stronger splash
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          side: MaterialStateProperty.all(const BorderSide(color: AppTheme.borderColor, width: 2)),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),


                        child: Text(
                          "Välj",
                          style: AppTheme.mediumLargeHeading.copyWith(color: Colors.white),
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
