import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/models/user.dart';

class Utils {
  static String titleCase(String text) {
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

  static Future<List<Location>> getLocations(
      List<DocumentSnapshot> snapshots) async {
    List<Location> locations = [];
    for (DocumentSnapshot snapshot in snapshots) {
      Location location = await Location.getLocation(snapshot);
      locations.add(location);
    }
    return locations;
  }

  static Future<void> loadUserAndCurrentLocation(
      User user, CurrentLocation currentLocation) async {
    await user.loadValue();
    await currentLocation.loadValue();
  }
}
