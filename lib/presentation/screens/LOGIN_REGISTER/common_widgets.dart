import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

SizedBox subtitle(double screenWidth) {
  return SizedBox(
    height: 28,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '''"bulunabilir ol ve bul"''',
          style: GoogleFonts.rubik(
              color: const Color(0xFF000B21), fontWeight: FontWeight.w800, fontSize: screenWidth < 360 ? 15 : 24),
        ),
      ],
    ),
  );
}

Container solidLine(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    width: MediaQuery.of(context).size.width,
    height: 2,
    color: const Color(0xFF000B21),
  );
}

SizedBox titleRow2(double screenWidth) {
  return SizedBox(
    height: 60,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Hoşgeldin",
          style: GoogleFonts.rubik(
              color: const Color(0xFF000B21), fontWeight: FontWeight.w800, fontSize: screenWidth < 350 ? 32 : 48),
        ),
        Text(
          '!',
          style: GoogleFonts.rubik(
              color: const Color(0xFF0353EF), fontWeight: FontWeight.w800, fontSize: screenWidth < 350 ? 32 : 48),
        ),
      ],
    ),
  );
}

SizedBox titleRow1(double screenWidth) {
  return SizedBox(
    height: 60,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'peopler',
          style: GoogleFonts.spartan(
              color: const Color(0xFF0353EF), fontWeight: FontWeight.w800, fontSize: screenWidth < 350 ? 32 : 48),
        ),
        Text(
          "'a",
          style: GoogleFonts.rubik(
              color: const Color(0xFF000B21), fontWeight: FontWeight.w800, fontSize: screenWidth < 350 ? 32 : 48),
        ),
      ],
    ),
  );
}
