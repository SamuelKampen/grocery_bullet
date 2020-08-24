import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_bullet/models/item.dart';

class Location {
  final String name;
  final GeoPoint geoPoint;
  final DocumentReference reference;
  final List<int> units;
  final List<Item> grocery;

  Location.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['location'] != null),
        assert(map['units'] != null),
        assert(map['grocery'] != null),
        name = map['name'],
        geoPoint = map['location'],
        units = List<int>.from(map['units']),
        grocery = _buildGrocery(map['grocery']);

  Location.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  bool operator ==(other) => other is Location && other.geoPoint == geoPoint;

  int get hashCode => geoPoint.hashCode;

  static List<Item> _buildGrocery(List items) {
    List<Item> result = [];
    for (Map<dynamic, dynamic> item in items) {
      result.add(Item.fromMap(Map<String, dynamic>.from(item)));
    }
    return result;
  }
}
