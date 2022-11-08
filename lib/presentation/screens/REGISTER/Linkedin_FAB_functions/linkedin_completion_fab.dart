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

Future<void> linkedinCompletionFABFuncion(
  BuildContext context,
  PageController _pageController,
  ValueNotifier<int> currentPageValue,
  ValueNotifier<GenderTypes?> selectedGender,
  TextEditingController biographyController,
  ValueNotifier<String?> selecetCity,
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

  if (selectedGender.value == null) {
    await _animateToPage(0).then((value) => {SnackBars(context: context).simple("Cinsiyetiniz Nedir?")});
  } else {
    if (biographyController.text.isEmpty) {
      await _animateToPage(1).then((value) => SnackBars(context: context).simple("Kendinizi tanıtan birkaç kelime ekleyin."));
    } else {
      if (selecetCity.value == null) {
        await _animateToPage(2).then((value) => SnackBars(context: context).simple("Şehir kısmını doldurmanız gereklidir."));
      } else {
        if (image != null) {
          final ConnectivityRepository _connectivityRepository = locator<ConnectivityRepository>();
          bool _connection = await _connectivityRepository.checkConnection(context);

          if (_connection == false) return;

          UserBloc.user = MyUser();

          UserBloc.user?.gender = getGenderText(selectedGender.value!);
          UserBloc.user?.biography = biographyController.text;
          UserBloc.user?.city = selecetCity.value!;

          printf(UserBloc.user?.displayName);
          printf(UserBloc.user?.gender);
          printf(UserBloc.user?.biography);
          printf(UserBloc.user?.city);
          printf(UserBloc.user?.email);
          printf(getGenderText(selectedGender.value!));
          printf(biographyController.text);
          printf(selecetCity.value);

          /// Upload Profile Photo
          if (image != null) {
            _userBloc.add(uploadProfilePhoto(imageFile: image!));
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
