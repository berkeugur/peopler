import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class EducationButton {
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
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 11,
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: SvgPicture.asset(
                      "assets/auth/edu.svg",
                      color: Colors.grey[850],
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
                    "Öğrenci Maili ile Devam Et",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: PeoplerTextStyle.normal.copyWith(color: Colors.grey[850], fontSize: 15),
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
