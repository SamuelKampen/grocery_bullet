import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:grocery_bullet/models/cart.dart';
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
                  (context, index) =>
                      _GroceryItem(snapshot.data.documents[index]),
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
  final DocumentSnapshot document;
  _CounterWidget(this.document, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    return Counter(
      initialValue: cart.getItemCount(document),
      minValue: 0,
      maxValue: 1000000,
      decimalPlaces: 0,
      onChanged: (value) {
        if (cart.getItemCount(document) > value) {
          cart.remove(document);
        } else if (cart.getItemCount(document) < value) {
          cart.add(document);
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
  final DocumentSnapshot document;
  _GroceryItem(this.document, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(document['name'], style: textTheme),
            ),
            Expanded(
              child: Text(oCcy.format(document['price']), style: textTheme),
            ),
            document['count'] == 0
                ? _SoldOutWidget()
                : _CounterWidget(document),
          ],
        ),
      ),
    );
  }
}
