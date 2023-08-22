import 'package:firebase_app/features/login/login_screen.dart';
import 'package:firebase_app/features/profile/profile_screen.dart';
import 'package:firebase_app/features/signup/signup_screen.dart';
import 'package:flutter/material.dart';

import 'features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignupScreen(),
        "/profile": (context) => const ProfileScreen(),
      },
    );
  }
}
