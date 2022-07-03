import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../WelcomeScreen/welcome_component.dart';
import '../common_widgets.dart';
import 'components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

ScrollController jumpToBottomScrollController = ScrollController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFFFFF),
        body: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                                  style: GoogleFonts.rubik(
                                      color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
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
                                  style: GoogleFonts.rubik(
                                      color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
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
                                    Navigator.of(context).pushNamed('/resetPasswordScreen');
                                  },
                                  child: Text(
                                    "Şifremi Unuttum",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
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
}
