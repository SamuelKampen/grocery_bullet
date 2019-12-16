import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:grocery_bullet/models/catalog.dart';

class CartModel extends ChangeNotifier {
  /// The current catalog. Used to construct items from numeric ids.
  final CatalogModel _catalog;

  // Map that maps itemId -> itemCount in cart
  final Map<int, int> _itemCountMap;

  /// Construct a CartModel instance that is backed by a [CatalogModel] and
  /// an optional previous state of the cart.
  ///
  /// If [previous] is not `null`, its items are copied to the newly
  /// constructed instance.
  CartModel(this._catalog, CartModel previous)
      : assert(_catalog != null),
        _itemCountMap = previous?._itemCountMap ?? new HashMap();

  /// An empty cart with no Catalog.
  CartModel.empty()
      : _catalog = null,
        _itemCountMap = new HashMap();

  /// List of items in the cart.
  List<Item> get() {
   List<Item> itemList = new List();
   for (int id in _itemCountMap.keys) {
     itemList.add(_catalog.getById(id));
   }
   return itemList;
  }

  /// The current total price of all items.
  double getTotalPrice() {
    double totalPrice = 0.0;
    _itemCountMap.forEach((k,v) => totalPrice += _catalog.getById(k).price * v);
    return totalPrice;
  }

  Item getItem(int key) => _catalog.getById(_itemCountMap[key]);

  /// The count of unique items in the cart
  int getUniqueItemCount() => _itemCountMap.keys.length;

  /// Adds [item] to cart.
  void add(Item item) {
    if (_itemCountMap.containsKey(item.id)) {
      _itemCountMap[item.id] = _itemCountMap[item.id] + 1;
    } else {
      _itemCountMap[item.id] = 1;
    }
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  /// Returns the count of [item] int the cart
  int getItemCount(Item item) {
    if (_itemCountMap.containsKey(item.id)) {
      return _itemCountMap[item.id];
    }
    return 0;
  }

  /// Removes one instance of [item] from cart if at least one exists.
  /// Does nothing if item is not in cart.
  void remove(Item item) {
    if (_itemCountMap.containsKey(item.id)) {
      _itemCountMap[item.id] = _itemCountMap[item.id] - 1;
      if (_itemCountMap[item.id] == 0) {
        _itemCountMap.remove(item.id);
      }
    }
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }
}