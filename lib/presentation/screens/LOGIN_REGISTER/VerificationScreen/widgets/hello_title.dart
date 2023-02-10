import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class HelloTitle extends StatelessWidget {
  final String? userName;
  const HelloTitle({
    Key? key,
    this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (userName != null && userName != "")
            Text(
              "Merhaba, $userName",
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
