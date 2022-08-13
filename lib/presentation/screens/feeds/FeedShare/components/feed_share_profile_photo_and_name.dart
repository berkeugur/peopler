import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/classes/responsive_size.dart';
import '../../../../../others/locator.dart';
import '../feed_share_functions.dart';

Padding profilePhotoAndName(context) {
  final Mode _mode = locator<Mode>();
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        InkWell(
          onTap: () => feed_share_profile_photo_on_pressed(),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Color(0xFF939393).withOpacity(0.15),
                        blurRadius: 15.0,
                        spreadRadius: 2,
                        offset: Offset(0.0, 0.75))
                  ],
                ),
                height: 60,
                width: 60,
                child: const CircleAvatar(
                  backgroundColor: Color(0xFF0353EF),
                  child: Text("ppl"),
                ),
              ),
              SizedBox(
                height: 60,
                width: 60,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(UserBloc.user!.profileURL),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
         LimitedBox(
                maxWidth: MediaQuery.of(context).size.width - 120,
                child: Text(
                  UserBloc.user!.displayName,
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                    color: _mode.blackAndWhiteConversion(),
                    fontSize: ResponsiveSize().fs4(context),
                  ),
                ),
        ),
      ],
    ),
  );
}
