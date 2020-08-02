import 'package:flutter/material.dart';
import 'package:grocery_bullet/screens/home.dart';
import 'package:grocery_bullet/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          return Home();
        }
        return SignInPage();
      },
    );
  }
}