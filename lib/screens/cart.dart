import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

// Used to format doubles as currency
final oCcy = new NumberFormat("#,##0.00", "en_US");

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  CartModel _cartModel;

  @override
  Widget build(BuildContext context) {
    _cartModel = Provider.of(context);
    return Container(
      color: Colors.blueGrey,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _CartContents(),
            ),
          ),
          Divider(height: 10, color: Colors.black),
          _CartTotal(),
          SizedBox(
            width: 300,
            child: RaisedButton(
              onPressed: () {
                _pay();
              },
              child: Text('Buy', style: Theme.of(context).textTheme.display4),
              color: Colors.indigoAccent,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.indigoAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pay() {
    InAppPayments.setSquareApplicationId('sq0idp-v9L6FHpv4e7iAf315K7UnA');
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
      onCardEntryCancel: _cardEntryCancel,
    );
  }

  void _cardNonceRequestSuccess(CardDetails cardDetails) {
    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );
  }

  void _cardEntryComplete() {
    Map<Item, int> cartItems = _cartModel.getCart();
    for (Item item in cartItems.keys) {
      int itemCountRequested = cartItems[item];
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(item.reference);
        int itemCountAvailable = freshSnap['count'];
        int itemCountSent = itemCountAvailable >= itemCountRequested
            ? itemCountRequested
            : itemCountAvailable;
        int itemCountRemaining = itemCountAvailable - itemCountSent;
        await transaction.update(freshSnap.reference, {
          'count': itemCountRemaining,
        });
      });
    }
    _cartModel.resetCart();
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Your items are on the way!!')));
  }

  void _cardEntryCancel() {}
}

class _CartContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.title;
    var cart = Provider.of<CartModel>(context);
    HashMap<Item, int> itemCounts = cart.getCart();
    List<String> names = new List();
    List<int> counts = new List();
    for (Item key in itemCounts.keys) {
      names.add(key.name);
      counts.add(itemCounts[key]);
    }
    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, index) => ListTile(
        leading: Text(
          counts[index].toString(),
          style: itemNameStyle,
        ),
        title: Text(
          names[index],
          style: itemNameStyle,
        ),
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle = Theme.of(context).textTheme.display4.copyWith(fontSize: 48);
    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CartModel>(
                builder: (context, cart, child) => Text(
                    '\$${oCcy.format(cart.getTotalPrice())}',
                    style: hugeStyle)),
          ],
        ),
      ),
    );
  }
}
