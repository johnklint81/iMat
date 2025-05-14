import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/product.dart'; // Product class
import 'package:imat_app/model/imat_data_handler.dart';

import '../app_theme.dart';

class CategoryListItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  const CategoryListItem({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
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
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovering ? AppTheme.buttonColor2 : Colors.transparent,
            border: Border.all(
              color: _hovering ? Colors.black12 : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CategorySelector extends StatelessWidget {
  final VoidCallback? onCategorySelected;

  const CategorySelector({super.key, this.onCategorySelected});
  static const Map<ProductCategory, String> categoryLabels = {
    ProductCategory.MELONS: "Meloner",
    ProductCategory.FLOUR_SUGAR_SALT: "Mjöl, Socker & Salt",
    ProductCategory.MEAT: "Kött",
    ProductCategory.DAIRIES: "Mejeriprodukter",
    ProductCategory.VEGETABLE_FRUIT: "Grönsaker & Frukt",
    ProductCategory.CABBAGE: "Kål",
    ProductCategory.NUTS_AND_SEEDS: "Nötter & Frön",
    ProductCategory.PASTA: "Pasta",
    ProductCategory.POTATO_RICE: "Potatis & Ris",
    ProductCategory.ROOT_VEGETABLE: "Rotfrukter",
    ProductCategory.FRUIT: "Frukt",
    ProductCategory.SWEET: "Sötsaker",
    ProductCategory.HERB: "Örter",
    ProductCategory.POD: "Baljväxter",
    ProductCategory.BREAD: "Bröd",
    ProductCategory.BERRY: "Bär",
    ProductCategory.CITRUS_FRUIT: "Citrusfrukter",
    ProductCategory.HOT_DRINKS: "Varma drycker",
    ProductCategory.COLD_DRINKS: "Kalla drycker",
    ProductCategory.EXOTIC_FRUIT: "Exotisk frukt",
    ProductCategory.FISH: "Fisk",
  };

  @override
  Widget build(BuildContext context) {
    final handler = context.read<ImatDataHandler>();
    final products = handler.products;

    final categories = (products.isEmpty
        ? CategorySelector.categoryLabels.keys
        : products.map((p) => p.category)).toSet().toList()
      ..sort((a, b) => a.toString().compareTo(b.toString()));

    return ListView(
      children: [
        const Divider(color: Colors.black),
        const SizedBox(height: AppTheme.paddingTiny),
        CategoryListItem(
          label: "Hem",
          onTap: () {
            handler.selectAllProducts();
            onCategorySelected?.call(); // hide account view
          },
          icon: Icons.home,
        ),

        const SizedBox(height: AppTheme.paddingTiny),
        CategoryListItem(
          label: "Favoriter",
          onTap: () {
            handler.selectFavorites();
            onCategorySelected?.call();
          },
          icon: Icons.star,
        ),
        const Divider(color: Colors.black),
        const SizedBox(height: AppTheme.paddingTiny),
        CategoryListItem(
          label: "Alla Produkter",
          onTap: () {
            handler.selectAllProducts();
            onCategorySelected?.call();
          },
        ),

        const SizedBox(height: AppTheme.paddingTiny),
        ...categories.map((category) {
          final label = categoryLabels[category] ?? category.toString();
          return CategoryListItem(
            label: label,
            onTap: () {
              final filtered = products.where((p) => p.category == category).toList();
              handler.selectSelection(filtered);
              onCategorySelected?.call(); // 👈 hide account view
            },


          );
        }).toList(),
      ],
    );
  }





}
