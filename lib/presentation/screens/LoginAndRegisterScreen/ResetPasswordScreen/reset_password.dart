import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../others/classes/variables.dart';
import 'functions.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<UserBloc, UserState>(
      listener: (BuildContext context, state) {
        if (state is ResetPasswordSentState) {
          resetPasswordSentFunction(context);
        } else if (state is InvalidEmailState) {
          invalidEmailFunction(context);
        } else if (state is UserNotFoundState) {
          userNotFoundFunction(context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                const SizedBox(
                                  height: 15,
                                ),
                                Center(
                                    child: Text(
                                  "Hesabını bul",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                      color: const Color(0xFF000B21), fontSize: screenWidth < 360 || screenHeight < 480 ? 32 : 48, fontWeight: FontWeight.w400),
                                )),
                                const SizedBox(
                                  height: 35,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                  child: Text(
                                    "E-Mail Adresin",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 10, 0, 20, 0),
                                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                  height: 50,
                                  decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(25)),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: const Color(0xFF000000),
                                    onEditingComplete: () {
                                      setState(() {});
                                    },
                                    maxLength: 105,
                                    controller: resetPasswordController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        size: 25,
                                        color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.6),
                                      ),
                                      counterText: "",
                                      contentPadding: const EdgeInsets.fromLTRB(0, 13, 0, 10),
                                      hintMaxLines: 1,
                                      border: InputBorder.none,
                                      hintText: 'isimsoyisim@uni.edu.tr',
                                      hintStyle: TextStyle(color: Color.fromARGB(255, 219, 233, 255), fontSize: 16),
                                    ),
                                    style: TextStyle(color: Color.fromARGB(255, 204, 221, 255)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      resetPasswordButtonOnPressed(context);
                                    },
                                    child: Text(
                                      "Kod Gönder",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(color: const Color(0xFF000B21), fontSize: 20, fontWeight: FontWeight.w200),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height - (460 + MediaQuery.of(context).padding.top),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: screenWidth,
                                      child: LimitedBox(
                                          child: Text(
                                        "Kurtarma maili gelmedi mi?",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.rubik(
                                            color: const Color(0xFF0353EF),
                                            fontSize: screenWidth < 360 || screenHeight < 480 ? 16 : 22,
                                            fontWeight: FontWeight.w200),
                                      )),
                                    ),
                                    SizedBox(
                                      width: screenWidth,
                                      child: LimitedBox(
                                          child: Text(
                                        "Bilgi ve iletişim için;",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.rubik(
                                            color: const Color(0xFF000B21),
                                            fontSize: screenWidth < 360 || screenHeight < 480 ? 16 : 22,
                                            fontWeight: FontWeight.w200),
                                      )),
                                    ),
                                    SizedBox(
                                      width: screenWidth,
                                      child: LimitedBox(
                                          child: Text(
                                        "info@peopler.app",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.rubik(
                                            color: const Color(0xFF000B21),
                                            fontSize: screenWidth < 360 || screenHeight < 480 ? 16 : 22,
                                            fontWeight: FontWeight.w600),
                                      )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight < 630 ? 30 : 60,
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
