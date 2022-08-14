import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/presentation/screens/Settings/settings.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../tab_item.dart';
import '../../GuestLoginScreen/guest_login_screen.dart';

// ignore: non_constant_identifier_names
op_settings_icon(context) {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  if (UserBloc.user != null) {
    _userBloc.mainKey.currentState?.push(
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Giriş Yapmalısınız.",
              style: GoogleFonts.rubik(
                color: Color(0xFF0353EF),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Kapat",
                    style: GoogleFonts.rubik(
                      color: Color(0xFF0353EF),
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    //welcomescreen a git
                  },
                  child: Text(
                    "Giriş Yap",
                    style: GoogleFonts.rubik(
                      color: Color(0xFF0353EF),
                    ),
                  )),
            ],
          );
        });
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
  _homeScreen.navigatorKeys[TabItem.chat]!.currentState!.pushNamed('/chat');
}

tripleDotOnPressed(
  BuildContext context,
  String feedId,
  String feedExplanation,
  String userID,
  String userDisplayName,
  String userGender,
  DateTime createdAt,
  String userPhotoUrl,
) {
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
                'Şikayet Et',
                textScaleFactor: 1,
                style: GoogleFonts.rubik(fontSize: 14, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _showReportBottomSheet(context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl);
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
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.white,
              height: 1,
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Bu gönderiyi neden şikayet ediyorsunuz?",
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
              _reportItem("Spam", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Çıplaklık veya cinsellik", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Sadece bundan hoşlanmadım", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Sahtekarlık ve dolandırıcılık", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Nefret söylemi veya sembolleri", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Yanlış bilgiler", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Zorbalık veya taciz", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Şiddet veya tehlikeli örgütler", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Fikri mülkiyet ihlali", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Yasal düzenlemeye tabi veya yasadışı ürünlerin satışı", context, feedId, feedExplanation, userID, userDisplayName, userGender,
                  createdAt, userPhotoUrl),
              _reportItem("İntihar veya kendine zarar verme", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
              _reportItem("Yeme bozuklukları", context, feedId, feedExplanation, userID, userDisplayName, userGender, createdAt, userPhotoUrl),
            ])
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
  String userDisplayName,
  String userGender,
  DateTime createdAt,
  String userPhotoUrl,
) {
  return InkWell(
    onTap: () {
      UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
      if (UserBloc.user != null) {
        CollectionReference _reports = FirebaseFirestore.instance.collection('reports');
        _reports.add({
          "type": text,
          "feedID": feedId,
          "feedExplanation": feedExplanation,
          "userID": userID,
          "userDisplayName": userDisplayName,
          "userGender": userGender,
          "createdAt": createdAt,
          "userPhotoUrl": userPhotoUrl,
          "fromUserId": MyUser().userID,
          "fromUserDisplayName": MyUser().displayName,
        }).then((value) {
          print("then");
        }).catchError((error) => print("Failed to add feed: $error"));

        print("reported: $text");

        Navigator.pop(context);

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Talebiniz Alındı',
                  textScaleFactor: 1,
                ),
                content: Text(
                  'En kısa sürede şikayetiniz incelenecektir! Bizi bilgilendirdiğiniz için teşekkür ederiz.',
                  textScaleFactor: 1,
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Kapat',
                        textScaleFactor: 1,
                      )),
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Giriş Yapmalısınız.",
                  style: GoogleFonts.rubik(
                    color: Color(0xFF0353EF),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Kapat",
                        style: GoogleFonts.rubik(
                          color: Color(0xFF0353EF),
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        //welcomescreen a git
                      },
                      child: Text(
                        "Giriş Yap",
                        style: GoogleFonts.rubik(
                          color: Color(0xFF0353EF),
                        ),
                      )),
                ],
              );
            });
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
          Icon(
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
