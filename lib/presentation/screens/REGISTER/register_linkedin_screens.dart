import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_event.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_state.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/presentation/screens/REGISTER/Linkedin_FAB_functions/linkedin_completion_fab.dart';
import 'package:peopler/presentation/screens/REGISTER/Linkedin_FAB_functions/linkedin_next_page_fab.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/city_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/gender_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/biography_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/profile_photo.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/constants/navigation/navigation_constants.dart';

class LinkedinRegisterScreens extends StatefulWidget {
  const LinkedinRegisterScreens({Key? key}) : super(key: key);

  @override
  State<LinkedinRegisterScreens> createState() => _LinkedinRegisterScreensState();
}

class _LinkedinRegisterScreensState extends State<LinkedinRegisterScreens> {
  late final UserBloc _userBloc;

  PageController _pageController = PageController();
  ValueNotifier<int> currentPageValue = ValueNotifier(0);

  ValueNotifier<GenderTypes?> selectedGender = ValueNotifier(null);
  TextEditingController biographyController = TextEditingController();
  ValueNotifier<String?> selecetCity = ValueNotifier(null);
  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.initState();
    _pageController = PageController();
    biographyController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    biographyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
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
      registerProfilePhoto(
        context: context,
        stateSetter: setState,
      ),
    ];

    return Scaffold(
      floatingActionButton: currentPageValue.value == pages.length - 1
          ? BlocListener<UserBloc, UserState>(
              bloc: _userBloc,
              listener: (context, UserState state) {
                if (state is SignedInNotVerifiedState) {
                  _userBloc.add(waitFor15minutes(context: context));
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      NavigationConstants.BEG_FOR_PERMISSION_SCREEN, (Route<dynamic> route) => false);
                } else if (state is InvalidEmailState) {
                  SnackBars(context: context).simple("E posta adresiniz istenilen biçimde değil!");
                } else if (state is SigningInState) {
                  debugPrint("SIGNING IN");
                } else if (state is UserNotFoundState) {
                  SnackBars(context: context).simple("Böyle bir e posta adresi kayıtlı değil veya silinmiş olabilir!");
                } else if (state is EmailAlreadyInUseState) {
                  SnackBars(context: context).simple(
                      "${UserBloc.user?.email ?? "email"} zaten kullanılıyor. \n\nSizin ise lütfen giriş yapın. \n\nSizin değil ise lütfen destek@peopler.app adresine durumu bildiren bir e-posta atın.");
                }
              },
              child: FloatingActionButton.extended(
                onPressed: () async {
                  await linkedinCompletionFABFuncion(
                    context,
                    _pageController,
                    currentPageValue,
                    selectedGender,
                    biographyController,
                    selecetCity,
                    _userBloc,
                  );
                },
                label: const Text("Tamamla"),
                icon: const Icon(Icons.done),
              ))
          : FloatingActionButton(
              onPressed: () async {
                await linkedinNextPageFABFunction(
                  context,
                  _pageController,
                  currentPageValue,
                  selectedGender,
                  biographyController,
                  selecetCity,
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
