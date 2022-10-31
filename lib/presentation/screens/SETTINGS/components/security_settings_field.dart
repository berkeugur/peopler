import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../settings.dart';
import '../settings_page_functions.dart';

security_settings_field(context) {
  final Mode _mode = locator<Mode>();
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Gizlilik",
        textScaleFactor: 1,
        style: PeoplerTextStyle.normal.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 23,
          color: _mode.settings_setting_title(),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      MediaQuery.of(context).size.width > 330
          ? Row(
              children: [
                InkWell(
                  onTap: () => op_close_the_everyone(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_profile_close_to_everyone ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg_icons/close_profile.svg",
                            width: 15,
                            height: 15,
                            color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Profilimi gizli tut",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () => op_open_the_everyone(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_profile_open_to_everyone ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg_icons/open_profile.svg",
                            width: 15,
                            height: 15,
                            color: is_selected_profile_open_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Herkese açık",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              color: is_selected_profile_open_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                InkWell(
                  onTap: () => op_close_the_everyone(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_profile_close_to_everyone ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg_icons/close_profile.svg",
                            width: 15,
                            height: 15,
                            color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Profilimi gizli tut",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => op_open_the_everyone(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_profile_open_to_everyone ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg_icons/open_profile.svg",
                            width: 15,
                            height: 15,
                            color: is_selected_profile_open_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Herkese açık",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              color: is_selected_profile_open_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      const SizedBox(
        height: 10,
      ),
      MediaQuery.of(context).size.width > 330
          ? Row(
              children: [
                InkWell(
                  onTap: () => op_close_the_everyone(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_profile_close_to_everyone ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 17,
                            color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Konumumu gizle",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () => op_open_the_everyone(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_profile_open_to_everyone ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 17,
                            color: is_selected_profile_open_to_everyone ? Colors.white : _mode.settings_custom_1(),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Görünür ol",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              color: is_selected_profile_open_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                InkWell(
                  onTap: () => op_close_the_everyone(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_profile_close_to_everyone ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg_icons/close_profile.svg",
                            width: 15,
                            height: 15,
                            color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Profilimi gizli tut",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => op_open_the_everyone(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_profile_open_to_everyone ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/svg_icons/open_profile.svg",
                            width: 15,
                            height: 15,
                            color: is_selected_profile_open_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Herkese açık",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              color: is_selected_profile_open_to_everyone ? Colors.white : _mode.settings_custom_1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    ],
  );
}
