import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/data/repository/location_repository.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/locator.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/WelcomeScreen/welcome_component.dart';

class GuestLoginScreen extends StatefulWidget {
  const GuestLoginScreen({Key? key}) : super(key: key);

  @override
  State<GuestLoginScreen> createState() => _GuestLoginScreenState();
}

class _GuestLoginScreenState extends State<GuestLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Giriş Yapmanız Gerekiyor",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          continueWithButton(
            context,
            backgroundColor: Color(0xFF0353EF),
            icon: SvgPicture.asset(
              "assets/images/svg_icons/linkedin.svg",
              width: 0,
              height: 0,
              fit: BoxFit.contain,
            ),
            text: "Giriş Yap",
            onPressed: () {
              //98865896
              //Welcome Page e Yönlendir.
            },
          ),
        ],
      ),
    );
  }
}
