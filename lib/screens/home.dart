import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grocery_bullet/common/Constants.dart';
import 'package:grocery_bullet/screens/account.dart';
import 'package:grocery_bullet/screens/cart.dart';
import 'package:grocery_bullet/screens/grocery.dart';
import 'package:grocery_bullet/screens/map.dart';
import 'package:grocery_bullet/search/ItemSearchDelegate.dart';
import 'package:grocery_bullet/widgets/LocationSelector.dart';
import 'package:intl/intl.dart';

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
              color: Color.fromRGBO(222, 222, 222, 1),
            ),
          ),
        ],
        title: Text(_appBarNames[_currentIndex],
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: Color.fromRGBO(222, 222, 222, 1))),
        backgroundColor: kSecondaryColor,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: kSecondaryColor,
        selectedColor: Colors.white,
        unSelectedColor: Colors.grey,
        items: [
          new CustomNavigationBarItem(
            icon: FontAwesomeIcons.home,
          ),
          new CustomNavigationBarItem(
            icon: FontAwesomeIcons.shoppingCart,
          ),
          new CustomNavigationBarItem(
            icon: FontAwesomeIcons.mapMarkerAlt,
          ),
          new CustomNavigationBarItem(
            icon: FontAwesomeIcons.userCircle,
          )
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
