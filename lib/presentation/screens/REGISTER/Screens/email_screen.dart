import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';

Widget registerEmail({
  required BuildContext context,
  required PageController pageController,
  required TextEditingController textEditingController,
}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Öğrenci Mailin (.edu.tr)",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(
              color: const Color(0xFF000000),
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF0353EF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            onFieldSubmitted: (_) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear,
              );
              FocusScope.of(context).unfocus();
            },
            autofocus: true,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            cursorColor: const Color(0xFFFFFFFF),
            maxLength: MaxLengthConstants.EMAIL,
            controller: textEditingController,
            autocorrect: true,
            decoration: const InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              hintMaxLines: 1,
              border: InputBorder.none,
              hintText: 'isimsoyisim@uni.edu.tr',
              hintStyle: TextStyle(color: Color(0xFF9ABAF9), fontSize: 16),
            ),
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: RichText(
            text: TextSpan(children: [
              const TextSpan(
                text: "Öğrenci mailin yok ise ",
                style: TextStyle(
                  color: Color(0xFF000B21),
                  fontWeight: FontWeight.w300,
                  fontFamily: "Rubik",
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0,
                ),
              ),
              TextSpan(
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Rubik",
                  fontStyle: FontStyle.italic,
                  fontSize: 16.0,
                  // decoration: TextDecoration.underline,
                ),
                text: "Linkedin ile giriş",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // show_privacy_policy(context);
                  },
              ),
              const TextSpan(
                text: " yapabilir veya ",
                style: TextStyle(color: Color(0xFF000B21), fontWeight: FontWeight.w300, fontFamily: "Rubik", fontStyle: FontStyle.normal, fontSize: 15.0),
              ),
              TextSpan(
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Rubik",
                  fontStyle: FontStyle.italic,
                  fontSize: 16.0,
                  // decoration: TextDecoration.underline,
                ),
                text: "bekleme listesine katıl",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // show_privacy_policy(context);
                  },
              ),
              const TextSpan(
                text: "abilirsin.",
                style: TextStyle(color: Color(0xFF000B21), fontWeight: FontWeight.w300, fontFamily: "Rubik", fontStyle: FontStyle.normal, fontSize: 15.0),
              ),
            ]),
          ),
        ),
      ],
    ),
  );
}
