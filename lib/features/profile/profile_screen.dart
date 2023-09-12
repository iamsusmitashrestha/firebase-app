import 'package:firebase_app/common/constants/ui_helpers.dart';
import 'package:firebase_app/common/widgets/common_button.dart';
import 'package:firebase_app/common/widgets/common_text_form_field.dart';
import 'package:firebase_app/data/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _fullName = "";
  String _email = "";
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  void updateUserData() async {
    if (_formKey.currentState?.validate() == false) {
      return;
    }
    _formKey.currentState!.save();
    try {
      _setLoading(true);

      await Provider.of<AuthProvider>(context, listen: false)
          .updateUserData(_fullName, _email);
    } catch (e) {
      print("Error on updating user details $e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(builder: (context, data, child) {
          final currentUser = data.currentUser!;
          return ListView(
            padding: lPadding,
            children: [
              Card(
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "USER DETAILS",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        mHeightSpan,
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: currentUser.imageUrl.isNotEmpty
                              ? NetworkImage(currentUser.imageUrl)
                              : null,
                        ),
                        mHeightSpan,
                        KTextFormField(
                          label: "Full name",
                          initialValue: currentUser.fullName,
                          onSaved: (value) {
                            setState(() {
                              _fullName = value ?? '';
                            });
                          },
                        ),
                        mHeightSpan,
                        KTextFormField(
                          label: "Email",
                          initialValue: currentUser.email,
                          onSaved: (value) {
                            setState(() {
                              _email = value ?? '';
                            });
                          },
                        ),
                        mHeightSpan,
                        Row(
                          children: [
                            Expanded(
                              child: CommonButton(
                                onPressed: updateUserData,
                                child: _loading
                                    ? const CircularProgressIndicator()
                                    : const Text("Save"),
                              ),
                            ),
                            elWidthSpan,
                            Expanded(
                              child: CommonButton(
                                  child: const Text("Logout"),
                                  onPressed: () async {
                                    await Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .logout();
                                    Navigator.of(context)
                                        .pushReplacementNamed("/login");
                                  }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
