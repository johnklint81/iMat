import 'dart:convert';
import 'package:imat_app/model/imat/shopping_item.dart';

class Order {
  int orderNumber;
  DateTime date;
  List<ShoppingItem> items;
  String? paymentMethod;
  String? deliveryOption;
  DateTime? deliveryDate;

  Order(
      this.orderNumber,
      this.date,
      this.items, {
        this.deliveryOption,
        this.deliveryDate,
        this.paymentMethod,
      });

  factory Order.fromJson(Map<String, dynamic> json) {
    final orderNumber = json[_orderNumber];
    final timeStamp = json[_date];
    final jsonItems = json[_items];

    if (orderNumber == null) {
      print("⚠️ orderNumber saknas i: $json");
    }
    if (timeStamp == null) {
      print("⚠️ date saknas i: $json");
    }
    if (jsonItems == null) {
      print("⚠️ items saknas i: $json");
    }

    if (orderNumber == null || timeStamp == null || jsonItems == null) {
      throw FormatException('Order JSON saknar obligatoriska fält');
    }

    final items = [
      for (final item in jsonItems) ShoppingItem.fromJson(item)
    ];

    final String? option = json[_deliveryOption];
    final int? deliveryEpoch = json[_deliveryDate];
    final String? payment = json[_paymentMethod];

    final DateTime? parsedDate = deliveryEpoch != null
        ? DateTime.fromMillisecondsSinceEpoch(deliveryEpoch)
        : null;

    return Order(
      orderNumber,
      DateTime.fromMillisecondsSinceEpoch(timeStamp),
      items,
      deliveryOption: option,
      deliveryDate: parsedDate,
      paymentMethod: payment,
    );
  }




  Map<String, dynamic> toJson() => {
    _orderNumber: orderNumber,
    _date: date.millisecondsSinceEpoch,
    _items: items.map((item) => item.toJson()).toList(),
    if (deliveryOption != null) _deliveryOption: deliveryOption,
    if (deliveryDate != null)
      _deliveryDate: deliveryDate!.millisecondsSinceEpoch,
    if (paymentMethod != null) _paymentMethod: paymentMethod,
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
  static const _paymentMethod = 'paymentMethod';
}
