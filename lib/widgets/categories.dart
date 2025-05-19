import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class CategoryListItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? backgroundColor;
  final bool bordered;

  const CategoryListItem({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.backgroundColor,
    this.bordered = false,
  });

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Material(
        color: _hovering
            ? AppTheme.buttonColor2
            : (widget.backgroundColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            decoration: widget.bordered
                ? BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(6),
            )
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 32),
                  const SizedBox(width: 8),
                ],
                Text(widget.label, style: AppTheme.mediumHeading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategorySelector extends StatelessWidget {
  final void Function(String? category)? onCategorySelected;

  const CategorySelector({super.key, this.onCategorySelected});

  static const Map<String, List<ProductCategory>> groupedCategories = {
    'Grönt': [
      ProductCategory.VEGETABLE_FRUIT,
      ProductCategory.ROOT_VEGETABLE,
      ProductCategory.CABBAGE,
      ProductCategory.HERB,
      ProductCategory.POD
    ],
    'Frukt': [
      ProductCategory.FRUIT,
      ProductCategory.BERRY,
      ProductCategory.CITRUS_FRUIT,
      ProductCategory.EXOTIC_FRUIT,
      ProductCategory.MELONS
    ],
    'Mejeriprodukter': [ProductCategory.DAIRIES],
    'Fisk': [ProductCategory.FISH],
    'Bröd & Pasta': [ProductCategory.BREAD, ProductCategory.PASTA],
    'Potatis & Ris': [ProductCategory.POTATO_RICE],
    'Nötter & Sötsaker': [ProductCategory.NUTS_AND_SEEDS, ProductCategory.SWEET],
    'Drycker': [ProductCategory.HOT_DRINKS, ProductCategory.COLD_DRINKS],
    'Mjöl, socker & salt': [ProductCategory.FLOUR_SUGAR_SALT],
  };

  @override
  Widget build(BuildContext context) {
    final handler = context.read<ImatDataHandler>();
    final products = handler.products;

    return ListView(
      children: [
        const SizedBox(height: AppTheme.paddingTiny),

        CategoryListItem(
          label: "Hem",
          icon: Icons.home,
          bordered: true,
          backgroundColor: AppTheme.buttonColor3,
          onTap: () {
            handler.selectAllProducts();
            onCategorySelected?.call(null);
          },
        ),

        const SizedBox(height: AppTheme.paddingTiny),

        CategoryListItem(
          label: "Favoriter",
          icon: Icons.star,
          bordered: true,
          backgroundColor: AppTheme.buttonColor3,
          onTap: () {
            handler.selectFavorites();
            onCategorySelected?.call(null);
          },
        ),

        const Divider(color: Colors.black),
        const SizedBox(height: AppTheme.paddingTiny),

        CategoryListItem(
          label: "Alla Produkter",
          onTap: () {
            handler.selectAllProducts();
            onCategorySelected?.call(null);
          },
        ),

        const SizedBox(height: AppTheme.paddingTiny),

        for (final entry in groupedCategories.entries)
          CategoryListItem(
            label: entry.key,
            onTap: () {
              final filtered = products
                  .where((p) => entry.value.contains(p.category))
                  .toList();
              handler.selectSelection(filtered);
              onCategorySelected?.call(entry.key);
            },
          ),
      ],
    );
  }
}
