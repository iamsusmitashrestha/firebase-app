import 'package:firebase_app/features/login/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_app/themes/app_themes.dart';
import 'package:provider/provider.dart';

import '../../common/constants/ui_helpers.dart';
import '../../common/widgets/k_button.dart';
import '../../common/widgets/k_text_form_field.dart';
import '../profile/profile_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const ProfileScreen();
            } else {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: const BoxDecoration(
                          color: PRIMARY_COLOR,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign in to your account",
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
                                "Doesn't have account ? ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
                    elHeightSpan,
                    Consumer<AuthProvider>(
                      builder: (context, value, child) => Container(
                        padding: lPadding,
                        child: Column(
                          children: [
                            KTextFormField(
                              label: "Email",
                              validator: (value) {
                                RegExp regex =
                                    RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                                if (!regex.hasMatch(value!)) {
                                  return "Invalid email";
                                }
                                return null;
                              },
                              onChanged: value.onEmailChanged,
                            ),
                            mHeightSpan,
                            KTextFormField(
                              label: "Password",
                              obscureText: true,
                              validator: (value) {
                                RegExp regex = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                } else {
                                  if (!regex.hasMatch(value)) {
                                    return 'Enter valid password';
                                  } else {
                                    return null;
                                  }
                                }
                              },
                              onChanged: value.onPasswordChanged,
                            ),
                            elHeightSpan,
                            KButton(
                                child: const Text(
                                  "Sign in",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: () {
                                  value.login().then((v) => {
                                        if (value.error != null)
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: PRIMARY_COLOR,
                                                content: Text(
                                                  value.error!,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          }
                                        else
                                          {
                                            Navigator.pushReplacementNamed(
                                                context, "/profile")
                                          }
                                      });
                                })
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
