import 'package:flutter/material.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/presentation/screens/CONNECTIONS/connections_service.dart';
import '../../../../core/constants/enums/register_screens_enum.dart';

Future<void> linkedinNextPageFABFunction(
  BuildContext context,
  PageController _pageController,
  ValueNotifier<int> currentPageValue,
  ValueNotifier<GenderTypes?> selectedGender,
  TextEditingController biographyController,
  ValueNotifier<String?> selecetCity,
) async {
  Future<void> _nextPage() async {
    FocusScope.of(context).unfocus();
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  LinkedinRegisterScreenNames names = LinkedinRegisterScreenNames.values.elementAt(currentPageValue.value);
  switch (names) {
    case LinkedinRegisterScreenNames.gender:
      printf(LinkedinRegisterScreenNames.gender.toString());
      await _nextPage();
      if (biographyController.text.isNotEmpty) {
        await _nextPage();
      } else {
        //boş yukarıda neden boş olduğunu açıkladım
        break;
      }
      if (selecetCity.value != null) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("Şehir seçmelisin");

        break;
      }

      break;
    case LinkedinRegisterScreenNames.biography:
      printf(LinkedinRegisterScreenNames.biography.toString());
      await _nextPage();
      if (selecetCity.value != null) {
        await _nextPage();
      } else {
        //boş yukarıda neden boş olduğunu açıkladım

        break;
      }

      break;
    case LinkedinRegisterScreenNames.city:
      printf(LinkedinRegisterScreenNames.city.toString());
      await _nextPage();

      break;

    case LinkedinRegisterScreenNames.profilephoto:
      printf("impossiable");
      break;
  }
}
