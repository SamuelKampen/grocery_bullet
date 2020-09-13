import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_bullet/common/Constants.dart';
import 'package:grocery_bullet/models/item.dart';

import 'ItemCounter.dart';

class GroceryItem extends StatelessWidget {
  final Item item;
  final bool includeCountInfo;
  final Color cardColor;

  GroceryItem({this.item, this.includeCountInfo = false, this.cardColor = kPrimaryColor, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> textChildren = [
      Text(
        '\$${kOCcy.format(item.price)}',
        style: TextStyle(fontWeight: FontWeight.w700, color: kTextColor),
      ),
      Text(
        item.name,
        style: TextStyle(color: kTextColor),
      ),
    ];
    if (includeCountInfo) {
      textChildren.add(Text(
        'You have purchased this item ${item.count} times.',
        style: TextStyle(color: kTextColor),
      ));
    }
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: cardColor,
              spreadRadius: 5,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ItemCounter(item: item),
                    ],
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(item.url),
                        fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: textChildren,
            ),
          ],
        ),
      ),
    );
  }
}
