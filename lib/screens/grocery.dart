import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_bullet/common/utils.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/widgets/GroceryItem.dart';
import 'package:provider/provider.dart';

class Grocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Location currentLocation =
        Provider.of<CurrentLocation>(context).getCurrentLocation();
    Map<String, List<Widget>> categorizedItems = {};
    for (Item item in currentLocation.grocery) {
      if (item.count <= 0) {
        continue;
      }
      GroceryItem groceryItem = GroceryItem(item: item);
      if (categorizedItems.containsKey(item.category)) {
        categorizedItems[item.category].add(groceryItem);
      } else {
        categorizedItems[item.category] = [groceryItem];
      }
    }
    List<Widget> columnChildren = [];
    for (String category in categorizedItems.keys) {
      List<Widget> rowChildren = categorizedItems[category];
      columnChildren.add(
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: Colors.black26,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Utils.titleCase(category),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rowChildren,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(columnChildren),
        )
      ],
    );
  }
}
