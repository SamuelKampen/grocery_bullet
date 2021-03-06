import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:grocery_bullet/services/AuthService.dart';
import 'package:grocery_bullet/services/StorageService.dart';
import 'item.dart';

class User with ChangeNotifier {
  String uid;
  String userName;
  String email;
  String photoUrl;
  List<Item> pastPurchases;
  DocumentReference reference;

  Future<void> loadValue() async {
    auth.User firebaseUser = await AuthService.getSignedInUser();
    DocumentSnapshot storedUser =
        await StorageService.readUser(firebaseUser.uid);
    pastPurchases = [];
    if (storedUser.data() == null) {
      await StorageService.writeUser(
          firebaseUser, List<Map<dynamic, dynamic>>.from([]));
      storedUser = await StorageService.readUser(firebaseUser.uid);
    } else {
      Map<String, dynamic> data = storedUser.data();
      for (Map<dynamic, dynamic> map in data['past_purchases']) {
        pastPurchases.add(await Item.getItem(Map<String, dynamic>.from(map)));
      }
    }
    uid = firebaseUser.uid;
    userName = firebaseUser.displayName;
    email = firebaseUser.email;
    photoUrl = firebaseUser.photoURL;
    reference = storedUser.reference;
  }

  bool operator ==(other) => other is User && other.uid == uid;

  int get hashCode => uid.hashCode;
}
