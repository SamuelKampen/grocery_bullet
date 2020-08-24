
import 'package:flutter/cupertino.dart';
import 'package:grocery_bullet/location/locator.dart';
import 'package:grocery_bullet/models/location.dart';

class CurrentLocation with ChangeNotifier {
  Location _currentLocation;

  Future<Location> establishLocation() async {
    if (_currentLocation == null) {
      _currentLocation = await Locator.getCurrentLocation();
    }
    notifyListeners();
    return _currentLocation;
  }

  void setCurrentLocation(Location location) {
    _currentLocation = location;
    notifyListeners();
  }

  Location getCurrentLocation() => _currentLocation;
}