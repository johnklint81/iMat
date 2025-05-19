
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/main_product_area.dart';
import 'package:imat_app/widgets/search.dart';
import 'package:imat_app/widgets/shopping_cart_widget.dart';
import 'package:imat_app/widgets/account_view.dart';
import 'package:imat_app/widgets/account_button.dart';
import 'package:imat_app/widgets/custom_app_bar.dart';
import 'package:imat_app/widgets/sub_category_bar.dart';
import 'package:imat_app/widgets/categories.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';

const Map<String, Map<String, List<ProductCategory>>> demoSubcategories = {
  'Grönt': {
    'Baljväxter': [ProductCategory.POD],
    'Grönsaksfrukter': [ProductCategory.VEGETABLE_FRUIT],
    'Kål': [ProductCategory.CABBAGE],
    'Rotfrukter': [ProductCategory.ROOT_VEGETABLE],
    'Örtkryddor': [ProductCategory.HERB],
  },
  'Frukt': {
    'Bär': [ProductCategory.BERRY],
    'Citrusfrukter': [ProductCategory.CITRUS_FRUIT],
    'Exotiska frukter': [ProductCategory.EXOTIC_FRUIT],
    'Meloner': [ProductCategory.MELONS],
    'Stenfrukter': [ProductCategory.FRUIT], // kept since it maps uniquely
  },
  'Mejeriprodukter': {
    'Mejerivaror': [ProductCategory.DAIRIES], // merged mjölk, ost, ägg → all same category
  },
  'Fisk': {
    'Fisk': [ProductCategory.FISH], // merged färsk + konserverad (same enum)
  },
  'Bröd & Pasta': {
    'Bröd': [ProductCategory.BREAD],
    'Pasta': [ProductCategory.PASTA],
  },
  'Potatis & Ris': {
    'Potatis och ris': [ProductCategory.POTATO_RICE], // one backend category
  },
  'Nötter & Sötsaker': {
    'Nötter': [ProductCategory.NUTS_AND_SEEDS],
    'Godis': [ProductCategory.SWEET], // we'll keep just 'Godis' and remove 'Choklad'
  },
  'Drycker': {
    'Varma drycker': [ProductCategory.HOT_DRINKS],
    'Kalla drycker': [ProductCategory.COLD_DRINKS],
  },
  'Mjöl, socker & salt': {
    'Mjöl, socker & salt': [ProductCategory.FLOUR_SUGAR_SALT], // one enum
  },
};



class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool showAccount = false;
  String? selectedCategory;
  String? selectedSubcategory;

  List<String> get currentSubcategories =>
      selectedCategory != null ? demoSubcategories[selectedCategory!]!.keys.toList() : [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        centerWidget: const Search(),
        rightWidget: AccountButton(
          isActive: showAccount,
          onPressed: () => setState(() => showAccount = !showAccount),
        ),
        onTitleTap: () {
          setState(() {
            showAccount = false;
            selectedCategory = null;
          });
          context.read<ImatDataHandler>().selectAllProducts();
        },
      ),
      body: Row(
        children: [
          Container(
            width: 300,
            color: AppTheme.backgroundColor,
            padding: const EdgeInsets.all(8),
            child: CategorySelector(
              onCategorySelected: (String? cat) {
                setState(() {
                  selectedCategory = cat;
                  selectedSubcategory = null;
                  if (cat != null) {
                    final allCats = demoSubcategories[cat]!.values.expand((e) => e).toList();
                    final products = context.read<ImatDataHandler>().products;
                    final filtered = products.where((p) => allCats.contains(p.category)).toList();
                    context.read<ImatDataHandler>().selectSelection(filtered);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (selectedCategory != null)
                  SubcategoryBar(
                    subcategories: currentSubcategories,
                    selectedSubcategory: selectedSubcategory,
                    onTap: (sub) {
                      setState(() => selectedSubcategory = sub);
                      final cats = demoSubcategories[selectedCategory!]![sub]!;
                      final products = context.read<ImatDataHandler>().products;
                      final filtered = products.where((p) => cats.contains(p.category)).toList();
                      context.read<ImatDataHandler>().selectSelection(filtered);
                    },
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.paddingSmall),
                    child: showAccount ? const AccountView() : const MainProductArea(),
                  ),
                ),
              ],
            ),
          ),
          const ShoppingCartWidget(),
        ],
      ),
    );
  }
}