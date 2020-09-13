import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/Constants.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:grocery_bullet/screens/PastPurchasesScreen.dart';
import 'package:grocery_bullet/screens/signin.dart';
import 'package:grocery_bullet/services/AuthService.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    var theme = Theme.of(context).textTheme.headline1;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(user.userName, style: theme.copyWith(color: kTextColor)),
        Text(user.email, style: theme.copyWith(color: kTextColor)),
        CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
          radius: 60,
          backgroundColor: Colors.transparent,
        ),
        ButtonTheme(
          minWidth: 250,
          child: RaisedButton(
            child: Text('Shop Past Purchases',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: kTextColor)),
            color: kButtonColor,
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PastPurchasesScreen()));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        ButtonTheme(
          minWidth: 250,
          child: RaisedButton(
            child: Text('Log out',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: kTextColor)),
            color: kButtonColor,
            onPressed: () async {
              await AuthService.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignInPage()));
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        )
      ],
    ));
  }
}
