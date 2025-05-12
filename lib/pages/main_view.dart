import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/login.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/widgets/searching_bar.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    // Det finns en version utan gridDelegate nedan.
    // Den kan vara enklare att förstå.
    // Denna version har fördelen att kort skapas on-demand.
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 245, 213),
      appBar: AppBar(
        title: Text('iMat', style: TextStyle(fontSize: 50),),
        shape: Border(bottom: BorderSide(color: Colors.black)),
        actions: [
          Padding(
          padding: const EdgeInsets.only(right: 400.0),
          child: SearchingBar(),
          ),
          SizedBox(width: 40, child: Icon(Icons.shopping_cart)), 
          Login()],
        backgroundColor: Color.fromARGB(255, 255, 234, 164),
        toolbarHeight: 80,
        
      ),
      body: Row(
        children: [
          Column(children: [Placeholder(fallbackHeight: 900, fallbackWidth: 200,)],),
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 kolumner
                crossAxisSpacing: AppTheme.paddingSmall,
                mainAxisSpacing: AppTheme.paddingSmall,
                childAspectRatio: 4 / 3,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
          
                return ProductCard(product, iMat);
              },
            ),
          ),
        ],
      ),
    );

    /*
    return Scaffold(
      appBar: AppBar(title: Text('iMats produkter')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 4, //  4 kolumner
          crossAxisSpacing: 8, //  horisontellt mellanrum
          mainAxisSpacing: 8, //  vertikalt mellanrum
          childAspectRatio: 4 / 3, //  bredd/höjd-förhållande
          children:
              products.map((product) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: iMat.getImage(product)),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${product.price.toStringAsFixed(2)}kr',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );*/
  }
}