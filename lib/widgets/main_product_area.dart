import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class MainProductArea extends StatelessWidget {
  const MainProductArea({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final products = iMat.selectProducts;

    return LayoutBuilder(
      builder: (context, constraints) {
        const cardWidth = 200.0;
        final crossAxisCount = (constraints.maxWidth / cardWidth).floor().clamp(
          1,
          4,
        );

        return SizedBox(
          width: constraints.maxWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.paddingLARGE, // left
              AppTheme.paddingTiny, // top
              AppTheme.paddingLARGE, // right
              AppTheme.paddingLARGE, // bottom
            ),
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppTheme.paddingLARGE,
                mainAxisSpacing: AppTheme.paddingLARGE,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(product, iMat);
              },
            ),
          ),
        );
      },
    );
  }
}
