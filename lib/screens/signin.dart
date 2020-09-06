import 'package:flutter/material.dart';
import 'package:grocery_bullet/screens/loading_page.dart';
import 'package:grocery_bullet/services/AuthService.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Registration'),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () async {
                  await AuthService.signInWithGoogle();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoadingPage()));
                },
                child: const Text('Sign in with Google'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
