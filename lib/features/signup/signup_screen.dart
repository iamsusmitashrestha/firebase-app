import 'package:firebase_app/features/signup/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/common_button.dart';
import '../../common/constants/ui_helpers.dart';
import '../../common/widgets/common_text_form_field.dart';
import '../../themes/app_themes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                )),
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
          elHeightSpan,
          Consumer<SignupProvider>(
            builder: (context, value, child) => Container(
              padding: lPadding,
              child: Form(
                key: value.formKey,
                child: Column(
                  children: [
                    KTextFormField(
                      label: "Full Name",
                      onChanged: value.onFullNameChanged,
                      validator: (name) {
                        RegExp regex = RegExp(r"^[A-Z][a-z]*\s[A-Z][a-z]*$");

                        if (name == null || name.isEmpty) {
                          return "Please enter full name";
                        }
                        if (!regex.hasMatch(name)) return "Invalid full name";
                      },
                    ),
                    mHeightSpan,
                    KTextFormField(
                      label: "Email",
                      onChanged: value.onEmailChanged,
                      validator: (email) {
                        RegExp regex =
                            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                        if (email == null || email.isEmpty) {
                          return "Please enter email";
                        }
                        if (!regex.hasMatch(email)) return "Invalid email";
                      },
                    ),
                    mHeightSpan,
                    KTextFormField(
                      label: "Password",
                      isPassword: true,
                      onChanged: value.onPasswordChanged,
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return "Please enter password";
                        }

                        if (password.length < 8) {
                          return "Password must have 8 characters";
                        }
                        if (!password.contains(RegExp(r'[A-Z]'))) {
                          return "Password must have uppercase";
                        }
                        if (!password.contains(RegExp(r'[0-9]'))) {
                          return "Password must have digits";
                        }
                        if (!password.contains(RegExp(r'[a-z]'))) {
                          return "Password must have lowercase";
                        }
                        if (!password.contains(RegExp(r'[#?!@$%^&*-]'))) {
                          return "Password must have special characters";
                        }
                      },
                    ),
                    lHeightSpan,
                    CommonButton(
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        if (value.formKey.currentState!.validate()) {
                          value.signup().then(
                                (v) => {
                                  if (value.error != null)
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: PRIMARY_COLOR,
                                          content: Text(
                                            value.error!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    }
                                },
                              );
                        }
                      },
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
