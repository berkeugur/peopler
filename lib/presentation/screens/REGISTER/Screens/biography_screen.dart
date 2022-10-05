import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';

Widget registerBiography({
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
            "Kendini Tanıt",
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
            keyboardType: TextInputType.text,
            cursorColor: const Color(0xFFFFFFFF),
            maxLength: MaxLengthConstants.DISPLAYNAME,
            controller: textEditingController,
            autocorrect: true,
            decoration: const InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              hintMaxLines: 1,
              border: InputBorder.none,
              hintText: 'Örneğin, Kedileri Severim.',
              hintStyle: TextStyle(color: Color(0xFF9ABAF9), fontSize: 16),
            ),
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Diğer insanların seni tanıması için kendinden birkaç kelime ile bahsedebilirsin.",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(
              color: const Color(0xFF000B21),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    ),
  );
}
