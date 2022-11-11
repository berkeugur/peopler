import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/CustomWidgets/AUTH_BUTTONS/apple.dart';
import 'package:peopler/components/CustomWidgets/AUTH_BUTTONS/edu.dart';
import 'package:peopler/components/CustomWidgets/AUTH_BUTTONS/guest.dart';
import 'package:peopler/components/CustomWidgets/AUTH_BUTTONS/linkedin.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/app_platform.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/WelcomeScreen/welcome.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/WelcomeScreen/welcome_functions.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../core/system_ui_service.dart';
import '../../../../data/model/user.dart';
import '../../../../data/repository/location_repository.dart';
import '../../../../others/locator.dart';

Center buildTitle() {
  return Center(
    child: Text(
      wpPeoplerTitle,
      style: GoogleFonts.spartan(
        color: const Color(0xFFFFFFFF),
        fontWeight: FontWeight.w700,
        fontSize: 54,
      ),
    ),
  );
}

Column buildButtons(BuildContext context) {
  return Column(
    children: [
      LinkedinButton.style1(
        onTap: () {
          continueWithLinkedinButtonOnPressed(context);
        },
      ),
      const SizedBox(
        height: 20,
      ),
      AppPlatform.isAndroid
          ? EducationButton.style1(
              onTap: () {
                continueWithUniversityEmailOnPressed(context);
              },
            )
          : AppleButton.style1(
              onTap: () {
                continueWithAppleOnPressed(context);
              },
            ),
      const SizedBox(
        height: 20,
      ),
      GuestButton.style1(
        onTap: () async {
          UserBloc.user = null;
          UserBloc.guestUser = MyUser();

          final LocationRepository _locationRepository = locator<LocationRepository>();
          LocationPermission _permission = await _locationRepository.checkPermissions();
          if (_permission == LocationPermission.always) {
            /// Set theme mode before Home Screen
            SystemUIService().setSystemUIforThemeMode();

            Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.BEG_FOR_PERMISSION_SCREEN, (Route<dynamic> route) => false);
          }
        },
      ),
      const SizedBox(
        height: 20,
      ),
      continueText(context)
    ],
  );
}

Center continueWithButton(BuildContext context,
    {Color? backgroundColor, required Widget? icon, required String text, required VoidCallback onPressed}) {
  return Center(
    child: InkWell(
      borderRadius: BorderRadius.circular(99),
      onTap: () => onPressed(),
      child: Container(
        width: 285,
        height: 43,
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(92),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 0,
              )
            ],
            color: backgroundColor ?? Colors.white),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon ?? const SizedBox(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: PeoplerTextStyle.normal.copyWith(color: backgroundColor != null ? Colors.white : Colors.black, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Center areYouAlreadyMemberText({required VoidCallback onPressed}) {
  return Center(
    child: TextButton(
      onPressed: () => onPressed(),
      child: const Text(
        wpAreYouAlreadyMember,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontFamily: "Rubik",
          fontStyle: FontStyle.normal,
          fontSize: 16.0,
        ),
      ),
    ),
  );
}

Center continueText(context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: "Devam Et'e dokunarak ",
            style: TextStyle(
              color: Colors.grey[200],
              fontWeight: FontWeight.w300,
              fontFamily: "Rubik",
              fontStyle: FontStyle.normal,
              fontSize: 15.0,
            ),
          ),
          TextSpan(
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w500,
              fontFamily: "Rubik",
              fontStyle: FontStyle.italic,
              fontSize: 16.0,
              decoration: TextDecoration.underline,
            ),
            text: "kullanım",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                show_privacy_policy(context);
              },
          ),
          TextSpan(
            text: " ",
            style: TextStyle(color: Colors.grey[200], fontWeight: FontWeight.w300, fontFamily: "Rubik", fontStyle: FontStyle.normal, fontSize: 15.0),
          ),
          TextSpan(
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w500,
              fontFamily: "Rubik",
              fontStyle: FontStyle.italic,
              fontSize: 16.0,
              decoration: TextDecoration.underline,
            ),
            text: "şartlarımızı",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                show_privacy_policy(context);
              },
          ),
          TextSpan(
            text: " kabul ediyorsun.",
            style: TextStyle(color: Colors.grey[200], fontWeight: FontWeight.w300, fontFamily: "Rubik", fontStyle: FontStyle.normal, fontSize: 15.0),
          ),
        ]),
      ),
    ),
  );
}
