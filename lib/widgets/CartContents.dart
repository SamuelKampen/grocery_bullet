import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/Constants.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:grocery_bullet/widgets/ItemCounter.dart';
import 'package:provider/provider.dart';

class CartContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle =
        Theme.of(context).textTheme.headline6.copyWith(color: kTextColor);
    var cart = Provider.of<CartModel>(context);
    Map<Item, int> itemCounts = cart.getCart();
    List<String> names = List();
    List<int> counts = List();
    List<Item> items = List();
    for (Item key in itemCounts.keys) {
      names.add(key.name);
      counts.add(itemCounts[key]);
      items.add(key);
    }
    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(items[index].url),
        ),
        title: Text(
          names[index],
          style: itemNameStyle,
        ),
        subtitle: Text(
          '\$${kOCcy.format(items[index].price * counts[index])}',
          style: TextStyle(color: kTextColor),
        ),
        trailing: ItemCounter(
          item: items[index],
        ),
      ),
    );
  }
}
