import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';

import '../../../../others/classes/responsive_size.dart';

Container genderItem(BuildContext context, {required String genderText, required StateSetter stateSetter}) {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    height: 40,
    decoration: BoxDecoration(
      color: UserBloc.user?.gender == genderText ? const Color(0xFF0353EF) : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextButton(
      onPressed: () {
        stateSetter(() {
          UserBloc.user?.gender = genderText;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          genderText,
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
              color: UserBloc.user?.gender == genderText ? const Color(0xFFFFFFFF) : const Color(0xFF0353EF),
              fontSize: ResponsiveSize().gs1(context),
              fontWeight: UserBloc.user?.gender == genderText ? FontWeight.w400 : FontWeight.w200),
        ),
      ),
    ),
  );
}
