import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final BuildContext context;
  final formKey = GlobalKey<FormState>();

  AuthProvider(this.context);
  String? _error;
  String? _email;
  String? _password;
  bool _loading = false;

  String? get error => _error;
  String? get email => _email;
  String? get password => _password;
  bool get loading => _loading;

  void onEmailChanged(value) {
    _email = value;
    notifyListeners();
  }

  void onPasswordChanged(value) {
    _password = value;
    notifyListeners();
  }

  Future<void> login() async {
    try {
      _setLoading(true);
      notifyListeners();

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      Navigator.pushReplacementNamed(context, "/profile");

      resetError();
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      if (e.code == 'user-not-found') {
        _setError("User Not Found");
      } else if (e.code == 'wrong-password') {
        _setError("Incorrect Password");
      } else {
        _setError("Something went wrong. Please try again.");
      }
    } catch (e) {
      _setLoading(false);
      _setError("Something went wrong. Please try again.");
    }
  }

  void _setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void resetError() {
    _error = null;
    notifyListeners();
  }
}
