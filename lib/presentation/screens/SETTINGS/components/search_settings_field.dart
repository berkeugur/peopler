import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../settings.dart';
import '../settings_page_functions.dart';

search_settings_field(context) {
  final Mode _mode = locator<Mode>();
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Arama",
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
      MediaQuery.of(context).size.width > 330
          ? Row(
              children: [
                InkWell(
                  onTap: () => op_in_the_same_environment(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_in_the_same_environment ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        "Aynı Ortamımdaki",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(
                          color: is_selected_in_the_same_environment ? Colors.white : _mode.settings_custom_1(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () => op_in_the_same_city(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_in_the_same_city ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        "Aynı Şehrimdeki",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(
                          color: is_selected_in_the_same_city ? Colors.white : _mode.settings_custom_1(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => op_in_the_same_environment(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_in_the_same_environment ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Aynı Ortamımdaki",
                            textScaleFactor: 1,
                            style: GoogleFonts.rubik(
                              color: is_selected_in_the_same_environment ? Colors.white : _mode.settings_custom_1(),
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
                  onTap: () => op_in_the_same_city(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: is_selected_in_the_same_city ? Color(0xFF0353EF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Aynı Şehrimdeki",
                            textScaleFactor: 1,
                            style: GoogleFonts.rubik(
                              color: is_selected_in_the_same_city ? Colors.white : _mode.settings_custom_1(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
    ],
  );
}
