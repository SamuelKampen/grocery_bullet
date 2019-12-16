import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.display4),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            Divider(height: 10, color: Colors.black),
            _CartTotal(),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {},
                child: Text('Buy', style: Theme.of(context).textTheme.display4),
                color: Colors.lightGreen,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.title;
    var cart = Provider.of<CartModel>(context);

    return ListView.builder(
      itemCount: cart.getUniqueItemCount(),
      itemBuilder: (context, index) => ListTile(
        leading: Text(
          cart.getItemCount(cart.get()[index]).toString(),
          style: itemNameStyle,
        ),
        title: Text(
          cart.get()[index].name,
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
