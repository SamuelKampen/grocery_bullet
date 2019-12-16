import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_bullet/common/theme.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/catalog.dart';
import 'package:grocery_bullet/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        Provider(builder: (context) => CatalogModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          initialBuilder: (context) => CartModel.empty(),
          builder: (context, catalog, previousCart) =>
              CartModel(catalog, previousCart),
        ),
      ],
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demo',
      theme: appTheme,
      home: Home(),
    );
  }
}
