import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';

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
          width: AppTheme.paddingMediumSmall,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image + Star
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: iMat.getImage(product),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: GestureDetector(
                      onTap: () => iMat.toggleFavorite(product),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.star_border, size: 40, color: Colors.black), // outline
                          Icon(
                            Icons.star,
                            size: 24,
                            color: iMat.isFavorite(product) ? Colors.amber : Colors.transparent,
                          ),
                        ],
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
                    style: AppTheme.smallHeading,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(2)} ${product.unit}',
                    style: AppTheme.mediumHeading,
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
