import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../business_logic/cubits/ThemeCubit.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';

// ignore: non_constant_identifier_names
theme_settings_field(context) {
  final Mode _mode = locator<Mode>();
  final ThemeCubit _themeCubit = BlocProvider.of<ThemeCubit>(context);
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Tema",
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
      Row(
        children: [
          InkWell(
            onTap: () => _themeCubit.openLightMode(),
            child: Container(
              decoration: BoxDecoration(
                color: Mode.isEnableDarkMode == false ? const Color(0xFF0353EF) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/svg_icons/light_mode.svg",
                      width: 15,
                      height: 15,
                      color: Mode.isEnableDarkMode == false ? Colors.white : _mode.settings_custom_1(),
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Aydınlık",
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(
                        color: Mode.isEnableDarkMode == false ? Colors.white : _mode.settings_custom_1(),
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
            onTap: () => _themeCubit.openDarkMode(),
            child: Container(
              decoration: BoxDecoration(
                color: Mode.isEnableDarkMode == true ? Color(0xFF0353EF) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/svg_icons/dark_mode.svg",
                      width: 15,
                      height: 15,
                      color: Mode.isEnableDarkMode == true ? Colors.white : _mode.settings_custom_1(),
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Karanlık",
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(
                        color: Mode.isEnableDarkMode == true ? Colors.white : _mode.settings_custom_1(),
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
