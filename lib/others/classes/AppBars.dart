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
      borderRadius: BorderRadius.circular(99),
      onTap: Function,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SvgPicture.asset(
          "assets/images/svg_icons/back_arrow.svg",
          width: 20,
          height: 20,
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
      style: GoogleFonts.rubik(color: Mode().homeScreenTitleColor(), fontWeight: FontWeight.w400, fontSize: 20),
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
            const Duration(milliseconds: 2000),
            (() {
              setStateProfileScreen.value = !setStateProfileScreen.value;
            }),
          );
        }),
        centerTitle: true,
        title: _TITLE(
          title: "Profili Düzenle",
        ));
  }

  // ignore: non_constant_identifier_names
  PROFILE_EDIT_ITEMS({String? title, Function()? function}) {
    return AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: function,
              child: Row(
                children: [
                  const Icon(Icons.save),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "kaydet",
                    style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          )
        ],
        leading: _BACK_BUTTON(() {
          Navigator.of(context).pop();
          Future.delayed(
            const Duration(milliseconds: 2000),
            (() {
              setStateProfileScreen.value = !setStateProfileScreen.value;
            }),
          );
        }),
        title: _TITLE(
          title: title ?? "",
        ));
  }
}
