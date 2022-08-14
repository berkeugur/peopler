import 'package:flutter/material.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/WelcomeScreen/welcome_component.dart';
import 'package:peopler/presentation/screens/LoginAndRegisterScreen/WelcomeScreen/welcome_functions.dart';

const String wpPeoplerTitle = "peopler";
const String wpAreYouAlreadyMember = "Zaten üye misin?";
const String wpContinueWithLinkedin = "LIKNEDIN İLE DEVAM ET";
const String wpContinueWithUniversityEmail = "ÜNİVERSİTE MAİLİ İLE DEVAM ET";

const String redirectUrl = 'https://www.linkedin.com/developers/tools/oauth/redirect';
const String clientId = '86y9muk6ijz659';
const String clientSecret = 'i62L3g64VMlChHqS';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF0353EF),
      body: buildBody(screenWidth, context),
    );
  }

  Center buildBody(double screenWidth, BuildContext context) {
    return Center(
      child: SizedBox(
        width: screenWidth > 1200 ? 1200 : screenWidth,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: buildTitle(),
            ),
            Expanded(flex: 2, child: continueText(context)),
            Expanded(
              flex: 3,
              child: buildButtons(context),
            ),
            Expanded(
              flex: 2,
              child: areYouAlreadyMemberText(
                onPressed: () {
                  areYouAlreadyMemberOnPressed(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
