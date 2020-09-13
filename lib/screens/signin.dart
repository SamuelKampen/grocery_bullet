import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:grocery_bullet/common/Constants.dart';
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
        backgroundColor: kSecondaryColor,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/logo.png'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: SignInButton(
                Buttons.Google,
                onPressed: () async {
                  await AuthService.signInWithGoogle();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoadingPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
