import 'package:firebase_app/common/constants/asset_source.dart';
import 'package:firebase_app/data/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      final isLoggedIn =
          await Provider.of<AuthProvider>(context, listen: false).autoLogin();
      if (mounted) {
        if (isLoggedIn) {
          Navigator.pushReplacementNamed(context, "/profile");
        } else {
          Navigator.pushReplacementNamed(context, "/login");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          AssetSource.logo,
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
