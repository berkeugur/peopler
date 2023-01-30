import 'package:flutter/material.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';

Widget registerDisplayName({
  required BuildContext context,
  required PageController pageController,
  required TextEditingController textEditingController,
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
            "İsmin Nedir ?",
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(
              color: const Color(0xFF000000),
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF0353EF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            onFieldSubmitted: (_) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear,
              );
              FocusScope.of(context).unfocus();
            },
            autofocus: true,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            cursorColor: const Color(0xFFFFFFFF),
            maxLength: MaxLengthConstants.DISPLAYNAME,
            controller: textEditingController,
            autocorrect: true,
            decoration: const InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              hintMaxLines: 1,
              border: InputBorder.none,
              hintText: 'Örneğin, Mehmet Yılmaz',
              hintStyle: TextStyle(color: Color(0xFF9ABAF9), fontSize: 16),
            ),
            autofillHints: const [AutofillHints.name],
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Profilini gizleyerek diğer insanların ismini görmesini engelleyebilirsin.",
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
