import 'package:flutter/material.dart';
import 'package:grocery_bullet/screens/loading_page.dart';
import 'package:grocery_bullet/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_bullet/services/AuthService.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: AuthService.getSignedInUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          return LoadingPage();
        }
        return SignInPage();
      },
    );
  }
}