import 'package:flutter/material.dart';

import '../../themes/app_themes.dart';
import '../constants/ui_helpers.dart';

class CommonButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  const CommonButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: mPadding,
        backgroundColor: PRIMARY_COLOR,
        fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      child: child,
    );
  }
}
