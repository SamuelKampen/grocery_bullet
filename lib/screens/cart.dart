import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_bullet/location/locator.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/widgets/BuyButton.dart';
import 'package:grocery_bullet/widgets/CartContents.dart';
import 'package:grocery_bullet/widgets/CartTotal.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  CartModel _cartModel;
  int unitNumber;

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
              child: CartContents(),
            ),
          ),
          Divider(height: 10, color: Colors.black),
          CartTotal(),
          Container(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter your unit number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              onSubmitted: (newUnitNumber) {
                setState(() {
                  unitNumber = int.parse(newUnitNumber);
                });
              },
            ),
          ),
          BuyButton(
            onPressed: _cartModel.isEmpty() || unitNumber == null ? null : _pay,
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
    Firestore.instance.runTransaction((transaction) async {
      Location location = await Locator.getCurrentLocation();
      DocumentSnapshot freshSnap = await transaction.get(location.reference);
      List<Map<dynamic, dynamic>> storedGrocery =
          List<Map<dynamic, dynamic>>.from(freshSnap['grocery']);
      List<Map<dynamic, dynamic>> updatedGrocery = [];
      for (int i = 0; i < storedGrocery.length; i++) {
        Map<dynamic, dynamic> map = storedGrocery[i];
        Item storedItem = await Item.getItem(Map<String, dynamic>.from(map));
        for (Item item in cartItems.keys) {
          int itemCountRequested = cartItems[item];
          if (storedItem.name == item.name) {
            int itemCountAvailable = storedItem.count;
            int itemCountSent = itemCountAvailable >= itemCountRequested
                ? itemCountRequested
                : itemCountAvailable;
            int itemCountRemaining = itemCountAvailable - itemCountSent;
            map['count'] = itemCountRemaining;
          }
        }
        updatedGrocery.add(map);
      }
      await transaction.update(freshSnap.reference, {
        'grocery': updatedGrocery,
      });
    });
    _cartModel.resetCart();
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Your items are on the way!!')));
  }

  void _cardEntryCancel() {}
}
