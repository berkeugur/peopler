import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/CustomWidgets/AUTH_BUTTONS/linkedin.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/LoginScreen/components/create_account_button.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/LoginScreen/components/email_field.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/LoginScreen/components/forgot_password.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/LoginScreen/components/login_button.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/LoginScreen/components/or_divider.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/LoginScreen/components/password_field.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/WelcomeScreen/welcome_functions.dart';
import '../../../../core/system_ui_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    SystemUIService().setSystemUIForBlue();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Container(
            color: const Color(0xFF0353EF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Giriş Yap",
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: screenWidth < 350 ? screenWidth : 350,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AutofillGroup(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Text(
                                        "E-posta",
                                        textScaleFactor: 1,
                                        style: PeoplerTextStyle.normal.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    emailFormField(setState, screenWidth),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Text(
                                        "Şifre",
                                        textScaleFactor: 1,
                                        style: PeoplerTextStyle.normal.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    passwordInputField(context, setState, screenWidth),
                                    //const SizedBox(height: 60),
                                    //signInButton(context),
                                    const SizedBox(height: 10),
                                    const ForgotPasswordButton(),
                                    const SizedBox(height: 10),
                                    LoginButton(),
                                    const SizedBox(height: 15),
                                    const OrDivider(),
                                    const SizedBox(height: 15),
                                    LinkedinButton.style2(
                                      onTap: () {
                                        continueWithLinkedinButtonOnPressed(context);
                                      },
                                    ),
                                    const SizedBox(height: 25),
                                    const CreateNewAccountButton(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
