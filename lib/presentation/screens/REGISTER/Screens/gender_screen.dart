import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';

String getGenderText(GenderTypes? type) {
  switch (type) {
    case GenderTypes.female:
      return "Kadın";
    case GenderTypes.male:
      return "Erkek";
    case GenderTypes.other:
      return "Diğer";
    case GenderTypes.nospecify:
      return "Belirtmek İstemiyorum";
    default:
      return "Belirtmek İstemiyorum";
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
                style: PeoplerTextStyle.normal.copyWith(
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
                  selectedType.value = GenderTypes.female;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: selectedType.value == GenderTypes.female ? 10 : 15,
                    vertical: 7.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: selectedType.value == GenderTypes.female ? 2.5 : 1.5,
                      color: selectedType.value == GenderTypes.female ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      getGenderText(GenderTypes.female),
                      textAlign: TextAlign.center,
                      style: PeoplerTextStyle.normal.copyWith(
                        fontWeight: selectedType.value == GenderTypes.female ? FontWeight.w500 : FontWeight.w400,
                        color: selectedType.value == GenderTypes.female ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
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
                  selectedType.value = GenderTypes.male;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: selectedType.value == GenderTypes.male ? 10 : 15,
                    vertical: 7.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: selectedType.value == GenderTypes.male ? 2.5 : 1.5,
                      color: selectedType.value == GenderTypes.male ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      getGenderText(GenderTypes.male),
                      textAlign: TextAlign.center,
                      style: PeoplerTextStyle.normal.copyWith(
                        fontWeight: selectedType.value == GenderTypes.male ? FontWeight.w500 : FontWeight.w400,
                        color: selectedType.value == GenderTypes.male ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
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
                      style: PeoplerTextStyle.normal.copyWith(
                        fontWeight: selectedType.value == GenderTypes.other ? FontWeight.w500 : FontWeight.w400,
                        color: selectedType.value == GenderTypes.other ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
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
                  selectedType.value = GenderTypes.nospecify;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: selectedType.value == GenderTypes.nospecify ? 10 : 15,
                    vertical: 7.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: selectedType.value == GenderTypes.nospecify ? 2.5 : 1.5,
                      color: selectedType.value == GenderTypes.nospecify ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      getGenderText(GenderTypes.nospecify),
                      textAlign: TextAlign.center,
                      style: PeoplerTextStyle.normal.copyWith(
                        fontWeight: selectedType.value == GenderTypes.nospecify ? FontWeight.w500 : FontWeight.w400,
                        color:
                            selectedType.value == GenderTypes.nospecify ? Theme.of(context).primaryColor : const Color(0xFF000000).withOpacity(0.7),
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
