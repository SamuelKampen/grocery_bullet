import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_bullet/common/utils.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:grocery_bullet/widgets/GroceryItem.dart';

class Grocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('grocery').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, List<Widget>> categorizedItems = {};
          for (DocumentSnapshot documentSnapshot in snapshot.data.documents) {
            Item item = Item.fromSnapshot(documentSnapshot);
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
        return Container();
      },
    );
  }
}
