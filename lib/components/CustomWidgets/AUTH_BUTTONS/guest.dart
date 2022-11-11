import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

import '../../../presentation/screens/LOGIN_REGISTER/WelcomeScreen/welcome.dart';

class GuestButton {
  static style1({void Function()? onTap}) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: onTap,
        child: Container(
          width: 285,
          height: 43,
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
            borderRadius: const BorderRadius.all(
              Radius.circular(92),
            ),
            color: const Color.fromARGB(0, 255, 255, 255),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: SvgPicture.asset(
                      "assets/auth/guest.svg",
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    wpContinueWithGuest,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: PeoplerTextStyle.normal.copyWith(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
