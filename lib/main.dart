import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/theme.dart';
import 'package:grocery_bullet/models/account.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        Provider(builder: (context) => AccountModel()),
        ChangeNotifierProvider(
          create: (_) => CartModel.empty(),
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
      title: 'Grocery Bullet',
      theme: appTheme,
      home: Home(),
    );
  }
}
