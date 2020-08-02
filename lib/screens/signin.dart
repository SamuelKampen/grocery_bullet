import 'package:flutter/material.dart';
import 'package:grocery_bullet/authentication/authenticator.dart';
import 'package:grocery_bullet/screens/home.dart';

class SignInPage extends StatelessWidget {
  final Authenticator authenticator = new Authenticator();

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
                  await authenticator.signInWithGoogle();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
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
