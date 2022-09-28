import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/reloader/reload.dart';
import 'package:peopler/data/model/report.dart';
import 'package:peopler/others/functions/guest_login_alert_dialog.dart';
import 'package:peopler/presentation/screen_services/other_profile_service.dart';
import 'package:peopler/presentation/screen_services/report_service.dart';
import 'package:peopler/presentation/screens/PROFILE/OthersProfile/functions.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';

import '../../../../../business_logic/blocs/OtherUserBloc/other_user_bloc.dart';

ReportOrBlockUser({required BuildContext context, OtherUserBloc? otherUserBloc, required AnimationController controller, String? userID}) async {
  Widget _reportUserItem(String text) {
    return InkWell(
      onTap: () async {
        if (UserBloc.user != null) {
          if (otherUserBloc != null) {
            await BlockAndReportService().reportUser(report: MyReport(userID: otherUserBloc.otherUser?.userID ?? "null", type: text)).then((value) {
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
            });
          } else if (otherUserBloc == null && userID != null) {
            await BlockAndReportService().reportUser(report: MyReport(userID: userID, type: text)).then((value) {
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
            });
          }
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
              style: GoogleFonts.rubik(
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

  showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0353EF),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
              visible: OtherProfileService().isMyConnection(otherProfileID: otherUserBloc?.otherUser?.userID),
              child: ListTile(
                leading: const Icon(
                  Icons.person_off_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  'Bağlantıyı Sil',
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(fontSize: 14, color: Colors.white),
                ),
                onTap: () async {
                  if (UserBloc.user != null) {
                    if (otherUserBloc != null && otherUserBloc.otherUser != null) {
                      //remove connection function
                      OtherProfileService().removeConnection(context: context, otherUserID: otherUserBloc.otherUser!.userID, otherUserBloc: otherUserBloc).then((value) {
                        Reloader().reload(reloadItem: Reloader.otherUserProfileReload);
                        Navigator.of(context).pop();
                      });
                    } else {
                      printf("otheruserbloc null remove connection list tile");
                    }
                  } else {
                    GuestAlert.dialog(context);
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.report_gmailerrorred,
                color: Colors.white,
              ),
              title: Text(
                'Kullanıcıyı Engelle',
                textScaleFactor: 1,
                style: GoogleFonts.rubik(fontSize: 14, color: Colors.white),
              ),
              onTap: () async {
                if (UserBloc.user == null) {
                  GuestAlert.dialog(context);
                  return;
                }

                if (otherUserBloc != null) {
                  if (otherUserBloc.otherUser == null) {
                    SnackBars(context: context).simple("other user bloc other user null");
                    return;
                  }

                  await BlockAndReportService().blockUser(blockUserID: otherUserBloc.otherUser!.userID).then((value) {
                    Navigator.of(context).pop();
                    PeoplerDialogs().showSuccessfulDialog(context, controller);
                  }).onError((error, stackTrace) => SnackBars(context: context).simple("$error"));
                } else if (otherUserBloc == null && userID != null) {
                  await BlockAndReportService().blockUser(blockUserID: userID).then((value) {
                    Navigator.of(context).pop();
                    PeoplerDialogs().showSuccessfulDialog(context, controller);
                  }).onError((error, stackTrace) => SnackBars(context: context).simple("$error"));
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.report_gmailerrorred,
                color: Colors.white,
              ),
              title: Text(
                'Kullanıcıyı Şikayet Et',
                textScaleFactor: 1,
                style: GoogleFonts.rubik(fontSize: 14, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
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
                                  "Kullanıcıyı Şikayet Et",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
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
                                  "${otherUserBloc?.otherUser?.displayName ?? "peopler"} kullanıcısını neden şikayet ediyorsunuz?",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
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
                                  style: GoogleFonts.rubik(
                                    color: Color.fromARGB(255, 214, 214, 214),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              _reportUserItem("Spam"),
                              _reportUserItem("Sadece bundan hoşlanmadım"),
                              _reportUserItem("İntihar, kendine zarar verme veya yeme bozuklukları"),
                              _reportUserItem("Yasal düzenlemeye tabi veya yasadışı ürünlerin satışı"),
                              _reportUserItem("Çıplaklık veya cinsellik"),
                              _reportUserItem("Nefret söylemi veya sembolleri"),
                              _reportUserItem("Şiddet veya tehlikeli örgütler"),
                              _reportUserItem("Zorbalık veya taciz"),
                              _reportUserItem("Fikri mülkiyet ihlali"),
                              _reportUserItem("Yanıltıcı veya dolandırma amaçlı olabilir"),
                              _reportUserItem("Yanlış bilgiler"),
                              _reportUserItem("Bir başkasını taklit ediyor."),
                              _reportUserItem("13 yaşından küçük olabilir."),
                            ],
                          )
                        ],
                      );
                    });
              },
            ),
          ],
        );
      });
}
