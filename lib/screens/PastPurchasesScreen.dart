import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/Constants.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:grocery_bullet/widgets/CurrentLocationBuilder.dart';
import 'package:grocery_bullet/widgets/GroceryItem.dart';
import 'package:provider/provider.dart';

class PastPurchasesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return CurrentLocationBuilder(
      asyncWidgetBuilder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: kPrimaryColor,
          );
        }
        Location currentLocation = snapshot.data;
        List<GroceryItem> items = [];
        List<Item> pastPurchases = List.from(user.pastPurchases);
        pastPurchases.removeWhere((pastPurchase) => !currentLocation.grocery
            .any((groceryItem) =>
                pastPurchase.reference == groceryItem.reference));
        pastPurchases.sort((a, b) {
          return a.count - b.count;
        });
        for (Item item in pastPurchases) {
          GroceryItem groceryItem = GroceryItem(
            item: item,
            includeCountInfo: true,
            cardColor: kSecondaryColor,
          );
          items.add(groceryItem);
        }
        ListView pastPurchasesView = ListView(
          children: items,
        );
        return Scaffold(
            appBar: AppBar(
              title: Text('Past Purchases',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: kTextColor)),
              backgroundColor: kSecondaryColor,
            ),
            body: pastPurchases.length > 0
                ? pastPurchasesView
                : Center(
                    child: Text(
                    'You have not purchased any items available at this location!',
                    style: TextStyle(color: kTextColor),
                  )));
      },
    );
  }
}
