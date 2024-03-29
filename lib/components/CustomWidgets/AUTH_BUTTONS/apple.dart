import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class AppleButton {
  static style1({void Function()? onTap}) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: onTap,
        child: Container(
          width: 285,
          height: 43,
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(92),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 0,
              )
            ],
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      "assets/auth/apple.svg",
                      color: Colors.white,
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
                    "Apple ile Devam Et",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: PeoplerTextStyle.normal.copyWith(color: Colors.white, fontSize: 15),
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
