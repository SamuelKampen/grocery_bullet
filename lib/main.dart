import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/theme.dart';
import 'package:grocery_bullet/models/account.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/screens/home.dart';
import 'package:grocery_bullet/screens/signin.dart';
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
        ChangeNotifierProvider(create: (_) => AccountModel.empty()),
        ChangeNotifierProvider(create: (_) => CartModel.empty()),
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
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var account = Provider.of<AccountModel>(context);
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          FirebaseUser user = snapshot.data;
          account.user = user;
          return Home();
        }
        return SignInPage();
      },
    );
  }
}
