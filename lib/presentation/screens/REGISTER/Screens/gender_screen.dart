import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';

String getGenderText(GenderTypes type) {
  switch (type) {
    case GenderTypes.woman:
      return "KADIN";
    case GenderTypes.man:
      return "ERKEK";
    case GenderTypes.other:
      return "DİĞER";
  }
}

Widget registerGenderSelect({
  required BuildContext context,
  required ValueNotifier<GenderTypes?> selectedType,
}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text(
                "Cinsiyetin Nedir?",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                  color: const Color(0xFF000000),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const Icon(Icons.male),
              const Icon(Icons.female),
            ],
          ),
        ),
        ValueListenableBuilder(
            valueListenable: selectedType,
            builder: (context, _, __) {
              return InkWell(
                onTap: () {
                  selectedType.value = GenderTypes.woman;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: selectedType.value == GenderTypes.woman ? 10 : 15,
                    vertical: 7.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: selectedType.value == GenderTypes.woman ? 2.5 : 1.5,
                      color: selectedType.value == GenderTypes.woman ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      getGenderText(GenderTypes.woman),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        fontWeight: selectedType.value == GenderTypes.woman ? FontWeight.w500 : FontWeight.w400,
                        color: selectedType.value == GenderTypes.woman ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              );
            }),
        ValueListenableBuilder(
            valueListenable: selectedType,
            builder: (context, _, __) {
              return InkWell(
                onTap: () {
                  selectedType.value = GenderTypes.man;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: selectedType.value == GenderTypes.man ? 10 : 15,
                    vertical: 7.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: selectedType.value == GenderTypes.man ? 2.5 : 1.5,
                      color: selectedType.value == GenderTypes.man ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      getGenderText(GenderTypes.man),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        fontWeight: selectedType.value == GenderTypes.man ? FontWeight.w500 : FontWeight.w400,
                        color: selectedType.value == GenderTypes.man ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              );
            }),
        ValueListenableBuilder(
            valueListenable: selectedType,
            builder: (context, _, __) {
              return InkWell(
                onTap: () {
                  selectedType.value = GenderTypes.other;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: selectedType.value == GenderTypes.other ? 10 : 15,
                    vertical: 7.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: selectedType.value == GenderTypes.other ? 2.5 : 1.5,
                      color: selectedType.value == GenderTypes.other ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      getGenderText(GenderTypes.other),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        fontWeight: selectedType.value == GenderTypes.other ? FontWeight.w500 : FontWeight.w400,
                        color: selectedType.value == GenderTypes.other ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ],
    ),
  );
}
