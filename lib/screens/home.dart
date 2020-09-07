import 'package:flutter/material.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/screens/account.dart';
import 'package:grocery_bullet/screens/cart.dart';
import 'package:grocery_bullet/screens/grocery.dart';
import 'package:grocery_bullet/screens/map.dart';
import 'package:grocery_bullet/search/ItemSearchDelegate.dart';
import 'package:grocery_bullet/widgets/LocationSelector.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Used to format doubles as currency
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
    Grocery(),
    Cart(),
    MapPicker(),
    Account(),
  ];
  final List<String> _appBarNames = [
    'Grocery',
    'Cart',
    'Map',
    'Account',
  ];

  @override
  Widget build(BuildContext context) {
    CartModel cart = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          LocationSelector(),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ItemSearchDelegate());
            },
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
        title: Text(_appBarNames[_currentIndex],
            style: Theme.of(context).textTheme.display4),
        backgroundColor: Colors.indigoAccent,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: Colors.indigoAccent,
        selectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.location_on),
            title: Text('Map'),
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
