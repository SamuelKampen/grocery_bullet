import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Used to format doubles as currency
final oCcy = new NumberFormat("#,##0.00", "en_US");

class Grocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 12)),
        StreamBuilder(
            stream: Firestore.instance.collection('grocery').snapshots(),
            builder: (context, snapshot) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _GroceryItem(
                      Item.fromSnapshot(snapshot.data.documents[index])),
                  childCount:
                      snapshot.hasData ? snapshot.data.documents.length : 0,
                ),
              );
            }),
      ],
    );
  }
}

class _CounterWidget extends StatelessWidget {
  final Item item;
  _CounterWidget(this.item, {Key key}) : super(key: key);

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

class _SoldOutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.announcement),
        Text("Sold Out"),
      ],
    );
  }
}

class _GroceryItem extends StatelessWidget {
  final Item item;
  _GroceryItem(this.item, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.title;
    return Card(
      color: Colors.white54,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.url),
        ),
        title: Text(item.name, style: textTheme),
        subtitle: Text(oCcy.format(item.price), style: textTheme),
        trailing: item.count == 0 ? _SoldOutWidget() : _CounterWidget(item),
      ),
    );
  }
}
