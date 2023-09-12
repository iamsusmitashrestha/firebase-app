import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../../services/shared_preference_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<void> fetchUserData() async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(uid).get();

      _currentUser = UserModel(
          id: uid,
          fullName: userSnapshot['fullName'],
          email: userSnapshot['email'],
          imageUrl: userSnapshot['imageUrl']);
      await SharedPreferencesService.saveUserDataOffline(_currentUser!);
    } catch (e) {
      print("Error fetching data: $e");
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      await fetchUserData();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserData(String fullName, String email) async {
    try {
      //TODO: Add image file and upload it to firebase storage
      // Get url from firebase storage and update it with imageUrl
      final DocumentReference documentReference =
          _firestore.collection('users').doc(_currentUser!.id);

      await documentReference.update({
        'fullName': fullName,
        'email': email,
      });

      await _firebaseAuth.currentUser!.updateEmail(email);
      _currentUser!.copyWith(email: email, fullName: fullName);

      await SharedPreferencesService.saveUserDataOffline(_currentUser!);
      notifyListeners();
    } catch (e) {
      print("Error on updating user details $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await SharedPreferencesService.clearUserData();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> autoLogin() async {
    try {
      _currentUser = await SharedPreferencesService.getUserDataOffline();
      notifyListeners();
      return currentUser != null;
    } catch (e) {
      return false;
    }
  }
}
