import 'dart:convert';
import 'package:imat_app/model/imat/shopping_item.dart';

class Order {
  int orderNumber;
  DateTime date;
  List<ShoppingItem> items;

  String? deliveryOption;
  DateTime? deliveryDate;

  Order(
      this.orderNumber,
      this.date,
      this.items, {
        this.deliveryOption,
        this.deliveryDate,
      });

  factory Order.fromJson(Map<String, dynamic> json) {
    int orderNumber = json[_orderNumber] as int;
    int timeStamp = json[_date] as int;
    List jsonItems = json[_items];

    List<ShoppingItem> items = [];
    for (final item in jsonItems) {
      items.add(ShoppingItem.fromJson(item));
    }

    // Hämta leveransval och datum om det finns
    String? option = json[_deliveryOption];
    String? dateStr = json[_deliveryDate];
    DateTime? parsedDate = dateStr != null ? DateTime.tryParse(dateStr) : null;

    return Order(
      orderNumber,
      DateTime.fromMillisecondsSinceEpoch(timeStamp),
      items,
      deliveryOption: option,
      deliveryDate: parsedDate,
    );
  }

  Map<String, dynamic> toJson() => {
    _orderNumber: orderNumber,
    _date: date.millisecondsSinceEpoch,
    _items: items.map((item) => item.toJson()).toList(),
    _deliveryOption: deliveryOption,
    _deliveryDate: deliveryDate?.toIso8601String(),
  };

  double getTotal() {
    double total = 0;
    for (final item in items) {
      total += item.product.price * item.amount;
    }
    return total;
  }

  static const _orderNumber = 'orderNumber';
  static const _date = 'date';
  static const _items = 'items';
  static const _deliveryOption = 'deliveryOption';
  static const _deliveryDate = 'deliveryDate';
}
