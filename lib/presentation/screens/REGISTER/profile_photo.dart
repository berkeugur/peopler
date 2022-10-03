import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/others/functions/image_picker_functions.dart';

import '../../../business_logic/blocs/UserBloc/bloc.dart';

class RegisterProfilePhoto extends StatefulWidget {
  const RegisterProfilePhoto({Key? key}) : super(key: key);

  @override
  State<RegisterProfilePhoto> createState() => _RegisterProfilePhotoState();
}

class _RegisterProfilePhotoState extends State<RegisterProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Profil Fotoğrafını Belirle",
              textScaleFactor: 1,
              style: GoogleFonts.rubik(
                color: const Color(0xFF000000),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: InkWell(
              onTap: () {
                showPicker(context, stateSetter: setState);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xFF8E9BB4),
                child: (UserBloc.user?.profileURL != null) && (UserBloc.user?.profileURL != '')
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          UserBloc.user!.profileURL,
                          width: 120,
                          height: 120,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : (image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.file(
                              image!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 4, color: const Color(0xFF0353EF)), color: Colors.grey[200], borderRadius: BorderRadius.circular(60)),
                            width: 120,
                            height: 120,
                            child: const Icon(
                              Icons.photo_camera_outlined,
                              color: Color(0xFF0353EF),
                              size: 60,
                            ))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
