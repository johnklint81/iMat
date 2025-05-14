import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';
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
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

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
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Sök produkter...',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
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
            child: const CategorySelector(),
          ),


          // Middle area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingSmall),
              child: showAccount
                  ? const AccountView()
                  : GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
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
          ),

          // Cart
          const ShoppingCartWidget(),
        ],
      ),
    );
  }
}
