import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../others/classes/responsive_size.dart';
import '../../../../others/widgets/snack_bars.dart';
import 'components.dart';

class GenderSelectScreen extends StatefulWidget {
  const GenderSelectScreen({Key? key}) : super(key: key);

  @override
  _GenderSelectScreenState createState() => _GenderSelectScreenState();
}

class _GenderSelectScreenState extends State<GenderSelectScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth / 5 * 2,
              color: const Color(0xFF0353EF),
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      if (UserBloc.user?.isTheAccountConfirmed == true) {
                        showLinkedInPopWarning(context);
                        return;
                      }

                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Color(0xFF0353EF),
                      size: 32,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Bulunabilir ol ve",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal
                        .copyWith(color: const Color(0xFF000B21), fontSize: screenWidth < 360 || screenHeight < 670 ? 24 : 36, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "Bul",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal
                        .copyWith(color: const Color(0xFF0353EF), fontSize: screenWidth < 360 || screenHeight < 670 ? 24 : 36, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: screenHeight < 630 ? 30 : 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: screenHeight < 560 ? false : true,
                        child: Image.asset(
                          'vector2.png',
                          height: screenHeight < 760 ? 140.0 : 220.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight < 630 ? 10 : 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Cinsiyetin ?",
                          textScaleFactor: 1,
                          style: PeoplerTextStyle.normal.copyWith(color: Colors.black, fontSize: ResponsiveSize().gs2(context), fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight < 580 ? 10 : 15,
                      ),
                      genderItem(context, genderText: "Kadın", stateSetter: setState),
                      SizedBox(
                        height: screenHeight < 580 ? 5 : 10,
                      ),
                      genderItem(context, genderText: "Erkek", stateSetter: setState),
                      SizedBox(height: screenHeight < 580 ? 5 : 10),
                      genderItem(context, genderText: "Diğer", stateSetter: setState),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight < 550 ? 0 : 20,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  if (UserBloc.user?.gender == "") {
                    SnackBars(context: context).simple("Lütfen cinsiyetinizi seçin.");
                  } else {
                    Navigator.pushNamed(context, NavigationConstants.CREATE_PROFILE_SCREEN);
                  }
                },
                child: Text(
                  "Devam",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                      color: UserBloc.user?.gender == "" ? const Color(0xFF0353EF) : const Color(0xFF0353EF),
                      fontSize: 22,
                      fontWeight: UserBloc.user?.gender == "" ? FontWeight.w300 : FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
