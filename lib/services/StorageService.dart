import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:grocery_bullet/models/cart.dart';
import 'package:grocery_bullet/models/item.dart';
import 'package:grocery_bullet/models/location.dart';
import 'package:grocery_bullet/models/user.dart';

class StorageService {
  static Future<void> writeUser(
      auth.User firebaseUser, List<Map<dynamic, dynamic>> pastPurchases) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set(
      {
        'uid': firebaseUser.uid,
        'user_name': firebaseUser.displayName,
        'email': firebaseUser.email,
        'photo_url': firebaseUser.photoURL,
        'past_purchases': pastPurchases,
      },
      SetOptions(merge: true),
    );
  }

  static Future<void> removeCartItemsFromLocationGrocery(
      CartModel cartModel, Location currentLocation, User user) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      Map<Item, int> cartItems = cartModel.getCart();
      DocumentSnapshot freshSnap =
          await transaction.get(currentLocation.reference);
      List<Map<dynamic, dynamic>> storedGrocery =
          List<Map<dynamic, dynamic>>.from(freshSnap.get('grocery'));
      List<Map<dynamic, dynamic>> updatedGrocery = [];
      for (int i = 0; i < storedGrocery.length; i++) {
        Map<dynamic, dynamic> map = storedGrocery[i];
        Item storedItem = await Item.getItem(Map<String, dynamic>.from(map));
        for (Item item in cartItems.keys) {
          int itemCountRequested = cartItems[item];
          if (storedItem.reference == item.reference) {
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
      transaction.update(freshSnap.reference, {
        'grocery': updatedGrocery,
      });
    });

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      Map<Item, int> cartItems = cartModel.getCart();
      DocumentSnapshot userFreshSnap = await transaction.get(user.reference);
      List<Map<dynamic, dynamic>> storedPastPurchases =
          List<Map<dynamic, dynamic>>.from(userFreshSnap.get('past_purchases'));
      List<Map<dynamic, dynamic>> updatedPastPurchases = [];
      for (Item item in cartItems.keys) {
        int itemCountRequested = cartItems[item];
        Map<dynamic, dynamic> map = {
          'count': itemCountRequested,
          'item': item.reference,
        };
        for (int i = 0; i < storedPastPurchases.length; i++) {
          Item storedItem = await Item.getItem(
              Map<String, dynamic>.from(storedPastPurchases[i]));
          if (storedItem.reference == item.reference) {
            map['count'] = itemCountRequested + storedItem.count;
          }
        }
        updatedPastPurchases.add(map);
      }
      for (int i = 0; i < storedPastPurchases.length; i++) {
        Item storedItem = await Item.getItem(
            Map<String, dynamic>.from(storedPastPurchases[i]));
        if (!updatedPastPurchases
            .any((element) => element['item'] == storedItem.reference)) {
          updatedPastPurchases.add(storedPastPurchases[i]);
        }
      }
      transaction.update(userFreshSnap.reference, {
        'past_purchases': updatedPastPurchases,
      });
    });
  }

  static Stream<QuerySnapshot> getLocationsStream() {
    return getLocations().snapshots();
  }

  static Future<QuerySnapshot> getLocationsQuerySnapshot() async {
    return await getLocations().get();
  }

  static CollectionReference getLocations() {
    return FirebaseFirestore.instance.collection('locations');
  }

  static Future<DocumentSnapshot> readUser(String uid) async {
    return await FirebaseFirestore.instance.doc('users/' + uid).get();
  }
}
