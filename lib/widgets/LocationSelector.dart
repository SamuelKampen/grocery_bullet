import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          List<DropdownMenuItem<Location>> dropdownItems = [];
          for (DocumentSnapshot documentSnapshot in snapshot.data.documents) {
            Location toAddlocation = Location.fromSnapshot(documentSnapshot);
            dropdownItems.add(
              DropdownMenuItem<Location>(
                value: toAddlocation,
                child: Text(toAddlocation.name),
              ),
            );
          }
          return DropdownButton<Location>(
            value: location ??
                Provider.of<CurrentLocation>(context).getCurrentLocation(),
            icon: Icon(Icons.arrow_drop_down),
            items: dropdownItems,
            onChanged: (Location newLocation) {
              setState(
                () {
                  location = newLocation;
                  Provider.of<CurrentLocation>(context)
                      .setCurrentLocation(location);
                  Provider.of<CartModel>(context).resetCart();
                },
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
