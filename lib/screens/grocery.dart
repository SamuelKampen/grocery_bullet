import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

class _AddButton extends StatelessWidget {
  final DocumentSnapshot document;
  const _AddButton({Key key, @required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    return IconButton(
      onPressed: () => cart.add(document),
      icon: Icon(Icons.add),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final DocumentSnapshot document;
  const _RemoveButton({Key key, @required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    return IconButton(
      onPressed: () => cart.remove(document),
      icon: Icon(Icons.remove),
    );
  }
}

class _GroceryItem extends StatelessWidget {
  final DocumentSnapshot document;
  _GroceryItem(this.document, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    var textTheme = Theme.of(context).textTheme.title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(document['name'], style: textTheme),
            ),
            Expanded(
              child: Text(oCcy.format(document['price']), style: textTheme),
            ),
            _RemoveButton(document: document),
            Text(cart.getItemCount(document).toString(), style: textTheme),
            _AddButton(document: document),
          ],
        ),
      ),
    );
  }
}
