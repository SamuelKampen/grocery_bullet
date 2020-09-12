import 'package:flutter/material.dart';
import 'package:grocery_bullet/screens/loading_page.dart';
import 'package:grocery_bullet/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:grocery_bullet/services/AuthService.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<auth.User>(
      future: AuthService.getSignedInUser(),
      builder: (BuildContext context, AsyncSnapshot<auth.User> snapshot) {
        if (snapshot.hasData) {
          return LoadingPage();
        }
        return SignInPage();
      },
    );
  }
}
