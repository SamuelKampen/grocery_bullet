import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String uid;
  String userName;
  String email;
  String photoUrl;

  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        userName = data['user_name'],
        email = data['email'],
        photoUrl = data['photo_url'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'user_name': userName,
      'email': email,
      'photo_url': photoUrl,
    };
  }

  User();

  void establishUser() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
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
  }

  bool operator ==(other) => other is User && other.uid == uid;

  int get hashCode => uid.hashCode;
}
