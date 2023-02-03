import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class LinkedinButton {
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
            color: Color.fromARGB(255, 0, 119, 181),
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
                      "assets/auth/linkedin.svg",
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
                    "Linkedin ile Devam Et",
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

  static style2({void Function()? onTap}) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
            vertical: 12.5,
            horizontal: 20,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                offset: Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 0,
              )
            ],
            color: Color.fromARGB(255, 0, 119, 181),
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
                      "assets/auth/linkedin.svg",
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
                    "Linkedin ile Devam Et",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: PeoplerTextStyle.normal.copyWith(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static style3({void Function()? onTap}) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(92),
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      "assets/auth/linkedin.svg",
                      color: Color(0xFF0353EF),
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Linkedin ile Devam Et",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: PeoplerTextStyle.normal.copyWith(
                      color: Color(0xFF0353EF),
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 10,
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
