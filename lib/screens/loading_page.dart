import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/utils.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/user.dart';
import 'package:grocery_bullet/screens/home.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CurrentLocation currentLocation =
        Provider.of<CurrentLocation>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    return FutureBuilder(
      future: Utils.loadUserAndCurrentLocation(user, currentLocation),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color:  Colors.blueGrey,
          );
        }
        return Home();
      },
    );
  }
}
