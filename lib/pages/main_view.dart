import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/main_product_area.dart';
import 'package:imat_app/widgets/search.dart';
import 'package:imat_app/widgets/shopping_cart_widget.dart';
import 'package:imat_app/widgets/account_view.dart';
import '../widgets/categories.dart';

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
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: Row(
          children: [
            const Text(
              "iMat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 20),
            const Expanded(child: Search()), // <-- use working search widget
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                setState(() {
                  showAccount = !showAccount;
                });
              },
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
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
              child: showAccount
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
