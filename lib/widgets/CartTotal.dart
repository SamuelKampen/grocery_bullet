import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/Constants.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:provider/provider.dart';

class CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle = Theme.of(context).textTheme.headline1.copyWith(fontSize: 48);
    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CartModel>(
                builder: (context, cart, child) => Text(
                    '\$${kOCcy.format(cart.getTotalPrice())}',
                    style: hugeStyle)),
          ],
        ),
      ),
    );
  }
}