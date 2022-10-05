import 'package:flutter/material.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/presentation/screens/REGISTER/FAB_functions/completion_fab.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/city_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/email_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/gender_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/name_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/biography_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/FAB_functions/next_page_fab.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/password_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/profile_photo.dart';
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
  TextEditingController biographyController = TextEditingController();
  ValueNotifier<String?> selecetCity = ValueNotifier(null);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    displayNameController = TextEditingController();
    _pageController = PageController();
    biographyController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    displayNameController.dispose();
    _pageController.dispose();
    biographyController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
      registerBiography(
        context: context,
        pageController: _pageController,
        textEditingController: biographyController,
      ),
      registerCitySelect(
        selecetCity: selecetCity,
      ),
      registerEmail(
        context: context,
        pageController: _pageController,
        textEditingController: emailController,
      ),
      registerPassword(
        context: context,
        pageController: _pageController,
        textEditingController: passwordController,
      ),
      registerProfilePhoto(
        context: context,
        stateSetter: setState,
      ),
    ];

    return Scaffold(
      floatingActionButton: currentPageValue.value == pages.length - 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                await completionFABFuncion(
                  context,
                  _pageController,
                  currentPageValue,
                  selectedGender,
                  biographyController,
                  selecetCity,
                  emailController,
                  passwordController,
                  displayNameController,
                );
              },
              label: const Text("Tamamla"),
              icon: const Icon(Icons.done),
            )
          : FloatingActionButton(
              onPressed: () async {
                await nextPageFABFunction(
                  context,
                  _pageController,
                  currentPageValue,
                  selectedGender,
                  biographyController,
                  selecetCity,
                  emailController,
                  passwordController,
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
                        setState(() {});
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
