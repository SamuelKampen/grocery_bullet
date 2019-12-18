import 'package:flutter/material.dart';

/// A proxy of the catalog of items the user can buy.
///
/// In a real app, this might be backed by a backend and cached on device.
/// In this sample app, the catalog is procedurally generated and infinite.
///
/// For simplicity, the catalog is expected to be immutable (no products are
/// expected to be added, removed or changed during the execution of the app).
class GroceryModel {
  static const _itemNames = [
    'Milk',
    'Soda',
    'Water',
    'Smoothies',
    'Eggs',
    'Bread',
    'Oranges',
    'Apples',
    'Tomatoes',
    'Frozen Food',
    'Toilet Paper',
    'Tampons',
    'Condoms',
    'Coffee',
    'Tea',
    'Candles',
    'Malls',
    'Packages',
    'Food Delivery',
  ];

  // TODO Names and Prices should be in a Map together
  static const _itemPrices = [
    2.50,
    1.00,
    1.00,
    3.75,
    2.00,
    1.00,
    0.50,
    0.50,
    0.50,
    5.00,
    1.00,
    10.00,
    15.50,
    1.00,
    1.00,
    0.25,
    3.70,
    10.00,
    25.00,
  ];

  Item getById(int id) => Item(id, _itemNames[id], _itemPrices[id]);

  /// Get item by its position in the catalog.
  Item getByPosition(int position) {
    // In this simplified case, an item's position in the catalog
    // is also its id.
    return getById(position);
  }

  int getCatalogSize() {
    return _itemNames.length;
  }
}

@immutable
class Item {
  final int id;
  final String name;
  final Color color;
  final double price;

  Item(this.id, this.name, this.price)
  // To make the sample app look nicer, each item is given one of the
  // Material Design primary colors.
      : color = Colors.primaries[id % Colors.primaries.length];

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}