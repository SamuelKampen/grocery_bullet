import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_pay/flutter_google_pay.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    _cartModel = Provider.of<CartModel>(context);
    return Container(
      color: Colors.white,
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
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                Map<Item, int> cartItems = _cartModel.getCart();
                for (Item item in cartItems.keys) {
                  int itemCountRequested = cartItems[item];
                  Firestore.instance.runTransaction((transaction) async {
                    DocumentSnapshot freshSnap =
                        await transaction.get(item.reference);
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
                _makeStripePayment();
              },
              child: Text('Buy', style: Theme.of(context).textTheme.display4),
              color: Colors.lightGreen,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  _makeStripePayment() async {
    var environment = 'rest'; // or 'production'
    if (!(await FlutterGooglePay.isAvailable(environment))) {
      print('Google pay not available');
    } else {
      PaymentItem pm = PaymentItem(
          stripeToken: 'pk_test_1IV5H8NyhgGYOeK6vYV3Qw8f',
          stripeVersion: "2018-11-08",
          currencyCode: "usd",
          amount: "0.10",
          gateway: 'stripe');

      FlutterGooglePay.makePayment(pm).then((Result result) {
        if (result.status == ResultStatus.SUCCESS) {
          print('Success');
        }
      }).catchError((dynamic error) {
        print(error.toString());
      });
    }
  }
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
