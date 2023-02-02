import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/length/max_length_constants.dart';
import '../../../../../others/classes/variables.dart';

Container emailFormField(StateSetter setState, double screenWidth) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.only(top: 10),
    height: 50,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: const Color(0xFF0353EF),
      maxLength: MaxLengthConstants.EMAIL,
      controller: loginEmailController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
        hintMaxLines: 1,
        border: InputBorder.none,
        hintText: 'isimsoyisim@uni.edu.tr',
        hintStyle: GoogleFonts.dmSans(
          color: Colors.grey[500],
        ),
      ),
      style: GoogleFonts.dmSans(
        color: Colors.grey[800],
      ),
      autofillHints: const [AutofillHints.email],
    ),
  );
}
