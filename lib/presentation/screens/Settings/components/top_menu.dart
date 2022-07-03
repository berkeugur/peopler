import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../../../tab_item.dart';
import '../settings_page_functions.dart';

Container topMenu(context) {
  final Mode _mode = locator<Mode>();
      return Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        color: _mode.bottomMenuBackground(),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
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
              child: SizedBox(
                width: 140,
                child: AutoSizeText(
                  "peopler",
                  textScaleFactor: 1,
                  style: GoogleFonts.spartan(
                      color: _mode.homeScreenTitleColor(),
                      fontWeight: FontWeight.w900,
                      fontSize: 32),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
                _homeScreen.navigatorKeys[TabItem.feed]!.currentState!.pushNamed('/chat');
              },
              child: SvgPicture.asset(
                "assets/images/svg_icons/message_icon.svg",
                width: 25,
                height: 25,
                color: _mode.homeScreenIconsColor(),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
  );
}
