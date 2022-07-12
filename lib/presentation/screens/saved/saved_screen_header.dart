import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/presentation/screens/saved/how_it_work.dart';

import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';

// ignore: non_constant_identifier_names
Widget saved_screen_header({required BuildContext context}) {
  final Mode _mode = locator<Mode>();
  print("header oluşturuldu");
  Size _size = MediaQuery.of(context).size;
  double _x = 20; //amount of space between two containers
  double _y = _size.width > 600 ? 280 : _size.width * 0.40; //the ratio of each container to the screen

  return AnimatedContainer(
    duration: const Duration(milliseconds: 0),
    width: MediaQuery.of(context).size.width,
    height: 90,
    color: _mode.search_peoples_scaffold_background(),
    child: Padding(
      padding: EdgeInsets.only(
        top: _size.width < 340 ? 15 : 10.0,
        left: 15,
        right: 15,
        bottom: 5.0,
      ),
      child: SizedBox(
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: SvgPicture.asset(
                    "assets/images/svg_icons/back_arrow.svg",
                    width: 25,
                    height: 25,
                    color: _mode.homeScreenIconsColor(),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 24,

                  //AutoSizeİleDeğiştir
                  child: Text(
                    "Listem",
                    textScaleFactor: 1,
                    style: GoogleFonts.rubik(
                      color: _mode.homeScreenTitleColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                howItWork(context);

                print("nasıl çalışır");
              },
              child: SizedBox(
                height: 20,
                child: Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF0353EF),
                      size: 14,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Nasıl Çalışır?",
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Color(0xFF0353EF),
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
