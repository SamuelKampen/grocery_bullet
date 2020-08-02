import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_bullet/common/Constants.dart';
import 'package:grocery_bullet/models/item.dart';

import 'ItemCounter.dart';

class GroceryItem extends StatelessWidget {
  final Item item;

  GroceryItem({this.item, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Container(
        color: Colors.black12,
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
                      color: Colors.white,
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
              children: <Widget>[
                Text(
                  '\$${kOCcy.format(item.price)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(item.name),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
