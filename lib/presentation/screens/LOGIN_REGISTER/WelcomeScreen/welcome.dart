import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/app_platform.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/core/constants/visibility/widget_visibility.dart';
import 'package:peopler/core/system_ui_service.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/VerificationScreen/verification_screen.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/WelcomeScreen/welcome_component.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/WelcomeScreen/welcome_functions.dart';
import 'package:peopler/presentation/screens/REGISTER/register_linkedin_screens.dart';
import 'package:peopler/presentation/screens/REGISTER/register_normal_screens.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';

const String wpPeoplerTitle = "peopler";
const String wpAreYouAlreadyMember = "Zaten üye misin?";
const String wpContinueWithLinkedin = "Linkedin ile devam et";
const String wpContinueWithUniversityEmail = "Üniversite maili ile devam et";
const String wpContinueWithApple = "Apple Girişi";
const String wpContinueWithGuest = "Misafir Girişi";

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    return BlocListener<UserBloc, UserState>(
      bloc: _userBloc,
      listener: (context, UserState state) {
        if (state is SignedInState) {
          /// Set theme mode before Home Screen
          SystemUIService().setSystemUIforThemeMode();

          Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
        } else if (state is SignedInMissingInfoState) {
          if (UserBloc.user?.displayName == null || UserBloc.user?.displayName == '') {
            Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.NAME_SCREEN, (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.CONTINUE_WITH_LINKEDIN, (Route<dynamic> route) => false);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0353EF),
        body: buildBody(screenWidth, context),
      ),
    );
  }

  Center buildBody(double screenWidth, BuildContext context) {
    return Center(
      child: SizedBox(
        width: screenWidth > 1200 ? 1200 : screenWidth,
        child: Column(
          children: [
            Expanded(
              flex: MediaQuery.of(context).size.height > 800
                  ? 70
                  : MediaQuery.of(context).size.height > 700
                      ? 60
                      : MediaQuery.of(context).size.height > 600
                          ? 50
                          : MediaQuery.of(context).size.height > 500
                              ? 30
                              : 20,
              child: buildTitle(),
            ),
            Expanded(
              flex: MediaQuery.of(context).size.height > 600 ? 45 : 40,
              child: buildButtons(context),
            ),
            Expanded(
              flex: MediaQuery.of(context).size.height > 600 ? 20 : 15,
              child: Column(
                children: [
                  if (AppPlatform.isAndroid) buildWaitingList(context),
                  Visibility(
                    visible: WidgetVisibility.isNewRegisterScreensVisiable,
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RegisterScreens(),
                          ));
                        },
                        child: const Text("yeni kayıt ekranları")),
                  ),
                  areYouAlreadyMemberText(
                    onPressed: () {
                      areYouAlreadyMemberOnPressed(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWaitingList(BuildContext context) {
    return TextButton(
      onPressed: () {
        TextEditingController _controller = TextEditingController();
        showDialog(
          context: context,
          builder: (_ctx) {
            return AlertDialog(
              title: const Text("Bekleme Listesine Başvur"),
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
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.white,
                  maxLength: MaxLengthConstants.EMAIL,
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  autocorrect: true,
                  decoration: const InputDecoration(
                    counterText: "",
                    contentPadding: EdgeInsets.fromLTRB(0, 13, 0, 10),
                    hintMaxLines: 1,
                    border: InputBorder.none,
                    hintText: 'E-Posta Adresiniz',
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
                      await FirebaseFirestore.instance.collection("waitinglist").doc().set({
                        "email": _controller.text,
                        "createdAt": Timestamp.now(),
                      }).then((value) {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (contextSD) => AlertDialog(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                            contentPadding: const EdgeInsets.only(top: 25.0, bottom: 10, left: 25, right: 25),
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
                  child: const Text("Başvur"),
                ),
              ],
            );
          },
        );
      },
      child: const Text(
        "Bunlardan hiçbiri yok mu?",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontFamily: "Rubik",
          fontStyle: FontStyle.normal,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
