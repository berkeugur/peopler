import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_event.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_state.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/core/system_ui_service.dart';
import 'package:peopler/others/locator.dart';
import 'package:peopler/presentation/screens/CONNECTIONS/connections_service.dart';
import 'package:peopler/presentation/screens/REGISTER/Linkedin_FAB_functions/linkedin_completion_fab.dart';
import 'package:peopler/presentation/screens/REGISTER/Linkedin_FAB_functions/linkedin_next_page_fab.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/city_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/gender_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/biography_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/profile_photo.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../data/repository/location_repository.dart';
import '../../../others/functions/image_picker_functions.dart';

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
          ? FloatingActionButton.extended(
              onPressed: () async {
                UserBloc.user?.gender = getGenderText(selectedGender.value);
                UserBloc.user?.city = selecetCity.value!;

                UserBloc.user?.biography = biographyController.text;
                if (UserBloc.user?.city != "" && biographyController.text.isNotEmpty) {
                  UserBloc.user?.biography = biographyController.text;

                  if (_userBloc.state == SignedInMissingInfoState()) {
                    UserBloc.user?.missingInfo = false;

                    /// Upload profile photo if user has chosen, or default photo
                    await _userBloc.uploadProfilePhoto(image);

                    _userBloc.add(updateUserInfoForLinkedInEvent());

                    final LocationRepository _locationRepository = locator<LocationRepository>();
                    LocationPermission _permission = await _locationRepository.checkPermissions().onError((error, stackTrace) => printf(error));
                    if (_permission == LocationPermission.always) {
                      /// Set theme mode before Home Screen
                      SystemUIService().setSystemUIforThemeMode();

                      Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.BEG_FOR_PERMISSION_SCREEN, (Route<dynamic> route) => false);
                    }
                  } else {
                    Navigator.pushNamed(context, NavigationConstants.EMAIL_AND_PASSWORD_SCREEN);
                  }
                } else if (UserBloc.user?.city == "" && biographyController.text.isEmpty) {
                  SnackBars(context: context).simple("Boşlukları Doldurunuz");
                } else if (UserBloc.user?.city == "" && biographyController.text.isNotEmpty) {
                  SnackBars(context: context).simple("Şehir seçmeniz gerekiyor.");
                } else if (UserBloc.user?.city != "" && biographyController.text.isEmpty) {
                  SnackBars(context: context).simple("Biyografi alanını doldurunuz!");
                }
              },
              label: const Text("Tamamla"),
              icon: const Icon(Icons.done),
            )
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
