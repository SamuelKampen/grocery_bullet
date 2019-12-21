import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_bullet/models/item.dart';

// TODO The code in this file is an unmaintainable disaster times a million

class CartModel extends ChangeNotifier {
  List<Item> _items;

  /// If [previous] is not `null`, its items are copied to the newly
  /// constructed instance.
  CartModel(CartModel previous) : _items = previous?._items ?? new List();

  /// An empty cart with no Catalog.
  CartModel.empty() : _items = new List();

  /// List of items in the cart.
  HashMap<String, int> getItemCounts() {
    HashMap<String, int> itemCounts = new HashMap();
    for (Item item in _items) {
      if (itemCounts.containsKey(item.name)) {
        itemCounts[item.name] += 1;
      } else {
        itemCounts[item.name] = 1;
      }
    }
    return itemCounts;
  }

  List<Item> getItems() => _items;

  /// The current total price of all items.
  double getTotalPrice() {
    double totalPrice = 0.0;
    for (Item item in _items) totalPrice += item.price;
    return totalPrice;
  }

  void add(DocumentSnapshot document) {
    _items.add(Item.fromSnapshot(document));
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  int getItemCount(DocumentSnapshot document) {
    int count = 0;
    for (Item item in _items) {
      if (document['name'] == item.name) count++;
    }
    return count;
  }

  /// Removes one instance of [item] from cart if at least one exists.
  /// Does nothing if item is not in cart.
  void remove(DocumentSnapshot document) {
    int index = 0;
    for (Item item in _items) {
      if (document['name'] == item.name) break;
      index++;
    }
    if (index < _items.length && _items[index].name == document['name']) {
      _items.removeAt(index);
    }
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void resetCart() {
    _items = new List();
    notifyListeners();
  }
}
