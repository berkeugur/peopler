import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';

registerPassword({
  required BuildContext context,
  required PageController pageController,
  required TextEditingController textEditingController,
}) {
  ValueNotifier<bool> _isVisiblePassword = ValueNotifier(true);

  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Şifre Belirleyin",
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
        ValueListenableBuilder(
            valueListenable: _isVisiblePassword,
            builder: (context, _, __) {
              return Container(
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
                  obscureText: _isVisiblePassword.value,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: const Color(0xFFFFFFFF),
                  maxLength: MaxLengthConstants.PASSWORD,
                  controller: textEditingController,
                  autocorrect: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _isVisiblePassword.value = !_isVisiblePassword.value;
                      },
                      icon: Icon(
                        _isVisiblePassword.value == true ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF9ABAF9),
                      ),
                      iconSize: 20,
                    ),
                    counterText: "",
                    contentPadding: const EdgeInsets.fromLTRB(0, 13, 0, 10),
                    hintMaxLines: 1,
                    border: InputBorder.none,
                    hintText: 'Şifre',
                    hintStyle: const TextStyle(color: Color(0xFF9ABAF9), fontSize: 16),
                  ),
                  autofillHints: const [AutofillHints.password],
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Şifrenizi istediğiniz zaman e-posta adresinizi kullanarak sıfırlayabilirsiniz.",
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
