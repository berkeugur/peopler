import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/core/constants/reloader/reload.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/system_ui_service.dart';
import '../../../../data/repository/connectivity_repository.dart';
import '../../../../others/classes/variables.dart';
import '../../../../others/locator.dart';
/*
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final ScrollController jumpToBottomScrollController;

  @override
  void initState() {
    jumpToBottomScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFFFFF),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: SingleChildScrollView(
            controller: jumpToBottomScrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 31,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Color(0xFF0353EF),
                    size: 32,
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: screenWidth < 350 ? screenWidth : 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "peopler",
                            textScaleFactor: 1,
                            style: GoogleFonts.spartan(
                              color: const Color(0xFF0353EF),
                              fontWeight: FontWeight.w800,
                              fontSize: 54,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight < 700 ? 75 : 100,
                        ),
                        AutofillGroup(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                child: Text(
                                  "Mail Adresin",
                                  textScaleFactor: 1,
                                  style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
                                ),
                              ),
                              emailFormField(setState, screenWidth),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                child: Text(
                                  "Şifren",
                                  textScaleFactor: 1,
                                  style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
                                ),
                              ),
                              passwordInputField(setState, screenWidth),
                              const SizedBox(
                                height: 60,
                              ),
                              signInButton(context),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(NavigationConstants.RESET_PASSWORD_SCREEN);
                                  },
                                  child: Text(
                                    "Şifremi Unuttum",
                                    textScaleFactor: 1,
                                    style: PeoplerTextStyle.normal.copyWith(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> signInFunction({required BuildContext context}) async {
    //await Future.delayed(Duration(seconds: 10));
    final ConnectivityRepository _connectivityRepository = locator<ConnectivityRepository>();
    bool _connection = await _connectivityRepository.checkConnection(context);
    if (_connection == false) return;

    if (loginEmailController.text.isEmpty && loginPasswordController.text.isEmpty) {
      SnackBars(context: context).simple("Lütfen e posta adresinizi ve şifrenizi girin.");
    } else if (loginEmailController.text.isEmpty) {
      SnackBars(context: context).simple("Lütfen e posta adresinizi girin.");
    } else if (loginPasswordController.text.isEmpty) {
      SnackBars(context: context).simple("Lütfen şifrenizi girin.");
    } else if (loginEmailController.text.isNotEmpty && loginPasswordController.text.isNotEmpty) {
      BlocProvider.of<UserBloc>(context).add(signInWithEmailandPasswordEvent(email: loginEmailController.text, password: loginPasswordController.text));
    }
  }

  Center signInButton(context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    return Center(
      child: BlocListener<UserBloc, UserState>(
        bloc: _userBloc,
        listener: (context, UserState state) {
          if (state is SignedInState) {
            /// Set theme mode before Home Screen
            SystemUIService().setSystemUIforThemeMode();

            Navigator.of(context).pushReplacementNamed(NavigationConstants.HOME_SCREEN);
            Reloader.isLoginButtonTapped.value = false;
          } else if (state is SignedInNotVerifiedState) {
            Navigator.of(context).pushReplacementNamed(NavigationConstants.VERIFY_SCREEN);
            Reloader.isLoginButtonTapped.value = false;
          } else if (state is InvalidEmailState) {
            SnackBars(context: context).simple("E posta adresiniz istenilen biçimde değil!");
            Reloader.isLoginButtonTapped.value = false;
          } else if (state is UserNotFoundState) {
            SnackBars(context: context).simple("Böyle bir e posta adresi kayıtlı değil veya silinmiş olabilir!");
            Reloader.isLoginButtonTapped.value = false;
          } else if (state is WrongPasswordState) {
            SnackBars(context: context).simple("Hatalı şifre girdiniz.\nŞifrenizi unuttuysanız sıfırlayabilirsiniz");
            Reloader.isLoginButtonTapped.value = false;
          }
        },
        child: InkWell(
          onTap: () async {
            Reloader.isLoginButtonTapped.value = true;
            await signInFunction(context: context);
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 40,
            width: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF0353EF),
            ),
            child: Center(
              child: ValueListenableBuilder(
                  valueListenable: Reloader.isLoginButtonTapped,
                  builder: (context, _, __) {
                    return Reloader.isLoginButtonTapped.value == true
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      "Giriş Yap",
                      textScaleFactor: 1,
                      style: PeoplerTextStyle.normal.copyWith(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Container passwordInputField(StateSetter setState, double screenWidth) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 40, 0, 20, 0),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      height: 50,
      decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(25)),
      child: TextField(
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 500), () {
            jumpToBottomScrollController.animateTo(jumpToBottomScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
        obscureText: isVisibleLoginPassword,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: const Color(0xFFB3CBFA),
        maxLength: MaxLengthConstants.PASSWORD,
        controller: loginPasswordController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isVisibleLoginPassword = !isVisibleLoginPassword;
                });
              },
              icon: Icon(
                isVisibleLoginPassword == true ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFFB3CBFA).withOpacity(0.6),
              )),
          counterText: "",
          contentPadding: const EdgeInsets.fromLTRB(0, 13, 0, 10),
          hintMaxLines: 1,
          border: InputBorder.none,
          hintText: 'Şifre',
          hintStyle: const TextStyle(color: Color(0xFFB3CBFA), fontSize: 18),
        ),
        style: const TextStyle(color: Color(0xFFFFFFFF)),
        autofillHints: const [AutofillHints.password],
        onEditingComplete: () => TextInput.finishAutofillContext(),
      ),
    );
  }

  Container emailFormField(StateSetter setState, double screenWidth) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 10, 0, 20, 0),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      height: 50,
      decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(25)),
      child: TextField(
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 500), () {
            jumpToBottomScrollController.animateTo(jumpToBottomScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
        keyboardType: TextInputType.emailAddress,
        cursorColor: const Color(0xFFB3CBFA),
        onEditingComplete: () {
          setState(() {});
        },
        maxLength: MaxLengthConstants.EMAIL,
        controller: loginEmailController,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.fromLTRB(30, 13, 0, 10),
          hintMaxLines: 1,
          border: InputBorder.none,
          hintText: 'isimsoyisim@uni.edu.tr',
          hintStyle: TextStyle(color: Color(0xFFB3CBFA), fontSize: 16),
        ),
        style: const TextStyle(color: Color(0xFFFFFFFF)),
        autofillHints: const [AutofillHints.email],
      ),
    );
  }

}
*/