import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/others/functions/image_picker_functions.dart';

import '../../../../business_logic/blocs/UserBloc/bloc.dart';

Widget registerProfilePhoto({
  required BuildContext context,
  required StateSetter stateSetter,
}) {
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
            style: PeoplerTextStyle.normal.copyWith(
              color: const Color(0xFF000000),
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
          child: InkWell(
            onTap: () {
              showPicker(context, stateSetter: stateSetter);
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
                            border: Border.all(
                              width: 4,
                              color: const Color(0xFF0353EF),
                            ),
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(60),
                          ),
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
        Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(99),
            onTap: () {
              showPicker(context, stateSetter: stateSetter);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0353EF),
                borderRadius: BorderRadius.circular(99),
              ),
              child: image != null
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Profil Fotoğrafı Seç",
                      style: PeoplerTextStyle.normal.copyWith(color: Colors.white),
                    ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "İstediğin zaman profilini gizleyerek profil fotoğrafının görünürlüğünü değiştirebilirsin.",
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(
              color: const Color(0xFF000B21),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    ),
  );
}
