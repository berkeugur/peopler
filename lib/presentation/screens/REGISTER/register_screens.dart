import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/presentation/screens/REGISTER/city_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/email_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/gender_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/name_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/biography_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/password_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/profile_photo.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class RegisterScreens extends StatefulWidget {
  const RegisterScreens({Key? key}) : super(key: key);

  @override
  State<RegisterScreens> createState() => _RegisterScreensState();
}

class _RegisterScreensState extends State<RegisterScreens> {
  PageController _pageController = PageController();
  ValueNotifier<int> currentPageValue = ValueNotifier(0);

  TextEditingController displayNameController = TextEditingController();
  ValueNotifier<GenderTypes?> selectedGender = ValueNotifier(null);
  @override
  void initState() {
    super.initState();
    displayNameController = TextEditingController();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      registerDisplayName(
        context: context,
        pageController: _pageController,
        textEditingController: displayNameController,
      ),
      registerGenderSelect(
        context: context,
        selectedType: selectedGender,
      ),
      RegisterBiography(pageController: _pageController),
      RegisterCitySelect(),
      RegisterEmail(pageController: _pageController),
      RegisterPassword(pageController: _pageController),
      RegisterProfilePhoto(),
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          printf("basıldı");
          FocusScope.of(context).unfocus();
          await _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
      appBar: PeoplerAppBars(context: context).REGISTER,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
                child: AppBar(
                  shadowColor: Colors.transparent,
                  //backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  title: SizedBox(
                    height: 50,
                    child: ValueListenableBuilder(
                      valueListenable: currentPageValue,
                      builder: (context, _, __) {
                        return StepProgressIndicator(
                          unselectedColor: const Color(0xFF9ABAF9).withOpacity(0.7),
                          selectedColor: Colors.white, //Theme.of(context).primaryColor,
                          customStep: (int index, Color color, double size) {
                            return Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              //child: Text('$index $size'),
                            );
                          },
                          totalSteps: pages.length,
                          currentStep: currentPageValue.value + 1,
                        );
                      },
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int index) {
                        //FocusScope.of(context).unfocus();
                        currentPageValue.value = index;
                      },
                      physics: const BouncingScrollPhysics(),
                      children: pages,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
