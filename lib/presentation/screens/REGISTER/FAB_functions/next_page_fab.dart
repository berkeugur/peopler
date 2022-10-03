import 'package:flutter/material.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/enums/gender_types_enum.dart';
import 'package:peopler/presentation/screens/CONNECTIONS/connections_service.dart';

import '../../../../core/constants/enums/register_screens_enum.dart';

Future<void> nextPageFABFunction(
  BuildContext context,
  PageController _pageController,
  ValueNotifier<int> currentPageValue,
  ValueNotifier<GenderTypes?> selectedGender,
  TextEditingController biographyController,
  ValueNotifier<String?> selecetCity,
  TextEditingController emailController,
  TextEditingController passwordController,
) async {
  Future<void> _nextPage() async {
    FocusScope.of(context).unfocus();
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  RegisterScreenNames names = RegisterScreenNames.values.elementAt(currentPageValue.value);
  switch (names) {
    case RegisterScreenNames.displayname:
      printf("display name $names ${currentPageValue.value}");
      await _nextPage();
      if (selectedGender.value != null) {
        await _nextPage();
      } else {
        //buraya uyarı koymuyoruz çünkü normal bir şekilde kayıt olurken uyarı göstermesini istemiyoruz sadece
        //bu bölüm için displayname boş ve gender seçilmiş durumda iken başa dönüldüğünde
        // ve display name doldurulduktan sonra ileri butonuna tıklandığında burası dolu ise ve break olmadığı durumda
        //uyarı mesajlarını gösteriyoruz. uyarı mesajları gösterildikten sonra break olduğu için 1 kez gösteriliyor.
        break;
      }
      if (biographyController.text.isNotEmpty) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("Kendinden bahset alanını doldurmalısın.");
        break;
      }
      if (selecetCity.value != null) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("Şehir seçmelisin");

        break;
      }
      if (emailController.text.isNotEmpty) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("E posta belirlemesin");
        break;
      }
      if (passwordController.text.isNotEmpty) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("Şifre belirleyin");

        break;
      }
      break;
    case RegisterScreenNames.gender:
      printf(RegisterScreenNames.gender.toString());
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
      if (emailController.text.isNotEmpty) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("E posta belirlemesin");

        break;
      }
      if (passwordController.text.isNotEmpty) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("Şifre belirleyin");

        break;
      }
      break;
    case RegisterScreenNames.biography:
      printf(RegisterScreenNames.biography.toString());
      await _nextPage();
      if (selecetCity.value != null) {
        await _nextPage();
      } else {
        //boş yukarıda neden boş olduğunu açıkladım

        break;
      }
      if (emailController.text.isNotEmpty) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("E posta belirlemesin");

        break;
      }
      if (passwordController.text.isNotEmpty) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("Şifre belirleyin");

        break;
      }
      break;
    case RegisterScreenNames.city:
      printf(RegisterScreenNames.city.toString());
      await _nextPage();
      if (emailController.text.isNotEmpty) {
        await _nextPage();
      } else {
        //boş yukarıda neden boş olduğunu açıkladım

        break;
      }
      if (passwordController.text.isNotEmpty) {
        await _nextPage();
      } else {
        SnackBars(context: context).simple("Şifre belirleyin");

        break;
      }
      break;
    case RegisterScreenNames.email:
      printf(RegisterScreenNames.email.toString());
      await _nextPage();
      if (passwordController.text.isNotEmpty) {
        await _nextPage();
      } else {
        break;
      }
      break;
    case RegisterScreenNames.password:
      printf(RegisterScreenNames.password.toString());
      await _nextPage();
      break;
    case RegisterScreenNames.profilephoto:
      printf("impossiable");
      break;
  }
}
