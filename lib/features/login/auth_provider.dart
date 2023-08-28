import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final BuildContext context;

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
      print("after try");

      _setLoading(true);

      _error = null;
      notifyListeners();

      print(email);
      print(password);
      UserCredential asd = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);
      print(asd);

      Navigator.pushReplacementNamed(context, "/profile");
    } on FirebaseAuthException catch (e) {
      print(e);
      _setLoading(false);
      if (e.code == 'user-not-found') {
        _setError("User Not Found");
      } else if (e.code == 'wrong-password') {
        _setError("Incorrect Password");
      } else {
        _setError("Something went wrong. Please try again.");
      }
    } catch (e) {
      print(e);
      _setLoading(false);
      _setError("Something went wrong. Please try again.");
    }
  }

  void _setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: PRIMARY_COLOR,
    //     content: Text(
    //       errorMessage,
    //       style: const TextStyle(color: Colors.white),
    //     ),
    //   ),
    // );
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
