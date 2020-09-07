import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/services/PaymentsService.dart';
import 'package:grocery_bullet/services/StorageService.dart';
import 'package:grocery_bullet/widgets/BuyButton.dart';
import 'package:grocery_bullet/widgets/CartContents.dart';
import 'package:grocery_bullet/widgets/CartTotal.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  CartModel _cartModel;
  int unitNumber;
  CurrentLocation currentLocation;

  @override
  Widget build(BuildContext context) {
    _cartModel = Provider.of(context);
    currentLocation = Provider.of<CurrentLocation>(context);
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
              onPressed: _cartModel.isEmpty() || unitNumber == null
                  ? null
                  : () {
                      PaymentsService.executePaymentFlow(
                          _cardEntryComplete, () {});
                    }),
        ],
      ),
    );
  }

  void _cardEntryComplete() async {
    await StorageService.removeCartItemsFromLocationGrocery(
        _cartModel, currentLocation);
    _cartModel.resetCart();
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Your items are on the way!!')));
  }
}
