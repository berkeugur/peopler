import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/others/strings.dart';

import '../../../../components/FlutterWidgets/text_style.dart';

Widget registerCitySelect({
  required ValueNotifier<String?> selecetCity,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 55,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 0,
          ),
          child: Text(
            "Hangi Sehirde Yaşıyorsunuz?",
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(
              color: const Color(0xFF000000),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey[300],
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              Strings.cityData.length,
              (int index) => ValueListenableBuilder(
                valueListenable: selecetCity,
                builder: (context, _, __) {
                  return RadioListTile<String>(
                    title: Text(
                      Strings.cityData[index],
                      style: PeoplerTextStyle.normal.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    groupValue: selecetCity.value,
                    value: Strings.cityData[index],
                    onChanged: (value) {
                      selecetCity.value = value;
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
