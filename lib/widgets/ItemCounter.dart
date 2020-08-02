import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:provider/provider.dart';


class ItemCounter extends StatelessWidget {
  final Item item;
  ItemCounter({@required this.item, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    return Counter(
      initialValue: cart.getItemCount(item),
      minValue: 0,
      maxValue: 1000000,
      decimalPlaces: 0,
      onChanged: (value) {
        if (cart.getItemCount(item) > value) {
          cart.remove(item);
        } else if (cart.getItemCount(item) < value) {
          cart.add(item);
        }
      },
      textStyle: Theme.of(context).textTheme.title,
    );
  }
}