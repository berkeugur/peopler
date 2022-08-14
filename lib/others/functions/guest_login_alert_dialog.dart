import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuestAlert {
  static dialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Giriş Yapmalısınız.",
              style: GoogleFonts.rubik(
                color: Color(0xFF0353EF),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Kapat",
                    style: GoogleFonts.rubik(
                      color: Color(0xFF0353EF),
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    //98865896
                    //welcomescreen a git
                  },
                  child: Text(
                    "Giriş Yap",
                    style: GoogleFonts.rubik(
                      color: Color(0xFF0353EF),
                    ),
                  )),
            ],
          );
        });
  }
}
