import 'package:firebase_app/common/widgets/button_loading_indicator.dart';
import 'package:firebase_app/data/provider/auth_provider.dart';
import 'package:firebase_app/utils/validation_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants/ui_helpers.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_text_form_field.dart';
import '../../utils/snackbar_util.dart';

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
        SnackbarUtil.showSnackbar(context, "Account created successfully");
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
      SnackbarUtil.showSnackbar(context, errorMessage);
    } catch (e) {
      SnackbarUtil.showSnackbar(
          context, "Something went wrong. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: mPagePadding,
          children: [
            Image.asset(
              "./assets/images/logo.png",
              height: 200,
              width: 200,
            ),
            mHeightSpan,
            const Text(
              "Create Your Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            mHeightSpan,
            Consumer<AuthProvider>(
              builder: (context, data, child) => Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CommonTextFormField(
                        label: "Full Name",
                        validator: ValidationUtils.validateFullName,
                        onSaved: (value) {
                          setState(() {
                            _userData['fullName'] = value!;
                          });
                        },
                      ),
                      mHeightSpan,
                      CommonTextFormField(
                        label: "Email",
                        validator: ValidationUtils.validateEmail,
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
                        validator: ValidationUtils.validatePassword,
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
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      sHeightSpan,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already has an account ? ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("/login");
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.purple,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
