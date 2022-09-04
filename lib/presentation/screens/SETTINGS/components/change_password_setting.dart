import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../settings.dart';
import '../settings_page_functions.dart';

changePasswordField(context) {
  final Mode _mode = locator<Mode>();
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Güvenlik",
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w400,
            fontSize: 23,
            color: _mode.settings_setting_title(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () => op_change_password(context),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/images/svg_icons/password_lock.svg",
                width: 20,
                height: 20,
                color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                fit: BoxFit.contain,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Şifre Değiştir",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_2(),
                ),
              ),
            ],
          ),
        ),
        //Container(width: 10,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),)
      ],
    ),
  );
}
