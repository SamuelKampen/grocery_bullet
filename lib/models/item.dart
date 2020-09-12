import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String name;
  final double price;
  final int count;
  final String url;
  final DocumentReference reference;
  final String category;

  Item(
      {this.name,
      this.price,
      this.count,
      this.url,
      this.reference,
      this.category});

  static Future<Item> getItem(Map<String, dynamic> map) async {
    DocumentReference reference = map['item'];
    int count = map['count'];
    DocumentSnapshot documentSnapshot = await reference.get();
    Map<String, dynamic> data = documentSnapshot.data();
    String name = data['name'];
    double price = double.parse(data['price'].toString());
    String url = data['url'];
    String category = data['category'];
    return Item(
        name: name,
        price: price,
        count: count,
        url: url,
        reference: reference,
        category: category);
  }

  bool operator ==(other) => other is Item && other.name == name;

  int get hashCode => name.hashCode;
}
