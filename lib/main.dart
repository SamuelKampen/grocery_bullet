import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/theme.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:grocery_bullet/screens/landing_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartModel.empty(),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrentLocation(),
        ),
        ChangeNotifierProvider(
          create: (_) => User(),
        )
      ],
      child: MaterialApp(
        theme: appTheme,
        home: LandingPage(),
      ),
    );
  }
}
