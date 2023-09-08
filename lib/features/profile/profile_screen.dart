import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/common/constants/ui_helpers.dart';
import 'package:firebase_app/common/widgets/k_button.dart';
import 'package:firebase_app/common/widgets/k_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user.dart';
import '../../services/shared_preference_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = "";
  String email = "";
  bool _loading = false;
  late Future<UserModel> dbFuture;
  final prefs = SharedPreferencesService();

  void onFullNameChanged(value) {
    setState(() {
      fullName = value;
    });
  }

  void onEmailChanged(value) {
    setState(() {
      email = value;
    });
  }

  updateUserData() async {
    try {
      _setLoading(true);
      final user = FirebaseAuth.instance.currentUser;
      String uid = FirebaseAuth.instance.currentUser!.uid;

      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc(uid);

      UserModel userModel = UserModel(
        id: uid,
        fullName: fullName,
        email: email,
      );

      await documentReference.update({
        'fullName': fullName,
        'email': email,
      });

      await user!.updateEmail(email);

      prefs.saveUserDataOffline(userModel);

      _setLoading(false);
    } catch (e) {
      print("Error on updating user details $e");
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  @override
  void initState() {
    dbFuture = prefs.getUserDataOffline();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final user = _firebaseAuth.currentUser!;

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: dbFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              final userModel = snapshot.data;

              return ListView(
                padding: mPadding,
                children: [
                  KTextFormField(
                    label: "Full name",
                    initialValue: userModel.fullName,
                    onChanged: onFullNameChanged,
                    isRequired: false,
                  ),
                  mHeightSpan,
                  KTextFormField(
                    label: "Email",
                    initialValue: userModel.email,
                    onChanged: onEmailChanged,
                    isRequired: false,
                  ),
                  mHeightSpan,
                  Row(
                    children: [
                      Expanded(
                        child: KButton(
                          onPressed: updateUserData,
                          child: _loading
                              ? const CircularProgressIndicator()
                              : const Text("Save"),
                        ),
                      ),
                      elWidthSpan,
                      Expanded(
                        child: KButton(
                            child: const Text("Logout"),
                            onPressed: () => {
                                  _firebaseAuth.signOut(),
                                  Navigator.of(context)
                                      .pushReplacementNamed("/login"),
                                }),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
