import 'package:flutter/material.dart';

class AccountModel {
  static const String _testEmail = 'coolguy@awesomeemail.abc';
  static const String _testLocation = 'A pineapple under the sea';
  static const int _testUnitNumber = 517;
  static const String _testCreditCard = '0000111122223333';


  Account getUser() => Account(_testEmail, _testLocation, _testUnitNumber, _testCreditCard);
}

@immutable
class Account {
  final String email;
  final String location;
  final int unitNumber;
  final String creditCard;

  String getEmail() => email;
  String getLocation() => location;
  int getUnitNumber() => unitNumber;
  String getCreditCard() => creditCard;

  Account(this.email, this.location, this.unitNumber, this.creditCard);

  @override
  int get hashCode => email.hashCode;

  @override
  bool operator ==(Object other) => other is Account && other.email == email;
}
