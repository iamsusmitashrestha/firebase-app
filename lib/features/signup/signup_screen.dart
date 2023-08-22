import 'package:flutter/material.dart';

import '../../common/widgets/k_button.dart';
import '../../common/constants/ui_helpers.dart';
import '../../common/widgets/k_text_form_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
                      onTap: () {},
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
          Container(
            padding: lPadding,
            child: Column(
              children: [
                KTextFormField(
                  label: "Full Name",
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
                  validator: (email) {
                    RegExp regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                    if (email == null || email.isEmpty) {
                      return "Please enter email";
                    }
                    if (!regex.hasMatch(email)) return "Invalid email";
                  },
                ),
                mHeightSpan,
                KTextFormField(
                  label: "Password",
                  obscureText: true,
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
                elHeightSpan,
                KButton(
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                )
              ],
            ),
          ),
          lHeightSpan,
        ],
      ),
    );
  }
}
