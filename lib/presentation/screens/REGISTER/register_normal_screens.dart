import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_event.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_state.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/core/system_ui_service.dart';
import 'package:peopler/data/repository/connectivity_repository.dart';
import 'package:peopler/data/repository/location_repository.dart';
import 'package:peopler/others/classes/variables.dart';
import 'package:peopler/others/functions/image_picker_functions.dart';
import 'package:peopler/others/locator.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/city_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/email_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/gender_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/name_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/biography_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/FAB_functions/next_page_fab.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/password_screen.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/profile_photo.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../data/services/remote_config/remote_config.dart';

class RegisterScreens extends StatefulWidget {
  const RegisterScreens({Key? key}) : super(key: key);

  @override
  State<RegisterScreens> createState() => _RegisterScreensState();
}

class _RegisterScreensState extends State<RegisterScreens> {
  late final UserBloc _userBloc;

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
    _userBloc = BlocProvider.of<UserBloc>(context);
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

  bool _isDialogShowing = false;
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
          ? BlocListener<UserBloc, UserState>(
              bloc: _userBloc,
              listener: (context, UserState state) async {
                if (_isDialogShowing == true) {
                  Navigator.pop(context);
                  _isDialogShowing = false;
                }

                if (state is SignedInNotVerifiedState) {
                  _userBloc.add(waitFor15minutes(context: context));

                  /// Upload Profile Photo
                  if (UserBloc.user?.profileURL == "") {
                    _userBloc.add(uploadProfilePhotoEvent(imageFile: image));
                  }

                  Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.BEG_FOR_PERMISSION_SCREEN, (Route<dynamic> route) => false);
                } else if (state is SigningInState) {
                  _isDialogShowing = true;
                  Future.delayed(Duration.zero, () async {
                    PeoplerDialogs().loadingDialogFullScreen(
                      context: context,
                      loadingTexts: [
                        "Hesabınız Oluşturuluyor...",
                        "Peopler'a katılmana çok az kaldı",
                      ],
                    );
                  });
                } else if (state is InvalidEmailState) {
                  SnackBars(context: context).simple("E posta adresiniz istenilen biçimde değil!");
                } else if (state is UserNotFoundState) {
                  SnackBars(context: context).simple("Böyle bir e posta adresi kayıtlı değil veya silinmiş olabilir!");
                } else if (state is EmailAlreadyInUseState) {
                  SnackBars(context: context).simple(
                      "${emailController.text} zaten kullanılıyor. \n\nSizin ise lütfen giriş yapın. \n\nSizin değil ise lütfen destek@peopler.app adresine durumu bildiren bir e-posta atın.");
                } else if (state is WeakPasswordState) {
                  SnackBars(context: context).simple("${emailController.text} Şifre en az 6 karakterden oluşmalı.");
                }
              },
              child: FloatingActionButton.extended(
                onPressed: () async {
                  print(displayNameController.text);
                  print(selectedGender.value);
                  print(biographyController.text);
                  print(selecetCity.value);
                  print(emailController.text);
                  print(passwordController.text);

                  UserBloc.user?.gender = getGenderText(selectedGender.value);
                  UserBloc.user?.city = selecetCity.value!;
                  UserBloc.user?.displayName = displayNameController.text;
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
                  final ConnectivityRepository _connectivityRepository = locator<ConnectivityRepository>();
                  bool _connection = await _connectivityRepository.checkConnection(context);

                  if (_connection == false) return;

                  bool _isEduDotTr =
                      emailController.text.replaceAll(" ", "").toLowerCase().substring(emailController.text.length - 7) == ".edu.tr" ? true : false;

                  final FirebaseRemoteConfigService _remoteConfigService = locator<FirebaseRemoteConfigService>();
                  if (_remoteConfigService.isEduRemoteConfig()) {
                    _isEduDotTr = true;
                  }

                  if (passwordController.text == passwordController.text && _isEduDotTr == true) {
                    _userBloc.add(createUserWithEmailAndPasswordEvent(
                      email: emailController.text.replaceAll(" ", ""),
                      password: passwordController.text,
                    ));
                  } else if (passwordController.text != passwordController.text) {
                    SnackBars(context: context).simple("Girdiğiniz şifreler aynı değil!");
                  } else if (_isEduDotTr == false) {
                    SnackBars(context: context).simple("Sadece .edu.tr uzantılı üniversite mailin ile kayıt olabilirsin!");
                  } else {
                    SnackBars(context: context).simple("Hata kodu #852585. Lütfen bize bildirin destek@peopler.app !");
                  }
                },
                label: const Text("Tamamla"),
                icon: const Icon(Icons.done),
              ))
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
