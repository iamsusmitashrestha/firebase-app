import 'package:firebase_app/common/constants/ui_helpers.dart';
import 'package:firebase_app/common/widgets/button_loading_indicator.dart';
import 'package:firebase_app/common/widgets/common_button.dart';
import 'package:firebase_app/common/widgets/common_text_form_field.dart';
import 'package:firebase_app/data/provider/auth_provider.dart';
import 'package:firebase_app/utils/validation_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/snackbar_util.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String? _email;
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AuthProvider>(context, listen: false)
          .resetPassword(_email!);
      if (mounted) {
        SnackbarUtil.showSnackbar(
            context, "Password reset email has been sent");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        SnackbarUtil.showSnackbar(context, "No user found for that email");
      }
    } catch (e) {
      SnackbarUtil.showSnackbar(
          context, "Something went wrong. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: mPagePadding,
          children: [
            sHeightSpan,
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    "./assets/images/arrow.png",
                    height: 24,
                    width: 24,
                  )),
            ),
            mHeightSpan,
            const Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            mHeightSpan,
            const Text(
              "Enter email associated with your account and we will send you password reset link.",
              style: TextStyle(fontSize: 16),
            ),
            lHeightSpan,
            Column(
              children: [
                CommonTextFormField(
                  label: "Email",
                  validator: ValidationUtils.validateEmail,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                mHeightSpan,
                CommonButton(
                  onPressed: _resetPassword,
                  child: _isLoading
                      ? const ButtonLoadingIndicator()
                      : const Text(
                          "Send Reset Email",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
