import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }
}