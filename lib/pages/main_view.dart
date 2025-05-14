import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/main_product_area.dart';
import 'package:imat_app/widgets/search.dart';
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
            const Expanded(child: Search()),
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

          // Main product area or account view
          Expanded(
            child: showAccount ? const AccountView() : const MainProductArea(),
          ),

          // Cart
          const ShoppingCartWidget(),
        ],
      ),
    );
  }
}
