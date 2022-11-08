import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/LoginScreen/login_screen.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../data/repository/connectivity_repository.dart';
import '../../../../data/services/remote_config/remote_config.dart';
import '../../../../others/classes/variables.dart';
import '../../../../others/functions/image_picker_functions.dart';
import '../../../../others/locator.dart';

class EmailAndPasswordScreen extends StatefulWidget {
  const EmailAndPasswordScreen({Key? key}) : super(key: key);

  @override
  _EmailAndPasswordScreenState createState() => _EmailAndPasswordScreenState();
}

class _EmailAndPasswordScreenState extends State<EmailAndPasswordScreen> {
  late final UserBloc _userBloc;
  late final ScrollController _jumpToBottomScrollController;

  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _jumpToBottomScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFFFFF),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, _keyboardHeight),
          child: SizedBox(
            child: SingleChildScrollView(
              controller: _jumpToBottomScrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*----------------------------------------------------------------------------*/
                  Container(
                    width: screenWidth / 5 * 4,
                    color: const Color(0xFF0353EF),
                    height: 5,
                  ),
                  /*----------------------------------------------------------------------------*/

                  /*----------------------------------------------------------------------------*/
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 500,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*----------------------------------------------------------------------------*/
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios_outlined,
                                        color: Color(0xFF000B21),
                                        size: 32,
                                      ),
                                    ),
                                    /*----------------------------------------------------------------------------*/

                                    /*----------------------------------------------------------------------------*/
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    /*----------------------------------------------------------------------------*/

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "peopler",
                                                textScaleFactor: 1,
                                                style: GoogleFonts.spartan(
                                                    color: const Color(0xFF0353EF),
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: screenWidth < 360 || screenHeight < 480 ? 36 : 36),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "deneyimine\nçok az kaldı",
                                                textScaleFactor: 1,
                                                style: PeoplerTextStyle.normal.copyWith(
                                                    color: const Color(0xFF000000),
                                                    fontSize: screenWidth < 360 || screenHeight < 480 ? 36 : 36,
                                                    fontWeight: FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    /*----------------------------------------------------------------------------*/
                                    SizedBox(
                                      height: screenHeight < 630 ? 30 : 60,
                                    ),
                                    /*----------------------------------------------------------------------------*/

                                    /*----------------------------------------------------------------------------*/
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /*----------------------------------------------------------------------------*/

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                          child: Text(
                                            "Doğrulama kodunu nereye gönderelim?",
                                            textScaleFactor: 1,
                                            style: PeoplerTextStyle.normal
                                                .copyWith(color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
                                          ),
                                        ),

                                        /*----------------------------------------------------------------------------*/

                                        /*--------------------------EMAIL TEXT FIELD--------------------------------------------------*/
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 40, 0, 20, 0),
                                          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                          height: 50,
                                          decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(20)),
                                          child: TextField(
                                            onTap: () async {
                                              await Future.delayed(const Duration(milliseconds: 500), () {
                                                if (_jumpToBottomScrollController.hasClients) {
                                                  _jumpToBottomScrollController.animateTo(_jumpToBottomScrollController.position.maxScrollExtent,
                                                      duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                                }
                                              });
                                            },
                                            keyboardType: TextInputType.emailAddress,
                                            cursorColor: const Color(0xFF000000),
                                            onEditingComplete: () {
                                              setState(() {});
                                            },
                                            maxLength: MaxLengthConstants.EMAIL,
                                            controller: registerEmailController,
                                            textInputAction: TextInputAction.next,
                                            decoration: const InputDecoration(
                                              counterText: "",
                                              contentPadding: EdgeInsets.fromLTRB(0, 13, 0, 10),
                                              hintMaxLines: 1,
                                              border: InputBorder.none,
                                              hintText: 'isimsoyisim@uni.edu.tr',
                                              hintStyle: TextStyle(color: Color(0xFF9ABAF9), fontSize: 16),
                                            ),
                                            style: const TextStyle(
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),

                                        /*----------------------------EMAIL TEXT FIELD------------------------------------------------*/

                                        /*----------------------------------------------------------------------------*/
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                                          child: Text(
                                            "Sadece üniversite mailin ile kayıt olabilirsin.",
                                            textScaleFactor: 1,
                                            style: PeoplerTextStyle.normal
                                                .copyWith(color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                        /*----------------------------------------------------------------------------*/

                                        /*----------------------------------------------------------------------------*/
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        /*----------------------------------------------------------------------------*/

                                        /*----------------------------------------------------------------------------*/
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                          child: Text(
                                            "Şifreni belirle",
                                            textScaleFactor: 1,
                                            style: PeoplerTextStyle.normal
                                                .copyWith(color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                        /*----------------------------------------------------------------------------*/

                                        /*-----------------------------FIRST PASSWORD TEXT FIELD-----------------------------------------------*/
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 40, 0, 20, 0),
                                          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0353EF),
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          child: TextField(
                                            onTap: () async {
                                              await Future.delayed(const Duration(milliseconds: 500), () {
                                                if (_jumpToBottomScrollController.hasClients) {
                                                  _jumpToBottomScrollController.animateTo(_jumpToBottomScrollController.position.maxScrollExtent,
                                                      duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                                }
                                              });
                                            },
                                            obscureText: isVisiblePassword,
                                            keyboardType: TextInputType.visiblePassword,
                                            cursorColor: const Color(0xFF000000),
                                            autofocus: true,
                                            onEditingComplete: () {
                                              setState(() {});
                                            },
                                            maxLength: MaxLengthConstants.PASSWORD,
                                            controller: registerPasswordController,
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    isVisiblePassword = !isVisiblePassword;
                                                  });
                                                },
                                                icon: Icon(
                                                  isVisiblePassword == true ? Icons.visibility : Icons.visibility_off,
                                                  color: const Color(0xFF9ABAF9),
                                                ),
                                              ),
                                              counterText: "",
                                              contentPadding: const EdgeInsets.fromLTRB(0, 13, 0, 10),
                                              hintMaxLines: 1,
                                              border: InputBorder.none,
                                              hintText: 'Şifre',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFF9ABAF9),
                                                fontSize: 16,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        /*---------------------------FIRST PASSWORD TEXT FIELD-------------------------------------------------*/

                                        /*----------------------------------------------------------------------------*/
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        /*----------------------------------------------------------------------------*/

                                        /*----------------------------------------------------------------------------*/
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                          child: Text(
                                            "Şifre tekrar",
                                            textScaleFactor: 1,
                                            style: PeoplerTextStyle.normal
                                                .copyWith(color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                        /*----------------------------------------------------------------------------*/

                                        /*--------------------------SECOND PASSWORD TEXT FIELD--------------------------------------------------*/
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 40, 0, 20, 0),
                                          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                          height: 50,
                                          decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(25)),
                                          child: TextField(
                                            onTap: () async {
                                              await Future.delayed(const Duration(milliseconds: 500), () {
                                                if (_jumpToBottomScrollController.hasClients) {
                                                  _jumpToBottomScrollController.animateTo(_jumpToBottomScrollController.position.maxScrollExtent,
                                                      duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                                }
                                              });
                                            },
                                            obscureText: isVisibleCheckPassword,
                                            keyboardType: TextInputType.visiblePassword,
                                            cursorColor: const Color(0xFF000000),
                                            onEditingComplete: () {
                                              setState(() {});
                                            },
                                            maxLength: MaxLengthConstants.PASSWORD,
                                            controller: registerPasswordCheckController,
                                            textInputAction: TextInputAction.next,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isVisibleCheckPassword = !isVisibleCheckPassword;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    isVisibleCheckPassword == true ? Icons.visibility : Icons.visibility_off,
                                                    color: const Color(0xFF9ABAF9),
                                                  )),
                                              counterText: "",
                                              contentPadding: const EdgeInsets.fromLTRB(0, 13, 0, 10),
                                              hintMaxLines: 1,
                                              border: InputBorder.none,
                                              hintText: 'Şifre Tekrar',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFF9ABAF9),
                                                fontSize: 16,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),

                                        /*-------------------------SECOND PASSWORD TEXT FIELD---------------------------------------------------*/
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              /*--------------------CONTINUE BUTTON----------------------*/
                              _buildContinueButton(context),
                              /*--------------------CONTINUE BUTTON----------------------*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center _buildContinueButton(BuildContext context) {
    return Center(
      child: BlocListener<UserBloc, UserState>(
        bloc: _userBloc,
        listener: (context, UserState state) async {
          if (state is SignedInNotVerifiedState) {
            _userBloc.add(waitFor15minutes());

            /// Upload Profile Photo
            if (UserBloc.user?.profileURL == "") {
              _userBloc.add(uploadProfilePhoto(imageFile: image));
            }

            Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.BEG_FOR_PERMISSION_SCREEN, (Route<dynamic> route) => false);
          } else if (state is InvalidEmailState) {
            SnackBars(context: context).simple("E posta adresiniz istenilen biçimde değil!");
          } else if (state is UserNotFoundState) {
            SnackBars(context: context).simple("Böyle bir e posta adresi kayıtlı değil veya silinmiş olabilir!");
          } else if (state is EmailAlreadyInUseState) {
            SnackBars(context: context).simple(
                "${registerEmailController.text} zaten kullanılıyor. \n\nSizin ise lütfen giriş yapın. \n\nSizin değil ise lütfen destek@peopler.app adresine durumu bildiren bir e-posta atın.");
          } else if (state is WeakPasswordState) {
            SnackBars(context: context).simple("${registerEmailController.text} Şifre en az 6 karakterden oluşmalı.");
          }
        },
        child: BlocBuilder(
          bloc: _userBloc,
          builder: (context, state) {
            if (state is SigningInState) {
              return FutureBuilder(
                  future: PeoplerDialogs().loadingDialogFullScreen(
                    context: context,
                    loadingTexts: [
                      "Hesabınız Oluşturuluyor...",
                      "Peopler'a katılmana çok az kaldı",
                    ],
                  ),
                  builder: (context, sn) {
                    return Text(
                      "Devam",
                      textScaleFactor: 1,
                      style: PeoplerTextStyle.normal.copyWith(
                          color: UserBloc.user?.gender == "" ? const Color(0xFF0353EF) : const Color(0xFF0353EF),
                          fontSize: 22,
                          fontWeight: nameController.text.isEmpty || UserBloc.user?.city == "" ? FontWeight.w300 : FontWeight.w500),
                    );
                  });
            } else {
              return TextButton(
                onPressed: () async {
                  final ConnectivityRepository _connectivityRepository = locator<ConnectivityRepository>();
                  bool _connection = await _connectivityRepository.checkConnection(context);

                  if (_connection == false) return;

                  bool _isEduDotTr =
                      registerEmailController.text.replaceAll(" ", "").toLowerCase().substring(registerEmailController.text.length - 7) == ".edu.tr"
                          ? true
                          : false;

                  final FirebaseRemoteConfigService _remoteConfigService = locator<FirebaseRemoteConfigService>();
                  if (_remoteConfigService.isEduRemoteConfig()) {
                    _isEduDotTr = true;
                  }

                  if (registerPasswordController.text == registerPasswordCheckController.text && _isEduDotTr == true) {
                    _userBloc.add(createUserWithEmailAndPasswordEvent(
                      email: registerEmailController.text.replaceAll(" ", ""),
                      password: registerPasswordController.text,
                    ));
                  } else if (registerPasswordController.text != registerPasswordCheckController.text) {
                    SnackBars(context: context).simple("Girdiğiniz şifreler aynı değil!");
                  } else if (_isEduDotTr == false) {
                    SnackBars(context: context).simple("Sadece .edu.tr uzantılı üniversite mailin ile kayıt olabilirsin!");
                  } else {
                    SnackBars(context: context).simple("Hata kodu #852585. Lütfen bize bildirin destek@peopler.app !");
                  }
                },
                child: Text(
                  "Devam",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                      color: UserBloc.user?.gender == "" ? const Color(0xFF0353EF) : const Color(0xFF0353EF),
                      fontSize: 22,
                      fontWeight: nameController.text.isEmpty || UserBloc.user?.city == "" ? FontWeight.w300 : FontWeight.w500),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
