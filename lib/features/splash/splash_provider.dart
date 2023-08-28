import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  final BuildContext context;

  SplashProvider(this.context) {
    initialise();
  }

  initialise() {
    Future.delayed(const Duration(milliseconds: 1000), () async {
      await Navigator.pushReplacementNamed(context, "/login");
    });
  }
}
