import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_bullet/models/item.dart';

class Location {
  final String name;
  final GeoPoint geoPoint;
  final DocumentReference reference;
  final List<int> units;
  final List<Item> grocery;

  Location(
      {this.name, this.geoPoint, this.reference, this.units, this.grocery});

  static Future<Location> getLocation(DocumentSnapshot snapshot) async {
    Map<String, dynamic> data = snapshot.data;
    DocumentReference reference = snapshot.reference;
    String name = data['name'];
    GeoPoint geoPoint = data['location'];
    List<int> units = List<int>.from(data['units']);
    List<Item> grocery = [];
    for (Map<dynamic, dynamic> map in data['grocery']) {
      Item item = await Item.getItem(Map<String, dynamic>.from(map));
      grocery.add(item);
    }
    return Location(
        name: name,
        geoPoint: geoPoint,
        reference: reference,
        units: units,
        grocery: grocery);
  }

  bool operator ==(other) => other is Location && other.geoPoint == geoPoint;

  int get hashCode => geoPoint.hashCode;
}
