import 'package:flutter/material.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/screens/account.dart';
import 'package:grocery_bullet/screens/cart.dart';
import 'package:grocery_bullet/screens/catalog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MyCatalog(),
    MyCart(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Grocery'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('\$${oCcy.format(cart.getTotalPrice())}'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Account'))
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
