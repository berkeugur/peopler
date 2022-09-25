import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/WelcomeScreen/welcome_functions.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../settings_page_functions.dart';

// ignore: non_constant_identifier_names
about_field(context) {
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
          "Hakkında",
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
          borderRadius: BorderRadius.circular(999),
          onTap: () => op_suggestion_or_complaint(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: _mode.settings_custom_1(),
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  MediaQuery.of(context).size.width > 300 ? "Görüş, öneri veya şikayet bildir" : "Görüş, öneri veya \nşikayet bildir",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Container(width: 15,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),),

        const SizedBox(
          height: 10,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => termOfUseTextOnPressed(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/svg_icons/book_1.svg",
                  width: 20,
                  height: 20,
                  color: _mode.settings_custom_1(),
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Kullanım Şartları",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Container(width: 15,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),),

        const SizedBox(
          height: 10,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => show_privacy_policy(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/svg_icons/book_2.svg",
                  width: 20,
                  height: 20,
                  color: _mode.settings_custom_1(),
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Gizlilik Sözleşmesi",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Container(width: 15,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),),

        const SizedBox(
          height: 10,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => op_sign_out(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.west_outlined,
                  color: _mode.settings_custom_1(),
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Çıkış Yap",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Container(width: 15,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),),
      ],
    ),
  );
}
