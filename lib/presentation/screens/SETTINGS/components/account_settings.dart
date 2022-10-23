import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/visibility/widget_visibility.dart';
import 'package:peopler/others/locator.dart';
import 'package:peopler/presentation/screens/BLOCKED/blocked_users.dart';
import 'package:peopler/presentation/screens/REMAINING_USAGE_RIGHTS/rur.dart';
import 'package:peopler/presentation/screens/SETTINGS/settings.dart';
import 'package:peopler/presentation/screens/SETTINGS/settings_page_functions.dart';

import '../../../../others/classes/dark_light_mode_controller.dart';

accountSettings(context) {
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
          "Hesabım",
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
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const BlockedUsersScreen(),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
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
                  "Engellenen Kullanıcılar",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                    fontSize: 16,
                    color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (WidgetVisibility.isRemainingUsageRightsButtonInSettingsScreenVisiable)
          const SizedBox(
            height: 10,
          ),
        if (WidgetVisibility.isRemainingUsageRightsButtonInSettingsScreenVisiable)
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RemainingUsageRights(),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    "assets/images/svg_icons/continue_arrow.svg",
                    width: 20,
                    height: 20,
                    color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Kalan Kullanım Haklarım",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      fontSize: 16,
                      color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_2(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        //Container(width: 10,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),)
      ],
    ),
  );
}
