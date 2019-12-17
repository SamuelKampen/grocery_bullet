import 'package:flutter/material.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AccountModel>(context);
    // TODO: Make this pretty
    return Column(
      children: <Widget>[
        Text(user.getUser().getEmail()),
        Text(user.getUser().getCreditCard()),
        Text(user.getUser().getLocation()),
        Text(user.getUser().getUnitNumber().toString())
      ],
    );
  }
}
