import 'package:flutter/material.dart';
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
    height: 70,
    color: _mode.search_peoples_scaffold_background(),
    child: Padding(
      padding: EdgeInsets.only(
        top: _size.width < 340 ? 15 : 10.0,
        left: 15,
        right: 15,
        bottom: 5.0,
      ),
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,

              //AutoSizeİleDeğiştir
              child: Text(
                "Listem",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: _mode.blackAndWhiteConversion(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
