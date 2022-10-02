import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../others/classes/responsive_size.dart';
import 'constants.dart';

class ExplanationPage extends StatelessWidget {
  final TutorialScreenData screen;

  const ExplanationPage({Key? key, required this.screen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: ResponsiveSize().ob2(context), bottom: 16),
              child: SvgPicture.asset(screen.localImageSrc, height: MediaQuery.of(context).size.height * 0.33, alignment: Alignment.center)),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  screen.title,
                  textScaleFactor: 1,
                  style: GoogleFonts.spartan(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0353EF),
                    fontSize: ResponsiveSize().ob1(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      screen.description,
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(color: const Color(0xFF000B21), fontSize: ResponsiveSize().ob3(context), fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
