import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupProvider extends ChangeNotifier {
  final BuildContext context;
  final _db = FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final formKey = GlobalKey<FormState>();

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

  void saveUserDataOffline(String fullName, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fullName', fullName);
    prefs.setString('email', email);
  }

  Future<Map<String, String>> getUserDataOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fullName = prefs.getString('fullName') ?? '';
    String email = prefs.getString('email') ?? '';
    return {'fullName': fullName, 'email': email};
  }

  Future<void> signup() async {
    try {
      _setLoading(true);
      notifyListeners();

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email!, password: _password!);

      // Create a new user with a first and last name
      final user = <String, dynamic>{
        "fullName": _fullName,
        "email": _email,
      };

// Add a new document with a generated ID
      _db.collection("users").add(user).then((DocumentReference doc) =>
          print('Hello DocumentSnapshot added with ID: ${doc.id}'));

      saveUserDataOffline(_fullName!, _email!);

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
}
