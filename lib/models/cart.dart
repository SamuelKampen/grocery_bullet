import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_bullet/models/grocery.dart';

// TODO The code in this file is an unmaintainable disaster times a million

class CartModel extends ChangeNotifier {
  /// The current catalog. Used to construct items from numeric ids.
  final GroceryModel _catalog;

  // Map that maps itemId -> itemCount in cart
  List<DocumentSnapshot> _documents;

  /// Construct a CartModel instance that is backed by a [GroceryModel] and
  /// an optional previous state of the cart.
  ///
  /// If [previous] is not `null`, its items are copied to the newly
  /// constructed instance.
  CartModel(this._catalog, CartModel previous)
      : assert(_catalog != null),
        _documents = previous?._documents ?? new List();

  /// An empty cart with no Catalog.
  CartModel.empty()
      : _catalog = null,
        _documents = new List();

  /// List of items in the cart.
  HashMap<String, int> getItemCounts() {
    HashMap<String, int> itemCounts = new HashMap();
    for (DocumentSnapshot document in _documents) {
      if (itemCounts.containsKey(document['name'])) {
        itemCounts[document['name']] += 1;
      } else {
        itemCounts[document['name']] = 1;
      }
    }
    return itemCounts;
  }

  /// The current total price of all items.
  double getTotalPrice() {
    double totalPrice = 0.0;
    for (DocumentSnapshot document in _documents)
      totalPrice += document['price'];
    return totalPrice;
  }

  /// Adds [item] to cart.
  void add(DocumentSnapshot document) {
    _documents.add(document);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  /// Returns the count of [item] int the cart
  int getItemCount(DocumentSnapshot document) {
    int count = 0;
    for (DocumentSnapshot documentSnapshot in _documents) {
      if (documentSnapshot['name'] == document['name']) count++;
    }
    return count;
  }

  /// Removes one instance of [item] from cart if at least one exists.
  /// Does nothing if item is not in cart.
  void remove(DocumentSnapshot document) {
    int index = 0;
    for (DocumentSnapshot documentSnapshot in _documents) {
      if (documentSnapshot['name'] == document['name']) break;
      index++;
    }
    if (index < _documents.length &&
        _documents[index]['name'] == document['name']) {
      _documents.removeAt(index);
    }
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }
}
