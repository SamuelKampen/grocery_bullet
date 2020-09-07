import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_bullet/services/AuthService.dart';
import 'package:grocery_bullet/services/StorageService.dart';

class User with ChangeNotifier {
  String uid;
  String userName;
  String email;
  String photoUrl;

  Future<void> loadValue() async {
    FirebaseUser firebaseUser = await AuthService.getSignedInUser();
    await StorageService.writeUser(firebaseUser);
    uid = firebaseUser.uid;
    userName = firebaseUser.displayName;
    email = firebaseUser.email;
    photoUrl = firebaseUser.photoUrl;
  }

  bool operator ==(other) => other is User && other.uid == uid;

  int get hashCode => uid.hashCode;
}
