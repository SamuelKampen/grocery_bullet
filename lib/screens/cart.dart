import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Used to format doubles as currency
final oCcy = new NumberFormat("#,##0.00", "en_US");

// TODO The code in this file is an unmaintainable disaster

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              child: Text('Buy', style: Theme.of(context).textTheme.display4),
              color: Colors.lightGreen,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.title;
    var cart = Provider.of<CartModel>(context);
    HashMap<String, int> itemCounts = cart.getItemCounts();
    List<String> names = new List();
    List<int> counts = new List();
    for (String key in itemCounts.keys) {
      names.add(key);
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
