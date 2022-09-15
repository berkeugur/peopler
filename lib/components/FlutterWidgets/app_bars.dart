// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/core/constants/app/app_constants.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/classes/variables.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/ProfileScreen/profile_screen.dart';

class PeoplerAppBars {
  final BuildContext context;
  PeoplerAppBars({required this.context});

  // ignore: non_constant_identifier_names
  Widget _BACK_BUTTON({void Function()? function, Color? color}) {
    return InkWell(
      borderRadius: BorderRadius.circular(99),
      onTap: function ??
          () {
            Navigator.of(context).pop();
          },
      child: Container(
        padding: const EdgeInsets.all(14),
        child: SvgPicture.asset(
          "assets/images/svg_icons/back_arrow.svg",
          width: 24,
          height: 24,
          color: color ?? Mode().homeScreenTitleColor(),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  _DRAWER_MENU_ICON(void Function()? function) {
    return InkWell(
      borderRadius: BorderRadius.circular(99),
      onTap: function,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 20,
          ),
          SvgPicture.asset(
            "assets/images/svg_icons/sort.svg",
            height: 35,
            width: 35,
            color: Mode().homeScreenTitleColor(),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _TITLE({required String title}) {
    return Text(
      title,
      textScaleFactor: 1,
      style: GoogleFonts.rubik(color: Mode().homeScreenTitleColor(), fontWeight: FontWeight.w500, fontSize: 24),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _PEOPLER_TITLE(void Function()? titleFunction) {
    return Text(
      ApplicationConstants.COMPANY_NAME.toLowerCase(),
      textScaleFactor: 1,
      style: GoogleFonts.spartan(color: Mode().homeScreenTitleColor(), fontWeight: FontWeight.w900, fontSize: 32),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar get PROFILE_EDIT {
    return AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: _BACK_BUTTON(
          function: () {
            Navigator.of(context).pop();
            Future.delayed(
              const Duration(milliseconds: 2000),
              (() {
                setStateProfileScreen.value = !setStateProfileScreen.value;
              }),
            );
          },
        ),
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
          function == null
              ? const SizedBox.shrink()
              : Padding(
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
        leading: _BACK_BUTTON(function: () {
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

  // ignore: non_constant_identifier_names
  OTHER_PROFILE({Function()? function}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      actions: [
        IconButton(
            onPressed: function,
            icon: Icon(
              Icons.more_vert,
              color: Mode().homeScreenTitleColor(),
            ))
      ],
      leading: _BACK_BUTTON(function: () {
        Navigator.of(context).pop();
        Future.delayed(
          const Duration(milliseconds: 2000),
          (() {
            setStateProfileScreen.value = !setStateProfileScreen.value;
          }),
        );
      }),
      centerTitle: true,
      title: _PEOPLER_TITLE(() {}),
    );
  }

  // ignore: non_constant_identifier_names
  CHANNEL_LIST() {
    return AppBar(
      centerTitle: true,
      title: _PEOPLER_TITLE(() {}),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }

  // ignore: non_constant_identifier_names
  FEED({void Function()? titleFunction, void Function()? leadingFunction}) {
    return AppBar(
      leading: _DRAWER_MENU_ICON(leadingFunction),
      centerTitle: true,
      title: _PEOPLER_TITLE(() {}),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }

  // ignore: non_constant_identifier_names
  MYPROFILE({void Function()? titleFunction, void Function()? leadingFunction}) {
    return AppBar(
      //leading: _DRAWER_MENU_ICON(leadingFunction),
      centerTitle: true,
      title: _PEOPLER_TITLE(() {}),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }

  // ignore: non_constant_identifier_names
  NOTIFICATION() {
    return AppBar(
      toolbarHeight: Variables.animatedNotificationsHeaderTop.value,
      title: _TITLE(title: "Bildirimler"),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }

  // ignore: non_constant_identifier_names
  CONNECTION_REQ(void Function()? function) {
    return AppBar(
      leading: _BACK_BUTTON(function: function),
      title: _TITLE(title: "Davetiyeler"),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }

  GALLERY() {
    return AppBar(
      leading: _BACK_BUTTON(
        function: () => Navigator.of(context).pop(),
        color: Colors.white,
      ),
      shadowColor: Colors.black,
      backgroundColor: Colors.black,
      actions: true
          ? null
          // ignore: dead_code
          : [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              )
            ],
    );
  }

  // ignore: non_constant_identifier_names
  AppBar get CONNECTIONS {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      leading: _BACK_BUTTON(
        function: () => Navigator.of(context).pop(),
      ),
      title: _TITLE(title: 'Bağlantılar'),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar get ACTIVITYIES {
    return AppBar(
      centerTitle: true,
      leading: _BACK_BUTTON(),
      title: _PEOPLER_TITLE(() {}),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }
}
