// Model to represent a document in the grocery collection in Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String name;
  final double price;
  final int count;
  final String url;
  final DocumentReference reference;

  Item.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['count'] != null),
        assert(map['url'] != null),
        name = map['name'],
        // If the value in the database is just stored as a whole number
        // i.e. 2 the cast to double will fail so we change to string then
        // parse as a double.
        price = double.parse(map['price'].toString()),
        count = map['count'],
        url = map['url'];

  Item.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  bool operator ==(other) => other is Item && other.name == name;

  int get hashCode => name.hashCode;
}
