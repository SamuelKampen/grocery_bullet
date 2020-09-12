import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            style: Theme.of(context).textTheme.headline1),
        backgroundColor: Colors.indigoAccent,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: Colors.indigoAccent,
        selectedColor: Colors.white,
        unSelectedColor: Colors.grey,
        items: [
          new CustomNavigationBarItem(
            icon: FontAwesomeIcons.home,
            unSelectedTitle: 'Grocery',
            selectedTitle: 'Grocery',
          ),
          new CustomNavigationBarItem(
            icon: FontAwesomeIcons.shoppingCart,
            unSelectedTitle: '\$${oCcy.format(cart.getTotalPrice())}',
            selectedTitle: '\$${oCcy.format(cart.getTotalPrice())}',
          ),
          new CustomNavigationBarItem(
            icon: FontAwesomeIcons.mapMarkerAlt,
            unSelectedTitle: 'Map',
            selectedTitle: 'Map',
          ),
          new CustomNavigationBarItem(
              icon: FontAwesomeIcons.userCircle,
              unSelectedTitle: 'Account',
              selectedTitle: 'Account')
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
