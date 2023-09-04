import 'package:firebase_app/common/constants/ui_helpers.dart';
import 'package:firebase_app/common/widgets/k_button.dart';
import 'package:firebase_app/common/widgets/k_text_form_field.dart';
import 'package:firebase_app/features/login/reset_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_themes.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResetPasswordProvider resetProvider =
        Provider.of<ResetPasswordProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: const BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Text(
                  "Forget Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  KTextFormField(
                    label: "Email",
                    onChanged: resetProvider.onEmailChanged,
                  ),
                  mHeightSpan,
                  KButton(
                    onPressed: resetProvider.resetPassword,
                    child: const Text("Reset Password"),
                  ),
                  mHeightSpan,
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/login");
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
            ),
          ],
        ),
      ),
    );
  }
}
