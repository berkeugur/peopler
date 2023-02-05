import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_event.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_state.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/core/system_ui_service.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/data/repository/location_repository.dart';
import 'package:peopler/others/functions/image_picker_functions.dart';
import 'package:peopler/others/locator.dart';
import 'package:peopler/presentation/screens/CONNECTIONS/connections_service.dart';
import 'package:peopler/presentation/screens/REGISTER/Screens/gender_screen.dart';

import '../../../../data/repository/connectivity_repository.dart';
import '../../../../data/services/remote_config/remote_config.dart';

Future<void> completionFABFuncion(
  BuildContext context,
  PageController _pageController,
  ValueNotifier<int> currentPageValue,
  ValueNotifier<GenderTypes?> selectedGender,
  TextEditingController biographyController,
  ValueNotifier<String?> selecetCity,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController displayNameController,
  UserBloc _userBloc,
) async {
  Future<void> _animateToPage(int page) async {
    FocusScope.of(context).unfocus();
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  if (displayNameController.text.isEmpty) {
    await _animateToPage(0).then((value) => SnackBars(context: context).simple("İsim soyisim kısmını doldurmanız gereklidir."));
  } else if (displayNameController.text.isNotEmpty && displayNameController.text.length < 5) {
    await _animateToPage(0).then((value) => {SnackBars(context: context).simple("İsim soayisminiz 5 karakterden az olamaz")});
  } else {
    if (selectedGender.value == null) {
      await _animateToPage(1).then((value) => {SnackBars(context: context).simple("Cinsiyetiniz Nedir?")});
    } else {
      if (biographyController.text.isEmpty) {
        await _animateToPage(2).then((value) => SnackBars(context: context).simple("İsim soyisim kısmını doldurmanız gereklidir."));
      } else {
        if (selecetCity.value == null) {
          await _animateToPage(3).then((value) => SnackBars(context: context).simple("Şehir kısmını doldurmanız gereklidir."));
        } else {
          if (image != null) {
            if (emailController.text.isEmpty) {
              await _animateToPage(4).then((value) => SnackBars(context: context).simple("E-posta adresinizi girmelisiniz."));
            } else if (emailController.text.length <= 7) {
              _animateToPage(4).then((value) => SnackBars(context: context).simple("E-posta adresi 7 karakterden az olamaz"));
            } else {
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
            }
            //email password  kontrolleri burada firebase e göre yapılacak

            //SnackBars(context: context).simple("Devam");
          } else {
            SnackBars(context: context).simple("Profil Fotoğrafı Eklemelisiniz.");
          }
        }
      }
    }
  }
}
