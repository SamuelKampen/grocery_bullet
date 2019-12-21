import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:grocery_bullet/models/item.dart';

class CartModel extends ChangeNotifier {
  // Map that represents the current cart.
  // Maps (Item -> count of Item in cart).
  Map<Item, int> _cart;

  /// If [previous] is not `null`, its items are copied to the newly
  /// constructed instance.
  CartModel(CartModel previous) : _cart = previous?._cart ?? new HashMap();

  /// An empty cart
  CartModel.empty() : _cart = new HashMap();

  HashMap<Item, int> getCart() {
    return _cart;
  }

  /// The current total price of all items.
  double getTotalPrice() {
    double totalPrice = 0.0;
    for (Item item in _cart.keys) {
      totalPrice += (item.price * _cart[item]);
    }
    return totalPrice;
  }

  void add(Item item) {
    _cart.update(item, (oldCount) => oldCount + 1, ifAbsent: () => 1);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  int getItemCount(Item item) {
    return _cart.containsKey(item) ? _cart[item] : 0;
  }

  /// Removes one instance of [item] from cart if at least one exists.
  /// Does nothing if item is not in cart.
  void remove(Item item) {
    _cart.update(item, (oldCount) => oldCount - 1, ifAbsent: () => 0);
    if (_cart[item] <= 0) {
      _cart.remove(item);
    }
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void resetCart() {
    _cart = new HashMap();
    notifyListeners();
  }
}
