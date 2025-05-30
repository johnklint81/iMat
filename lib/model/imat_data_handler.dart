import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/product_detail.dart';
import 'package:imat_app/model/imat/settings.dart';
import 'package:imat_app/model/imat/shopping_cart.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat/user.dart';
import 'package:imat_app/model/internet_handler.dart';

class ImatDataHandler extends ChangeNotifier {
  ImatDataHandler() {
    _setUp();
  }

  String paymentMethod = 'card';
  String deliveryOption = 'asap';
  DateTime? deliveryDate;

  void setPaymentMethod(String method) {
    paymentMethod = method;
    notifyListeners();
  }
  void selectAllProducts() {
    _selectProducts.clear();
    _selectProducts.addAll(_products);
    notifyListeners();
  }

  void selectFavorites() {
    _selectProducts.clear();
    _selectProducts.addAll(favorites);
    notifyListeners();
  }

  void selectSelection(List<Product> selection) {
    _selectProducts.clear();
    _selectProducts.addAll(selection);
    notifyListeners();
  }

  List<Product> findProducts(String search) {
    final lowerSearch = search.toLowerCase();
    return products.where((product) => product.name.toLowerCase().contains(lowerSearch)).toList();
  }

  void setDelivery(String option, DateTime? date) {
    deliveryOption = option;
    deliveryDate = date;
    notifyListeners();
  }

  String get deliveryDescription {
    switch (deliveryOption) {
      case 'asap':
        return 'Så fort som möjligt';
      case 'pickup':
        return 'Hämta vid utlämning';
      case 'date':
        if (deliveryDate != null) {
          final local = deliveryDate!.toLocal();
          final date = '${local.year}-${_twoDigits(local.month)}-${_twoDigits(local.day)}';
          final time = '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
          return '$date';
        } else {
          return 'På ett specifikt datum';
        }
      default:
        return 'Så fort som möjligt';
    }
  }

  String _twoDigits(int n) => n < 10 ? '0$n' : '$n';

  List<Product> get products => _products;
  List<ProductDetail> get details => _details;
  List<Order> get orders => _orders;
  List<Product> get selectProducts => _selectProducts;
  List<Product> get favorites => _favorites.values.toList();

  bool isFavorite(Product product) => _favorites.containsKey(product.productId);

  void toggleFavorite(Product product) {
    final pid = product.productId;
    if (_favorites.containsKey(pid)) {
      _favorites.remove(pid);
      _removeFavorite(product);
    } else {
      _favorites[pid] = product;
      _addFavorite(product);
    }
  }

  CreditCard getCreditCard() => _creditCard;

  void setCreditCard(CreditCard card) async {
    _creditCard = card;
    await InternetHandler.setCreditCard(_creditCard);
    notifyListeners();
  }

  Customer getCustomer() => _customer;

  Future<void> setCustomer(Customer customer) async {
    _customer = customer;
    await InternetHandler.setCustomer(_customer);
    notifyListeners();
  }

  User getUser() => _user;

  void setUser(User user) async {
    _user = user;
    await InternetHandler.setUser(_user);
    notifyListeners();
  }

  ProductDetail? getDetail(Product p) => getDetailWithId(p.productId);

  ProductDetail? getDetailWithId(int idNbr) {
    try {
      return _details.firstWhere((d) => d.productId == idNbr);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> getExtras() => _extras;

  void addExtra(String key, dynamic jsonData) {
    _extras[key] = jsonData;
    setExtras(_extras);
  }

  void removeExtra(String key) {
    _extras.remove(key);
    setExtras(_extras);
  }

  void setExtras(Map<String, dynamic> extras) async {
    await InternetHandler.setExtras(extras);
    notifyListeners();
  }

  Image getImage(Product p) {
    final url = InternetHandler.getImageUrl(p.productId);
    final image = _getImage(url);
    return image ?? Image.asset('assets/images/placeholder.png');
  }

  Uint8List? getImageData(Product p) {
    final url = InternetHandler.getImageUrl(p.productId);
    return _getImageData(url);
  }

  ShoppingCart getShoppingCart() => _shoppingCart;

  void shoppingCartAdd(ShoppingItem item) {
    _shoppingCart.addItem(item);
    setShoppingCart();
  }

  void shoppingCartUpdate(ShoppingItem item, {double delta = 0.0}) {
    _shoppingCart.updateItem(item, delta: delta);
    setShoppingCart();
  }

  void shoppingCartRemove(ShoppingItem item) {
    _shoppingCart.removeItem(item);
    setShoppingCart();
  }

  void shoppingCartClear() {
    _shoppingCart.clear();
    setShoppingCart();
  }

  double shoppingCartTotal() {
    return _shoppingCart.items.fold(0, (sum, item) => sum + item.amount * item.product.price);
  }

  void setShoppingCart() async {
    await InternetHandler.setShoppingCart(_shoppingCart);
    notifyListeners();
  }

  Future<void> placeOrder() async {
    await InternetHandler.placeOrder();
    _shoppingCart.clear();
    notifyListeners();

    var response = await InternetHandler.getOrders();
    var jsonData = jsonDecode(response) as List;

    _orders.clear();
    _orders.addAll(jsonData.map((item) => Order.fromJson(item)).toList());

    final lastOrder = _orders.reduce((a, b) => a.date.isAfter(b.date) ? a : b);

    final key = 'delivery_order_${lastOrder.orderNumber}';
    _extras[key] = {
      'option': deliveryOption,
      'date': deliveryDate?.millisecondsSinceEpoch,
      'payment': paymentMethod,
    };

    await InternetHandler.setExtras(_extras);

    for (final order in _orders) {
      final k = 'delivery_order_${order.orderNumber}';
      if (_extras.containsKey(k)) {
        final data = _extras[k];
        order.deliveryOption = data['option'] ?? order.deliveryOption;
        order.paymentMethod = data['payment'] ?? order.paymentMethod;
        if (data['date'] != null) {
          order.deliveryDate = DateTime.fromMillisecondsSinceEpoch(data['date']);
        }
      }
    }

    notifyListeners();
  }

  void reset() async {
    await InternetHandler.reset();
    _favorites.clear();
    _orders.clear();

    _creditCard = CreditCard.fromJson(jsonDecode(await InternetHandler.getCreditCard()));
    _customer = Customer.fromJson(jsonDecode(await InternetHandler.getCustomer()));
    _user = User.fromJson(jsonDecode(await InternetHandler.getUser()));
    _shoppingCart = ShoppingCart.fromJson(jsonDecode(await InternetHandler.getShoppingCart()));
    _extras = jsonDecode(await InternetHandler.getExtras());

    notifyListeners();
  }

  void _addFavorite(Product p) async {
    await InternetHandler.addFavorite(p.productId);
    notifyListeners();
  }

  void _removeFavorite(Product p) async {
    await InternetHandler.removeFavorite(p.productId);
    notifyListeners();
  }

  final List<Product> _products = [];
  final List<Product> _selectProducts = [];
  final List<ProductDetail> _details = [];
  final Map<int, Product> _favorites = {};
  User _user = User('', '');
  Customer _customer = Customer('', '', '', '', '', '', '', '');
  CreditCard _creditCard = CreditCard('', '', 12, 25, '', 0);
  ShoppingCart _shoppingCart = ShoppingCart([]);
  final List<Order> _orders = [];
  Map<String, dynamic> _extras = {};

  final Map<String, Uint8List> _imageData = {};
  final Set<String> _loadingUrls = {};
  final Queue<String> _queue = Queue();
  final int maxConcurrentRequests = 5;
  int _currentRequests = 0;

  Uint8List? _getImageData(String url) {
    _triggerLoadIfNeeded(url);
    return _imageData[url];
  }

  Image? _getImage(String url, {BoxFit fit = BoxFit.cover}) {
    final bytes = _getImageData(url);
    return bytes != null ? Image.memory(bytes, fit: fit) : null;
  }

  void _triggerLoadIfNeeded(String url) {
    if (_imageData.containsKey(url) || _loadingUrls.contains(url) || _queue.contains(url)) return;
    _queue.add(url);
    _tryNext();
  }

  void _tryNext() {
    if (_currentRequests >= maxConcurrentRequests || _queue.isEmpty) return;
    final url = _queue.removeFirst();
    _loadingUrls.add(url);
    _currentRequests++;
    _fetch(url).whenComplete(() {
      _loadingUrls.remove(url);
      _currentRequests--;
      _tryNext();
    });
  }

  Future<void> _fetch(String url) async {
    try {
      final response = await http.get(Uri.parse(url), headers: InternetHandler.apiKeyHeader);
      if (response.statusCode == 200) {
        _imageData[url] = response.bodyBytes;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching $url: $e');
    }
  }

  void _setUp() async {
    InternetHandler.kGroupId = Settings.groupId;

    var response = await InternetHandler.getProducts();
    var jsonData = jsonDecode(response) as List;
    _products.addAll(jsonData.map((item) => Product.fromJson(item)));

    _selectProducts.clear();
    _selectProducts.addAll(_products);

    response = await InternetHandler.getDetails();
    jsonData = jsonDecode(response);
    _details.addAll(jsonData.map((item) => ProductDetail.fromJson(item)));

    response = await InternetHandler.getFavorites();
    jsonData = jsonDecode(response);
    for (final product in jsonData.map((item) => Product.fromJson(item))) {
      _favorites[product.productId] = product;
    }

    _creditCard = CreditCard.fromJson(jsonDecode(await InternetHandler.getCreditCard()));
    _customer = Customer.fromJson(jsonDecode(await InternetHandler.getCustomer()));
    _user = User.fromJson(jsonDecode(await InternetHandler.getUser()));

    response = await InternetHandler.getExtras();
    _extras = jsonDecode(response);

    response = await InternetHandler.getOrders();
    jsonData = jsonDecode(response);
    _orders.addAll(jsonData.map((item) {
      final order = Order.fromJson(item);
      final key = 'delivery_order_${order.orderNumber}';
      if (_extras.containsKey(key)) {
        final data = _extras[key];
        order.deliveryOption = data['option'] ?? order.deliveryOption;
        order.paymentMethod = data['payment'] ?? order.paymentMethod;
        if (data['date'] != null) {
          order.deliveryDate = DateTime.fromMillisecondsSinceEpoch(data['date']);
        }
      }
      return order;
    }));

    _shoppingCart = ShoppingCart.fromJson(jsonDecode(await InternetHandler.getShoppingCart()));

    notifyListeners();
  }
}
