import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/main_product_area.dart';
import 'package:imat_app/widgets/search.dart';
import 'package:imat_app/widgets/shopping_cart_widget.dart';
import 'package:imat_app/widgets/account_view.dart';
import '../model/imat_data_handler.dart';
import '../widgets/account_button.dart';
import '../widgets/categories.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool showAccount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerWidget: const Search(),

        rightWidget: AccountButton(
          isActive: showAccount,
          onPressed: () {
            setState(() {
              showAccount = !showAccount;
            });
          },
        ),

        onTitleTap: () {
          setState(() {
            showAccount = false;
          });
          final iMat = Provider.of<ImatDataHandler>(context, listen: false);
          iMat.selectAllProducts();
        },
      ),

      body: Row(
        children: [
          // Sidebar
          Container(
            width: 300,
            color: AppTheme.backgroundColor,
            padding: const EdgeInsets.all(8),
            child: CategorySelector(
              onCategorySelected: () {
                setState(() {
                  showAccount = false;
                });
              },
            ),
          ),

          // Middle area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingSmall),
              // Switch between AccountView or the product grid
              child:
                  showAccount
                      // don't use const if AccountView watches Provider
                      ? AccountView()
                      // same for MainProductArea
                      : MainProductArea(),
            ),
          ),

          // Cart
          const ShoppingCartWidget(),
        ],
      ),
    );
  }
}
