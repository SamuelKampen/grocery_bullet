import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountModel extends ChangeNotifier {
  FirebaseUser user;

  AccountModel(AccountModel previous) : user = previous?.user ?? null;

  AccountModel.empty() : user = null;
}
