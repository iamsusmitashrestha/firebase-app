import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordProvider extends ChangeNotifier {
  String? email;

  onEmailChanged(value) {
    email = value;
    notifyListeners();
  }

  resetPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
  }
}
