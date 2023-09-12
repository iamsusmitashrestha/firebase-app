import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/data/models/user.dart';
import 'package:firebase_app/services/shared_preference_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  final BuildContext context;
  final _db = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final prefs = SharedPreferencesService();

  SignupProvider(this.context);
  String? _error;
  String? _fullName;
  String? _email;
  String? _password;
  bool _loading = false;

  String? get error => _error;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get password => _password;
  bool get loading => _loading;

  void onFullNameChanged(value) {
    _fullName = value;
    notifyListeners();
  }

  void onEmailChanged(value) {
    _email = value;
    notifyListeners();
  }

  void onPasswordChanged(value) {
    _password = value;
    notifyListeners();
  }

  Future<void> signup() async {
    try {
      _setLoading(true);
      notifyListeners();

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email!, password: _password!)
          .then((value) {
        UserModel user = UserModel(
          id: value.user!.uid,
          fullName: _fullName!,
          email: value.user!.email!,
          imageUrl: "",
        );

        saveUserInFireStore(value);
        SharedPreferencesService.saveUserDataOffline(user);
      });

      Navigator.pushReplacementNamed(context, "/login");

      resetError();
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      if (e.code == 'weak-password') {
        _setError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _setError('The account already exists for that email.');
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

  void saveUserInFireStore(UserCredential userCredential) {
    _db
        .collection('users')
        .doc(userCredential.user?.uid)
        .set({'fullName': _fullName, 'email': _email});
  }
}
