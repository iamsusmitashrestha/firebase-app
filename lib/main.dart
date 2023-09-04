import 'package:firebase_app/features/login/auth_provider.dart';
import 'package:firebase_app/features/login/login_screen.dart';
import 'package:firebase_app/features/login/reset_password_provider.dart';
import 'package:firebase_app/features/login/reset_password_screen.dart';
import 'package:firebase_app/features/profile/profile_screen.dart';
import 'package:firebase_app/features/signup/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        "/login": (context) => ChangeNotifierProvider(
              create: (context) => AuthProvider(context),
              child: LoginScreen(),
            ),
        "/signup": (context) => const SignupScreen(),
        "/profile": (context) => const ProfileScreen(),
        "/reset": (context) => ChangeNotifierProvider(
              create: (context) => ResetPasswordProvider(),
              child: ResetPasswordScreen(),
            ),
      },
    );
  }
}
