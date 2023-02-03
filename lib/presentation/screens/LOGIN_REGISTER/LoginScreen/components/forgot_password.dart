import 'package:flutter/material.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

import '../../../../../core/constants/navigation/navigation_constants.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed(NavigationConstants.RESET_PASSWORD_SCREEN);
      },
      child: Text(
        "Şifremi Unuttum",
        textScaleFactor: 1,
        style: PeoplerTextStyle.normal.copyWith(
          color: const Color(0xFF0353EF),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
