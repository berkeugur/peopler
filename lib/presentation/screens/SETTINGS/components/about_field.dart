import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/WelcomeScreen/welcome_functions.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../settings_page_functions.dart';

// ignore: non_constant_identifier_names
about_field(context) {
  final Mode _mode = locator<Mode>();
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Hakkında",
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 23,
            color: _mode.settings_setting_title(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            TextEditingController _controller = TextEditingController();
            showDialog(
              context: context,
              builder: (_ctx) {
                return AlertDialog(
                  title: const Text("Destek"),
                  content: Container(
                    alignment: Alignment.center,
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0353EF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      maxLength: MaxLengthConstants.SUGGEST,
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.fromLTRB(0, 13, 0, 10),
                        hintMaxLines: 1,
                        border: InputBorder.none,
                        hintText: 'Mesajınız',
                        hintStyle: TextStyle(color: Color(0xFF9ABAF9), fontSize: 16),
                      ),
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("iptal"),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          await FirebaseFirestore.instance.collection("supports").doc().set({
                            "message": _controller.text,
                            "fromUserID": UserBloc.user?.userID,
                            "fromUserEmail": UserBloc.user?.email,
                            "createdAt": Timestamp.now(),
                          }).then((value) {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (contextSD) => AlertDialog(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                contentPadding: EdgeInsets.only(top: 20.0, bottom: 5, left: 25, right: 25),
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "En kısa sürede e-posta yoluyla iletişime geçeceğiz",
                                      textAlign: TextAlign.center,
                                      style: PeoplerTextStyle.normal.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(999),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          "TAMAM",
                                          style: PeoplerTextStyle.normal.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        } else {
                          SnackBars(context: context).simple("boş bırakmayınız");
                        }
                      },
                      child: const Text("Gönder"),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: _mode.settings_custom_1(),
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  MediaQuery.of(context).size.width > 300 ? "Görüş, öneri veya şikayet bildir" : "Görüş, öneri veya \nşikayet bildir",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                    fontSize: 16,
                    color: _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Container(width: 15,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),),

        const SizedBox(
          height: 10,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => termOfUseTextOnPressed(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/svg_icons/book_1.svg",
                  width: 20,
                  height: 20,
                  color: _mode.settings_custom_1(),
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Kullanım Şartları",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                    fontSize: 16,
                    color: _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Container(width: 15,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),),

        const SizedBox(
          height: 10,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => show_privacy_policy(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/svg_icons/book_2.svg",
                  width: 20,
                  height: 20,
                  color: _mode.settings_custom_1(),
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Gizlilik Sözleşmesi",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                    fontSize: 16,
                    color: _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Container(width: 15,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),),

        const SizedBox(
          height: 10,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => op_sign_out(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.west_outlined,
                  color: _mode.settings_custom_1(),
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Çıkış Yap",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                    fontSize: 16,
                    color: _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Container(width: 15,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),),
      ],
    ),
  );
}
