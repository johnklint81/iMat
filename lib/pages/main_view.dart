import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/main_product_area.dart';
import 'package:imat_app/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/shopping_cart_widget.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: Row(
          children: [
            // logo/title
            const Text(
                "iMat",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
            ),
            const SizedBox(width: 20),
            Search(),
            IconButton(
              icon: const Icon(Icons.person), // user/account
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Sidebar with categories
          Container(
            width: 250,
            color: AppTheme.backgroundColor,
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: [
                ListTile(title: Text('Frukt')),
                ListTile(title: Text('Grönsaker')),
                ListTile(title: Text('Mejeri')),
              ],
            ),
          ),
          // Main product area
          MainProductArea(),
          // Optional right-side cart panel
          const ShoppingCartWidget(),
        ],
      ),
    );
  }
}