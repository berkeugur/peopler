import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

import '../../business_logic/blocs/UserBloc/user_bloc.dart';

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
                    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                    await _userBloc.restartApp();
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
