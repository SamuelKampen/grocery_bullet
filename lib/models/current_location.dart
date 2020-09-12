import 'package:flutter/cupertino.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/services/LocationService.dart';

class CurrentLocation with ChangeNotifier {
  Location _currentLocation;

  Future<Location> getCurrentLocation() async {
    if (_currentLocation == null) {
      _currentLocation = await LocationService.getCurrentLocation();
    }
    return _currentLocation;
  }

  void setCurrentLocation(Location newLocation) {
    _currentLocation = newLocation;
    notifyListeners();
  }

  Future<void> loadValue() async {
    _currentLocation = await LocationService.getCurrentLocation();
  }
}