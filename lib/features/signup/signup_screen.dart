import 'package:firebase_app/common/widgets/button_loading_indicator.dart';
import 'package:firebase_app/data/provider/auth_provider.dart';
import 'package:firebase_app/services/validation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants/ui_helpers.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_text_form_field.dart';
import '../../themes/app_themes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final Map<String, String> _userData = {
    'fullName': "",
    'email': "",
    'password': "",
  };

  //saving form
  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      //form invalid
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AuthProvider>(context, listen: false).signup(
          _userData['fullName'], _userData['email']!, _userData['password']!);
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = "";
      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email.";
      } else {
        errorMessage = "Something went wrong. Please try again.";
      }
      _showErrorSnackbar(errorMessage);
    } catch (e) {
      _showErrorSnackbar("Something went wrong. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: PRIMARY_COLOR,
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: const BoxDecoration(
              color: Color(
                0xff203341,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create an account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already has an account ? ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("/login");
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          elHeightSpan,
          Consumer<AuthProvider>(
            builder: (context, data, child) => Container(
              padding: lPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CommonTextFormField(
                      label: "Full Name",
                      validator: ValidatorService.validateFullName,
                      onSaved: (value) {
                        setState(() {
                          _userData['fullName'] = value!;
                        });
                      },
                    ),
                    mHeightSpan,
                    CommonTextFormField(
                      label: "Email",
                      validator: ValidatorService.validateEmail,
                      onSaved: (value) {
                        setState(() {
                          _userData['email'] = value!;
                        });
                      },
                    ),
                    mHeightSpan,
                    CommonTextFormField(
                      label: "Password",
                      isPassword: true,
                      validator: ValidatorService.validatePassword,
                      onSaved: (value) {
                        setState(() {
                          _userData['password'] = value!;
                        });
                      },
                    ),
                    lHeightSpan,
                    CommonButton(
                      onPressed: _saveForm,
                      child: _isLoading
                          ? const ButtonLoadingIndicator()
                          : const Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
