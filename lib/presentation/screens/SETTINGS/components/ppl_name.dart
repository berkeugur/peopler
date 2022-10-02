import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';

// ignore: non_constant_identifier_names
ppl_user_name(context) {
  final Mode _mode = locator<Mode>();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: Text(
        UserBloc.user!.displayName,
        textScaleFactor: 1,
        style: GoogleFonts.rubik(
          fontSize: 22,
          fontWeight: FontWeight.normal,
          color: _mode.settings_ppl_user_name_text(),
        ),
      ),
    ),
  );
}
