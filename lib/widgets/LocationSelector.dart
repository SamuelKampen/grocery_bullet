import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_bullet/common/utils.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:provider/provider.dart';

class LocationSelector extends StatefulWidget {
  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  Location location;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('locations').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: Utils.getLocations(snapshot.data.documents),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              CurrentLocation currentLocation =
                  Provider.of<CurrentLocation>(context);
              CartModel cartModel = Provider.of<CartModel>(context);
              if (snapshot.hasData) {
                List<DropdownMenuItem<Location>> dropdownItems = [];
                List<Location> locations = snapshot.data;
                for (Location toAddLocation in locations) {
                  dropdownItems.add(
                    DropdownMenuItem<Location>(
                      value: toAddLocation,
                      child: Text(toAddLocation.name),
                    ),
                  );
                }
                return DropdownButton<Location>(
                  value: location ?? currentLocation.getCurrentLocation(),
                  icon: Icon(Icons.arrow_drop_down),
                  items: dropdownItems,
                  onChanged: (Location newLocation) {
                    setState(
                      () {
                        location = newLocation;
                        currentLocation.setCurrentLocation(location);
                        cartModel.resetCart();
                      },
                    );
                  },
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }
}
