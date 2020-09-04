import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/theme.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:grocery_bullet/screens/landing_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartModel.empty(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            CurrentLocation currentLocation = CurrentLocation();
            currentLocation.establishLocation();
            return currentLocation;
            },
        ),
        ChangeNotifierProvider(
          create: (_) {
            User user = User();
            user.establishUser();
            return user;
          },
        ),
      ],
      child: MaterialApp(
        theme: appTheme,
        home: LandingPage(),
      ),
    );
  }
}
