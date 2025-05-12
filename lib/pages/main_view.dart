import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFEECE),
        title: Row(
          children: [
            const Text('iMat'), // logo/title
            const SizedBox(width: 20),
            Expanded(
              child: TextField( // search
                decoration: InputDecoration(
                  hintText: 'Sök produkter...',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person), // user/account
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart), // cart
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
            color: Color(0xFFFFEECE),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.paddingSmall),
              child: GridView.builder(
                itemCount: products.length,
                // This sets max cards to 4, regardless of width of screen.
                // We could change this to 5 if we wanted, it is also adaptive
                // for smaller screens
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
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
          // Optional right-side cart panel
          Container(
            width: 250,
            color: Color(0xFFFFEECE),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: const [
                Text('Kundvagn'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}