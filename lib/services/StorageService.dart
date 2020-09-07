import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/current_location.dart';
import 'package:grocery_bullet/models/item.dart';

class StorageService {
  static Future<void> writeUser(FirebaseUser firebaseUser) async {
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData({
      'uid': firebaseUser.uid,
      'user_name': firebaseUser.displayName,
      'email': firebaseUser.email,
      'photo_url': firebaseUser.photoUrl,
      'past_purchases': List<Map<dynamic, dynamic>>.from([]),
    }, merge: true);
  }

  static Future<void> removeCartItemsFromLocationGrocery(
      CartModel cartModel, CurrentLocation currentLocation) async {
    await Firestore.instance.runTransaction((transaction) async {
      Map<Item, int> cartItems = cartModel.getCart();
      DocumentSnapshot freshSnap =
          await transaction.get(currentLocation.getCurrentLocation().reference);
      List<Map<dynamic, dynamic>> storedGrocery =
          List<Map<dynamic, dynamic>>.from(freshSnap['grocery']);
      List<Map<dynamic, dynamic>> updatedGrocery = [];
      for (int i = 0; i < storedGrocery.length; i++) {
        Map<dynamic, dynamic> map = storedGrocery[i];
        Item storedItem = await Item.getItem(Map<String, dynamic>.from(map));
        for (Item item in cartItems.keys) {
          int itemCountRequested = cartItems[item];
          if (storedItem.name == item.name) {
            int itemCountAvailable = storedItem.count;
            int itemCountSent = itemCountAvailable >= itemCountRequested
                ? itemCountRequested
                : itemCountAvailable;
            int itemCountRemaining = itemCountAvailable - itemCountSent;
            map['count'] = itemCountRemaining;
          }
        }
        updatedGrocery.add(map);
      }
      await transaction.update(freshSnap.reference, {
        'grocery': updatedGrocery,
      });
    });
  }

  static Stream<QuerySnapshot> getLocationsStream() {
    return getLocations().snapshots();
  }

  static Future<QuerySnapshot> getLocationsQuerySnapshot() async {
    return await getLocations().getDocuments();
  }

  static CollectionReference getLocations() {
    return Firestore.instance.collection('locations');
  }

  static Future<DocumentSnapshot> readUser(String uid) async {
    return await Firestore.instance.document('users/' + uid).get();
  }
}
