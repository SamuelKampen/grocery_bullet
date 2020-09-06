import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String uid;
  String userName;
  String email;
  String photoUrl;


  Future<void> loadValue() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData({
      'uid': firebaseUser.uid,
      'user_name': firebaseUser.displayName,
      'email': firebaseUser.email,
      'photo_url': firebaseUser.photoUrl,
    }, merge: true);
    uid = firebaseUser.uid;
    userName = firebaseUser.displayName;
    email = firebaseUser.email;
    photoUrl = firebaseUser.photoUrl;
  }

  bool operator ==(other) => other is User && other.uid == uid;

  int get hashCode => uid.hashCode;
}
