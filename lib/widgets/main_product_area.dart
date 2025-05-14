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
        final crossAxisCount = (constraints.maxWidth / cardWidth).floor().clamp(1, 5);

        return SizedBox( // <-- constrain GridView to available width
          width: constraints.maxWidth,
          child: GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppTheme.paddingSmall,
              mainAxisSpacing: AppTheme.paddingSmall,
              childAspectRatio: 3 / 4,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(product, iMat);
            },
          ),
        );
      },
    );
  }
}
