// ignore_for_file: file_names

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/app/app_constants.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/classes/variables.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/ProfileScreen/profile_screen.dart';

import '../../business_logic/blocs/NotificationBloc/notification_bloc.dart';
import '../../business_logic/cubits/NewNotificationCubit.dart';
import '../../presentation/screens/FEEDS/FeedScreen/feed_functions.dart';

class PEOPLER_TITLE extends StatelessWidget {
  const PEOPLER_TITLE({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0, right: 10, top: 13),
      child: Text(
        ApplicationConstants.COMPANY_NAME.toLowerCase(),
        style: GoogleFonts.spartan(color: Mode().homeScreenTitleColor(), fontWeight: FontWeight.w800, fontSize: 32),
      ),
    );
  }
}

class NOTIFICATION_TITLE extends StatelessWidget {
  const NOTIFICATION_TITLE({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13.0, right: 10, top: 13),
      child: Text(
        "Bildirimler",
        style: GoogleFonts.spartan(color: Mode().homeScreenTitleColor(), fontWeight: FontWeight.w800, fontSize: 32),
      ),
    );
  }
}

class DRAWER_MENU_ICON extends StatelessWidget {
  const DRAWER_MENU_ICON({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(99),
      onTap: () => op_settings_icon(context),
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
}

class PeoplerAppBars {
  final BuildContext context;
  PeoplerAppBars({required this.context});

  // ignore: non_constant_identifier_names
  Widget _BACK_BUTTON({void Function()? function, Color? color}) {
    return InkWell(
      borderRadius: BorderRadius.circular(99),
      onTap: function ??
          () {
            FocusScope.of(context).unfocus();
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
  Widget _TITLE({required String title, Color? color}) {
    return Text(
      title,
      textScaleFactor: 1,
      style: PeoplerTextStyle.normal.copyWith(color: color ?? Mode().homeScreenTitleColor(), fontWeight: FontWeight.w500, fontSize: 24),
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
                        Text(
                          "kaydet",
                          style: PeoplerTextStyle.normal.copyWith(
                            color: Mode().homeScreenTitleColor(),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
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
      title: PEOPLER_TITLE(),
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

  // ignore: non_constant_identifier_names
  AppBar get BLOCKED_USERS {
    return AppBar(
      leading: _BACK_BUTTON(),
      title: _TITLE(title: "Engellenen Kullanıcılar"),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }

  // ignore: non_constant_identifier_names
  AppBar get COMMENTS {
    return AppBar(
      leading: _BACK_BUTTON(),
      title: _TITLE(title: "Yorumlar"),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }

  /// remaining usage rights app bar
  // ignore: non_constant_identifier_names
  AppBar get RUR {
    return AppBar(
      leading: _BACK_BUTTON(),
      title: _TITLE(title: "Kalan Kullanım Hakları"),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }

  // ignore: non_constant_identifier_names
  AppBar get REGISTER {
    return AppBar(
      leading: _BACK_BUTTON(color: Colors.white),
      title: _TITLE(title: "KAYIT OL", color: Colors.white),
      //backgroundColor: Colors.transparent,
      backgroundColor: Theme.of(context).primaryColor,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              PeoplerDialogs().showContanctInfo(context);
            },
            icon: const Icon(
              Icons.help,
              color: Colors.white,
            ))
      ],
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
      title: PEOPLER_TITLE(),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }
}
