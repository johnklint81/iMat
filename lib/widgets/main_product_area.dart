import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class MainProductArea extends StatelessWidget {
  const MainProductArea({super.key});
  

  @override
  Widget build(BuildContext context) {

    var iMat = Provider.of<ImatDataHandler>(context, listen: false);
    var products = iMat.selectProducts;

    return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingSmall),
              child: GridView.builder(
                itemCount: products.length,
                // This sets max cards to 4, regardless of width of screen.
                // We could change this to 5 if we wanted, it is also adaptive
                // for smaller screens
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: AppTheme.paddingSmall,
                  mainAxisSpacing: AppTheme.paddingSmall,
                  childAspectRatio: 3 / 4,
                ),

                  itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product, iMat);
                },
              ),
            ),
          );
  }
}