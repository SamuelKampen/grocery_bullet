import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:grocery_bullet/screens/signin.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    var theme = Theme.of(context).textTheme.display4;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(user.userName, style: theme),
        Text(user.email, style: theme),
        CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
          radius: 60,
          backgroundColor: Colors.transparent,
        ),
        RaisedButton(
          child: Text('Log out'),
          color: Colors.indigoAccent,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignInPage()));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.indigoAccent),
          ),
        )
      ],
    ));
  }
}
