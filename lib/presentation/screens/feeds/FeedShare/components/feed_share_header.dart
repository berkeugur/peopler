import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/classes/responsive_size.dart';
import '../../../../../others/locator.dart';
import '../feed_share_functions.dart';

Padding header(BuildContext context) {
  final Mode _mode = locator<Mode>();
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                feed_share_back_icon_on_pressed(context);
              },
              icon: SizedBox(
                width: ResponsiveSize().fs3(context) + 10,
                height: ResponsiveSize().fs3(context) + 10,
                child: Icon(
                  Icons.close,
                  color: _mode.blackAndWhiteConversion(),
                  size: ResponsiveSize().fs3(context),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            LimitedBox(
              maxWidth: MediaQuery.of(context).size.width - 165,
              child: Text(
                "Gönderi Paylaş",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                  color: _mode.blackAndWhiteConversion(),
                  fontSize: ResponsiveSize().fs1(context),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
            width: 80,
            child: TextButton(
                onPressed: () => feed_share_button_on_pressed(context),
                child: Text(
                  "Paylaş",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                      fontSize: ResponsiveSize().fs2(context),
                      color: const Color(0xFF0353EF)),
                )))
      ],
    ),
  );
}
