import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/common/constants/ui_helpers.dart';
import 'package:firebase_app/common/widgets/k_button.dart';
import 'package:firebase_app/common/widgets/k_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = "";
  String email = "";
  late Future<void> dbFuture;
  final _db = FirebaseFirestore.instance;

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

  Future<void> fetchUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        fullName = userSnapshot['fullName'];
        email = userSnapshot['email'];
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  updateUserData() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(uid);

    documentReference.update({
      'fullName': fullName,
      'email': email,
    });
  }

  @override
  void initState() {
    dbFuture = fetchUserData();
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
                ); // your widget while loading
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              return ListView(
                padding: mPadding,
                children: [
                  KTextFormField(
                    label: "Full name",
                    initialValue: fullName,
                    onChanged: onFullNameChanged,
                    isRequired: false,
                  ),
                  mHeightSpan,
                  KTextFormField(
                    label: "Email",
                    initialValue: email,
                    onChanged: onEmailChanged,
                    isRequired: false,
                  ),
                  mHeightSpan,
                  Row(
                    children: [
                      Expanded(
                        child: KButton(
                          child: const Text("Save"),
                          onPressed: updateUserData,
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
