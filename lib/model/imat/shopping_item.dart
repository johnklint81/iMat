import 'package:imat_app/model/imat/product.dart';

class ShoppingItem {
  Product product;
  double amount;

  ShoppingItem(this.product, {this.amount = 1.0});

  double get total => product.price * amount;

  ShoppingItem.fromJson(Map<String, dynamic> json)
      : product = Product.fromJson(json[_product]),
        amount = json[_amount];

  Map<String, dynamic> toJson() => {
    _product: product.toJson(),
    _amount: amount,
  };

  // ✅ Lägg till denna metod:
  ShoppingItem copyWith({Product? product, double? amount}) {
    return ShoppingItem(
      product ?? this.product,
      amount: amount ?? this.amount,
    );
  }

  static const _product = 'product';
  static const _amount = 'amount';
}

