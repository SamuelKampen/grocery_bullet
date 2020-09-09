import 'package:flutter/material.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:grocery_bullet/widgets/GroceryItem.dart';
import 'package:provider/provider.dart';

class PastPurchasesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Location currentLocation =
        Provider.of<CurrentLocation>(context).getCurrentLocation();
    List<GroceryItem> items = [];
    List<Item> pastPurchases = user.pastPurchases;
    pastPurchases.removeWhere((pastPurchase) => !currentLocation.grocery
        .any((groceryItem) => pastPurchase.reference == groceryItem.reference));
    pastPurchases.sort((a, b) {
      return a.count - b.count;
    });
    for (Item item in pastPurchases) {
      GroceryItem groceryItem = GroceryItem(
        item: item,
        includeCountInfo: true,
      );
      items.add(groceryItem);
    }
    ListView pastPurchasesView = ListView(
      children: items,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Past Purchases',
              style: Theme.of(context).textTheme.display4),
          backgroundColor: Colors.indigoAccent,
        ),
        body: pastPurchases.length > 0
            ? pastPurchasesView
            : Center(child: Text('You have not purchased any items!')));
  }
}
