import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:restart_app/restart_app.dart';

class GuestAlert {
  static dialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Giriş Yapmalısınız.",
              style: GoogleFonts.rubik(
                color: const Color(0xFF0353EF),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Kapat",
                    style: GoogleFonts.rubik(
                      color: const Color(0xFF0353EF),
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Restart.restartApp();
                    // UserBloc _userBloc = BlocProvider.of(context);
                    // _userBloc.mainKey.currentState?.pushNamedAndRemoveUntil(NavigationConstants.WELCOME, (Route<dynamic> route) => false);
                  },
                  child: Text(
                    "Giriş Yap",
                    style: GoogleFonts.rubik(
                      color: const Color(0xFF0353EF),
                    ),
                  )),
            ],
          );
        });
  }
}
