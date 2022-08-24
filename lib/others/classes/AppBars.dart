import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/ProfileScreen/profile_screen.dart';

class PeoplerAppBars {
  final BuildContext context;
  PeoplerAppBars({required this.context});

  // ignore: non_constant_identifier_names
  _BACK_BUTTON(void Function()?) {
    return InkWell(
      onTap: Function,
      child: Container(
        padding: const EdgeInsets.all(14),
        child: SvgPicture.asset(
          "assets/images/svg_icons/back_arrow.svg",
          width: 25,
          height: 25,
          color: Mode().homeScreenTitleColor(),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  _TITLE({required String title}) {
    return Text(
      title,
      textScaleFactor: 1,
      style: GoogleFonts.rubik(color: Mode().homeScreenTitleColor(), fontWeight: FontWeight.w600, fontSize: 20),
    );
  }

  // ignore: non_constant_identifier_names
  PROFILE_EDIT() {
    return AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: _BACK_BUTTON(() {
          Navigator.of(context).pop();
          Future.delayed(
            Duration(milliseconds: 2000),
            (() {
              setStateValue.value = !setStateValue.value;
            }),
          );
        }),
        centerTitle: true,
        title: _TITLE(
          title: "Profili Düzenle",
        ));
  }
}
