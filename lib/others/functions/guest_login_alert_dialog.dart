import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class GuestAlert {
  static dialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Giriş Yapmalısınız.",
              style: PeoplerTextStyle.normal.copyWith(
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
                    style: PeoplerTextStyle.normal.copyWith(
                      color: const Color(0xFF0353EF),
                    ),
                  )),
              TextButton(
                  onPressed: () async {
                    await Phoenix.rebirth(context);
                    // UserBloc _userBloc = BlocProvider.of(context);
                    // _userBloc.mainKey.currentState?.pushNamedAndRemoveUntil(NavigationConstants.WELCOME, (Route<dynamic> route) => false);
                  },
                  child: Text(
                    "Giriş Yap",
                    style: PeoplerTextStyle.normal.copyWith(
                      color: const Color(0xFF0353EF),
                    ),
                  )),
            ],
          );
        });
  }
}
