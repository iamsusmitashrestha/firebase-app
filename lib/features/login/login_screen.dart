import 'package:firebase_app/common/widgets/button_loading_indicator.dart';
import 'package:firebase_app/data/provider/auth_provider.dart';
import 'package:firebase_app/services/validation_service.dart';
import 'package:firebase_app/themes/app_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants/ui_helpers.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final Map<String, String> _authData = {
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
      await Provider.of<AuthProvider>(context, listen: false)
          .login(_authData['email']!, _authData['password']!);
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/profile");
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = "";
      if (e.code == 'user-not-found') {
        errorMessage = "User Not Found";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect Password";
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: ListView(
            padding: sPagePadding,
            children: [
              Column(
                children: [
                  Image.asset(
                    "./assets/images/man.jpg",
                    width: 300,
                    height: 300,
                  ),
                ],
              ),
              mHeightSpan,
              Consumer<AuthProvider>(
                builder: (context, value, child) => Container(
                  padding: lPadding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        mHeightSpan,
                        CommonTextFormField(
                          label: "Email",
                          validator: ValidatorService.validateEmail,
                          onChanged: (value) {
                            setState(() {
                              _authData['email'] = value;
                            });
                          },
                        ),
                        mHeightSpan,
                        CommonTextFormField(
                          label: "Password",
                          isPassword: true,
                          validator: ValidatorService.validatePassword,
                          onChanged: (value) {
                            setState(() {
                              _authData['password'] = value;
                            });
                          },
                        ),
                        lHeightSpan,
                        CommonButton(
                          onPressed: _saveForm,
                          child: _isLoading
                              ? const ButtonLoadingIndicator()
                              : const Text(
                                  "Sign in",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        mHeightSpan,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Doesn't have account ?",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, "/signup");
                              },
                              child: const Text(
                                "Sign up",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
