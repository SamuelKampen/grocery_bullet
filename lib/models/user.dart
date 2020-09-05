import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String uid;
  final String userName;
  final String email;
  final String photoUrl;

  User({this.uid, this.userName, this.email, this.photoUrl});

  static Future<User> getUser() async {
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
    String uid = firebaseUser.uid;
    String userName = firebaseUser.displayName;
    String email = firebaseUser.email;
    String photoUrl = firebaseUser.photoUrl;
    return User(uid: uid, userName: userName, email: email, photoUrl: photoUrl);
  }

  bool operator ==(other) => other is User && other.uid == uid;

  int get hashCode => uid.hashCode;
}
