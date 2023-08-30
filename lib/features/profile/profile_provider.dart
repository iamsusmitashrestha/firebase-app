import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String fullName = "";
  String email = "";

  void initialise() {
    fetchUserData();
  }

  void onFullNameChanged(value) {
    fullName = value;
    notifyListeners();
  }

  void onEmailChanged(value) {
    email = value;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setValues() {
      fullName = userSnapshot['fullName'];
      email = userSnapshot['email'];
      notifyListeners();
    }
  }
}
