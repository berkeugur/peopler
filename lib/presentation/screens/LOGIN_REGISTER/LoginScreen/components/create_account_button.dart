import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';

class CreateNewAccountButton extends StatelessWidget {
  const CreateNewAccountButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Hesabınız yok mu? ",
              style: GoogleFonts.dmSans(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
              ),
            ),
            TextSpan(
              style: GoogleFonts.dmSans(
                color: const Color(0xFF0353EF),
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
              text: "Hesap Oluşturun",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushReplacementNamed(NavigationConstants.NAME_SCREEN);
                },
            ),
          ],
        ),
      ),
    );
  }
}
