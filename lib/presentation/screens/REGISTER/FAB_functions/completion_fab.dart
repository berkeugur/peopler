import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_event.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/others/classes/variables.dart';
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
              final ConnectivityRepository _connectivityRepository = locator<ConnectivityRepository>();
              bool _connection = await _connectivityRepository.checkConnection(context);

              if (_connection == false) return;
              bool _isEduDotTr = emailController.text.replaceAll(" ", "").toLowerCase().substring(emailController.text.length - 7) == ".edu.tr" ? true : false;

              final FirebaseRemoteConfigService _remoteConfigService = locator<FirebaseRemoteConfigService>();
              if(_remoteConfigService.isEduRemoteConfig()) {
                _isEduDotTr = true;
              }

              if (passwordController.text.length < 6) {
                _animateToPage(5).then((value) => SnackBars(context: context).simple("Şifreniz en az 6 karakterden oluşmalıdır."));
              } else if (_isEduDotTr == false) {
                _animateToPage(4).then((value) => SnackBars(context: context).simple("Sadece .edu.tr uzantılı üniversite mailin ile kayıt olabilirsin!"));
              } else if (_isEduDotTr == true && passwordController.text.length >= 6) {
                UserBloc.user = MyUser();
                UserBloc.user?.displayName = displayNameController.text;
                UserBloc.user?.gender = getGenderText(selectedGender.value!);
                UserBloc.user?.biography = biographyController.text;
                UserBloc.user?.city = selecetCity.value!;
                UserBloc.user?.email = emailController.text;

                printf(UserBloc.user?.displayName);
                printf(UserBloc.user?.gender);
                printf(UserBloc.user?.biography);
                printf(UserBloc.user?.city);
                printf(UserBloc.user?.email);
                printf(displayNameController.text);
                printf(getGenderText(selectedGender.value!));
                printf(biographyController.text);
                printf(selecetCity.value);
                printf(emailController.text);

                /// Upload Profile Photo
                if (image != null) {
                  _userBloc.add(uploadProfilePhoto(imageFile: image!));
                }
                if (_isEduDotTr == true) {
                  _userBloc.add(createUserWithEmailAndPasswordEvent(
                    email: emailController.text.replaceAll(" ", ""),
                    password: passwordController.text,
                  ));
                } else if (_isEduDotTr == false) {
                  SnackBars(context: context)
                      .simple("$_isEduDotTr ${emailController.text.replaceAll(" ", "").toLowerCase().substring(emailController.text.length - 7)}"
                          "Sadece .edu.tr uzantılı üniversite mailin ile kayıt olabilirsin!");
                } else {
                  SnackBars(context: context).simple("Hata kodu #852585. Lütfen bize bildirin destek@peopler.app !");
                }
                /*
                try {
                  //kayıt olma fonksiyonu auth exception catch çalışmalı veya farklı bir yol izlenmeli
                  // await FirebaseAuthService().createUserWithEmailAndPassword(emailController.text, passwordController.text);
                } on FirebaseAuthException catch (e) {
                  printf("on firebaseauthexeption catch");
                  if (e.code == 'weak-password') {
                    _animateToPage(5).then((value) => SnackBars(context: context).simple("Daha güçlü bir şifre girin."));

                    printf('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    _animateToPage(4).then((value) => SnackBars(context: context).simple("Bu e posta zaten kullanılıyor. Farklı bir e posta ile deneyin."));

                    printf('The account already exists for that email.');
                  } else if (e.code == 'operation-not-allowed') {
                    SnackBars(context: context).simple("impossiable but: Thrown if email/password accounts are not enabled.");
                    printf("Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.");
                  } else if (e.code == "invalid-email") {
                    _animateToPage(4).then((value) => SnackBars(context: context).simple("E-Posta adresi geçerli değil!"));

                    printf('Thrown if the email address is not valid.');
                  }
                } catch (e) {
                  printf(e);
                  SnackBars(context: context).simple(e.toString());
                }

                */
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
