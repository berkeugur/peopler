import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';

import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../others/classes/responsive_size.dart';
import '../../../../others/classes/variables.dart';
import '../../../../others/widgets/snack_bars.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  late final UserBloc _userBloc;

  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.initState();
  }

  final ScrollController _jumpToBottomScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: SizedBox(
            child: SingleChildScrollView(
              controller: _jumpToBottomScrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth / 5 * 1,
                    color: const Color(0xFF0353EF),
                    height: 5,
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 500,
                          height: MediaQuery.of(context).size.height,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Etrafındaki İnsanları",
                                          textScaleFactor: 1,
                                          style: GoogleFonts.rubik(
                                              color: const Color(0xFF000B21),
                                              fontSize: screenWidth < 360 || screenHeight < 480 ? 20 : 28,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          "Keşfet",
                                          textScaleFactor: 1,
                                          style: GoogleFonts.rubik(
                                              color: const Color(0xFF0353EF),
                                              fontSize: screenWidth < 360 || screenHeight < 480 ? 20 : 28,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          height: screenHeight < 630 ? 30 : 60,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Visibility(
                                              visible: screenHeight < 470 ? false : true,
                                              child: Image.asset(
                                                'vector1.png',
                                                height: screenHeight < 580 ? 126.0 : 198.0,
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
                                              padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                              child: Text(
                                                "İsmin Nedir ?",
                                                textScaleFactor: 1,
                                                style: GoogleFonts.rubik(color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 40, 0, 20, 0),
                                              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                              height: 40,
                                              decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(20)),
                                              child: TextField(
                                                onTap: () async {
                                                  await Future.delayed(const Duration(milliseconds: 500), () {
                                                    _jumpToBottomScrollController.animateTo(_jumpToBottomScrollController.position.maxScrollExtent,
                                                        duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                                  });
                                                },
                                                keyboardType: TextInputType.name,
                                                cursorColor: const Color(0xFFFFFFFF),
                                                onEditingComplete: () {
                                                  setState(() {});
                                                },
                                                onSubmitted: (value) {
                                                  nameNextFunction(context);
                                                },
                                                maxLength: MaxLengthConstants.DISPLAYNAME,
                                                controller: nameController,
                                                textInputAction: TextInputAction.next,
                                                decoration: const InputDecoration(
                                                  counterText: "",
                                                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                                  hintMaxLines: 1,
                                                  border: InputBorder.none,
                                                  hintText: 'Örneğin, Mehmet Yılmaz',
                                                  hintStyle: TextStyle(color: Color(0xFFB3CBFA), fontSize: 14),
                                                ),
                                                style: const TextStyle(color: Color(0xFFFFFFFF)),
                                                autofillHints: const [AutofillHints.name],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight < 550 ? 0 : 20,
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 160),
                                    child: TextButton(
                                      onPressed: () {
                                        nameNextFunction(context);
                                      },
                                      child: Text(
                                        "Devam",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.rubik(
                                            color: nameController.text.isEmpty ? const Color(0xFF0353EF) : const Color(0xFF0353EF),
                                            fontSize: 22,
                                            fontWeight: nameController.text.isEmpty ? FontWeight.w300 : FontWeight.w400),
                                      ),
                                    ),
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
      ),
    );
  }
}

nameNextFunction(context) {
  if (nameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
          context: context,
          title: "Lütfen isim ve soy isminizi girin.",
          icon: Icons.warning_outlined,
          textColor: const Color(0xFFFFFFFF),
          bgColor: const Color(0xFF000B21)),
    );
  } else if (nameController.text.replaceAll(" ", "").length < 4) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
          context: context,
          title: "İsim Soyisminiz çok kısa.",
          icon: Icons.warning_outlined,
          textColor: const Color(0xFFFFFFFF),
          bgColor: const Color(0xFF000B21)),
    );
  } else {
    UserBloc.user?.displayName = nameController.text;
    Navigator.of(context).pushNamed(NavigationConstants.GENDER_SELECT_SCREEN);
  }
}
