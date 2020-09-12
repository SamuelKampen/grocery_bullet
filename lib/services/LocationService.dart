import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/services/StorageService.dart';

class LocationService {
  static Future<Location> getCurrentLocation() async {
    QuerySnapshot querySnapshot =
        await StorageService.getLocationsQuerySnapshot();
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    GeoPoint usersPosition = GeoPoint(position.latitude, position.longitude);
    double minDistance = double.infinity;
    Location closestLocation;
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Location location = await Location.getLocation(documentSnapshot);
      GeoPoint locationPosition = location.geoPoint;
      double distanceToLocation = distanceBetween(
          usersPosition.latitude,
          usersPosition.longitude,
          locationPosition.latitude,
          locationPosition.longitude);
      if (distanceToLocation < minDistance) {
        closestLocation = location;
      }
    }
    return closestLocation;
  }
}
