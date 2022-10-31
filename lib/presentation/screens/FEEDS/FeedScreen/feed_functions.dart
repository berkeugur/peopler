import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/data/model/report.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/others/functions/guest_login_alert_dialog.dart';
import 'package:peopler/presentation/screen_services/report_service.dart';
import 'package:peopler/presentation/screens/SETTINGS/settings.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../../data/services/db/firebase_db_report.dart';
import '../../../../others/locator.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

// ignore: non_constant_identifier_names
op_settings_icon(context) {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  if (UserBloc.user != null) {
    ZoomDrawer.of(context)!.toggle();

    /*
    _userBloc.mainKey.currentState?.push(
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
    */
  } else {
    GuestAlert.dialog(context);
    /*
    _userBloc.mainKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const GuestLoginScreen(),
      ),
    );*/
  }
}

op_peopler_title(context, ScrollController scrollController) {
  scrollController.animateTo(10, duration: const Duration(seconds: 2), curve: Curves.easeInOutSine);
  return;
}

op_message_icon(context) {
  FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
  _homeScreen.navigatorKeys[TabItem.chat]!.currentState!.pushNamed(NavigationConstants.CHAT_SCREEN);
}

tripleDotOnPressed(BuildContext context, String feedId, String feedExplanation, String userID, String userDisplayName, String userGender, DateTime createdAt,
    String userPhotoUrl, AnimationController animationController) {
  showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0353EF),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.report_gmailerrorred,
                color: Colors.white,
              ),
              title: Text(
                'Paylaşımı Şikayet Et',
                textScaleFactor: 1,
                style: PeoplerTextStyle.normal.copyWith(fontSize: 14, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _showReportBottomSheet(context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: Text(
                'Kullanıcıyı Şikayet Et',
                textScaleFactor: 1,
                style: PeoplerTextStyle.normal.copyWith(fontSize: 14, color: Colors.white),
              ),
              onTap: () {
                MyReport report = MyReport(userID: userID, type: "Report User", feedID: feedId, feedExplanation: feedExplanation);
                BlockAndReportService().reportUser(report: report).then((value) {
                  Navigator.of(context).pop();
                  PeoplerDialogs().showSuccessfulDialog(context, animationController);
                }).onError((error, stackTrace) => SnackBars(context: context).simple("$error"));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.block,
                color: Colors.white,
              ),
              title: Text(
                'Kullanıcıyı Engelle',
                textScaleFactor: 1,
                style: PeoplerTextStyle.normal.copyWith(fontSize: 14, color: Colors.white),
              ),
              onTap: () {
                BlockAndReportService().blockUser(blockUserID: userID, feedID: feedId).then((value) {
                  Navigator.of(context).pop();
                  PeoplerDialogs().showSuccessfulDialog(context, animationController);
                }).onError((error, stackTrace) => SnackBars(context: context).simple("$error"));
              },
            ),
          ],
        );
      });
}

Future<void> _showReportBottomSheet(
  context,
  String feedId,
  String feedExplanation,
  String userID,
  String userDisplayName,
  String userGender,
  DateTime createdAt,
  String userPhotoUrl,
) async {
  await showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF0353EF),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      999,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Şikayet Et",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Bu gönderiyi neden şikayet ediyorsunuz?",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Merak etmeyin kimliğiniz gizli tutacak.",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      color: Color.fromARGB(255, 214, 214, 214),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                _reportItem("Spam", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Çıplaklık veya cinsellik", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Sadece bundan hoşlanmadım", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Sahtekarlık ve dolandırıcılık", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Nefret söylemi veya sembolleri", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Yanlış bilgiler", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Zorbalık veya taciz", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Şiddet veya tehlikeli örgütler", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Fikri mülkiyet ihlali", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Yasal düzenlemeye tabi veya yasadışı ürünlerin satışı", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("İntihar veya kendine zarar verme", context, feedId, feedExplanation, userID, createdAt),
                _reportItem("Yeme bozuklukları", context, feedId, feedExplanation, userID, createdAt),
              ],
            )
          ],
        );
      });
}

InkWell _reportItem(
  String text,
  BuildContext context,
  String feedId,
  String feedExplanation,
  String userID,
  DateTime createdAt,
) {
  return InkWell(
    onTap: () {
      if (UserBloc.user != null) {
        MyReport report = MyReport(userID: userID, type: text, feedID: feedId, feedExplanation: feedExplanation);

        BlockAndReportService().reportFeed(report: report);

        Navigator.pop(context);

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Talebiniz Alındı',
                  textScaleFactor: 1,
                ),
                content: const Text(
                  'En kısa sürede şikayetiniz incelenecektir! Bizi bilgilendirdiğiniz için teşekkür ederiz.',
                  textScaleFactor: 1,
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Kapat',
                        textScaleFactor: 1,
                      )),
                ],
              );
            });
      } else {
        GuestAlert.dialog(context);
        /*
    _userBloc.mainKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const GuestLoginScreen(),
      ),
    );*/
      }
    },
    child: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 14,
          ),
        ],
      ),
    ),
  );
}

String feedContentText() {
  return """Norveçli sanatçı AURORA merakla beklenen yeni albümü “The Gods We Can Touch”ı yayımladı. Üçüncü stüdyo albümü olan “The Gods We Can Touch” """;
}

feedOnDoubleTap() {
  print("double tap on feed");
}
