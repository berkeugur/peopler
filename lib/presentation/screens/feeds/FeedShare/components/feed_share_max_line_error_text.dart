import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../others/classes/variables.dart';

Visibility maxLineError() {
  return Visibility(
    ///feed controller ın içerisinde 3 satır yani \n var ise uyarı gözükür 3 den az var ise gözükmez.
    visible: feedController.text.split('\n').length == 3 ? true : false,
    child: Text(
      "Uyarı: Daha fazla satır atlayamazsınız!",
      textScaleFactor: 1,
      style: GoogleFonts.rubik(
        color: Colors.redAccent,
      ),
    ),
  );
}
