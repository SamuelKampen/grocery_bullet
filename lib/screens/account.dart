import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_bullet/screens/signin.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        var theme = Theme.of(context).textTheme.display4;
        if (!snapshot.hasData) {
          return Center(
            child: Text('No User logged in', style: theme),
          );
        }
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(snapshot.data.displayName, style: theme),
            Text(snapshot.data.email, style: theme),
            CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data.photoUrl),
              radius: 60,
              backgroundColor: Colors.transparent,
            ),
            RaisedButton(
              child: Text('Log out'),
              color: Colors.indigoAccent,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInPage()));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.indigoAccent),
              ),
            )
          ],
        ));
      },
    );
  }
}
