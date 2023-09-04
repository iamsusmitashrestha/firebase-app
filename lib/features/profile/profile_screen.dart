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
      // userRef.get().then(
      //     (DocumentSnapshot documentSnapshot) => {print(documentSnapshot)});
      setState(() {
        fullName = userSnapshot['fullName'];
        email = userSnapshot['email'];
      });
      print("Data fetched successfully");
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    fetchUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: mPadding,
          children: [
            KTextFormField(
              label: "Full name",
              initialValue: user.displayName,
              onChanged: onFullNameChanged,
              isRequired: false,
            ),
            mHeightSpan,
            KTextFormField(
              label: "Email",
              initialValue: user.email,
              onChanged: onEmailChanged,
              isRequired: false,
            ),
            mHeightSpan,
            SizedBox(
              width: 200,
              child: KButton(
                  child: const Text("Logout"),
                  onPressed: () => {
                        _firebaseAuth.signOut(),
                        Navigator.of(context).pushReplacementNamed("/login"),
                      }),
            )
          ],
        ),
      ),
    );
  }
}
