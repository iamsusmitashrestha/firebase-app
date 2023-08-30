import 'package:firebase_app/common/widgets/k_button.dart';
import 'package:firebase_app/common/widgets/k_text_form_field.dart';
import 'package:firebase_app/features/profile/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context);
    profileProvider.fetchUserData();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            KTextFormField(
              initialValue: profileProvider.fullName,
            ),
            KTextFormField(
              initialValue: profileProvider.email,
            ),
            SizedBox(
              width: 200,
              child: KButton(
                child: Text("Save"),
                onPressed: () {},
              ),
            ),
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
