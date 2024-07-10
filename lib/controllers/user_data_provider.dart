import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  User? user;
  String? _userUid;

  UserDataProvider() {
    user = FirebaseAuth.instance.currentUser;
  }

  void setUserUid(String uid) {
    _userUid = uid;
  }

  String? get userUid => _userUid;

  void refreshUser() {
    user = FirebaseAuth.instance.currentUser;
  }
}
