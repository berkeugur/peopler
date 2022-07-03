import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/locator.dart';
import '../../Settings/settings_page_functions.dart';



Container channelListTopMenu (context){

  final Mode _mode = locator<Mode>();
  
  return Container(
    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
    color: _mode.bottomMenuBackground(),
    height: 70,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: (){
            op_settings_back_arrow(context);
          },
          child: SizedBox(
            width: 25,
            height: 25,
            child: SvgPicture.asset(
              "assets/images/svg_icons/back_arrow.svg",
              width: 25,
              height: 25,
              color: _mode.homeScreenIconsColor(),
              fit: BoxFit.contain,
            ),
          ),
        ),
        InkWell(
          onTap: () => op_settings_peopler_title(),
          child: AutoSizeText(
            "peopler",
            textScaleFactor: 1,
            style: GoogleFonts.spartan(color: _mode.homeScreenTitleColor(), fontWeight: FontWeight.w900, fontSize: 32),
          ),
        ),
        const SizedBox(
          width: 25,
          height: 25,
        )
      ],
    ),
  );
}