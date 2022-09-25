import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/data/services/auth/firebase_auth_service.dart';
import 'package:peopler/presentation/screens/BLOCKED/blocked_users.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../settings.dart';
import '../settings_page_functions.dart';

changePasswordField(context) {
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
          "Güvenlik",
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
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
            showDialog(
              context: context,
              builder: (contextSD) => AlertDialog(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                contentPadding: const EdgeInsets.only(top: 20.0, bottom: 5, left: 25, right: 25),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      """Şifrenizi sıfırlamak için aşağıdaki butona tıkayın ve ${UserBloc.user?.email ?? "email"} adresinize gelen bağlantıya tıklayın.""",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
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
                      onTap: () async {
                        if (UserBloc.user != null) {
                          await FirebaseAuthService().resetPassword(UserBloc.user!.email).then((value) {
                            Navigator.of(context).pop();
                          }).onError((error, stackTrace) {
                            Navigator.of(context).pop();
                            SnackBars(context: context).simple("Sıfırlama Bağlantısı Gönderildi.");
                          });
                        } else {
                          Navigator.of(context).pop();
                          SnackBars(context: context).simple("Bilinmeyen bir hata oluştu: #1142588");
                        }
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
                          "Sıfırlama Bağlantısı Gönder",
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "KAPAT",
                        style: GoogleFonts.rubik(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/svg_icons/password_lock.svg",
                  width: 20,
                  height: 20,
                  color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_1(),
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Şifre Değiştir",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: is_selected_profile_close_to_everyone ? Colors.white : _mode.settings_custom_2(),
                  ),
                ),
              ],
            ),
          ),
        ),

        //Container(width: 10,height: 1,color: _mode.settings_custom_2(),margin: EdgeInsets.only(left: 30),)
      ],
    ),
  );
}
