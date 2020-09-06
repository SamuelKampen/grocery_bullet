import 'package:flutter/cupertino.dart';
import 'package:grocery_bullet/location/locator.dart';
import 'package:grocery_bullet/models/location.dart';

class CurrentLocation with ChangeNotifier {
  Location _currentLocation;

  Location getCurrentLocation() => _currentLocation;

  void setCurrentLocation(Location newLocation) {
    _currentLocation = newLocation;
    notifyListeners();
  }

  Future<void> loadValue() async {
    _currentLocation = await Locator.getCurrentLocation();
  }
}