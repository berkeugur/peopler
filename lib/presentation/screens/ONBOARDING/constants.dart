import 'package:flutter/material.dart';

class OnBoardingScreenStrings {
  static const List<String> title = [
    "PEOPLER'A HOŞGELDİN",
    "PEOPLER GİZLİLİĞİNİ ÖNEMSER",
    "DÜŞÜNCELERİNİ PAYLAŞ",
  ];

  static const List<String> description = [
    "Peopler sayesinde tığın insanlara kolayca bağlantı isteği gönderebilirsin.",
    "Peopler gizliliğini önemser. Kimseyle tam konumunu paylaşmaz. People uygulamasını kullanmayan kişiler seni göremez.",
    "Düşüncelerini ana sayfa üzerinden rahatlıkla kelimelere dök."
  ];

  static const List<String> localImagesSVG = [
    "assets/images/onboardingscreen/1.svg",
    "assets/images/onboardingscreen/2.svg",
    "assets/images/onboardingscreen/3.svg",
  ];
  static const List<String> localImagesPNG = [
    "assets/images/onboardingscreen/ob1.png",
    "assets/images/onboardingscreen/ob2.png",
    "assets/images/onboardingscreen/ob3.png",
  ];
  static List<Color> backgroundColor = [
    Colors.white,
    Colors.white,
    Colors.white,
  ];
}

class OnBoardingScreenData {
  final String _title;
  final String _description;
  final String _localImageSrc;
  final Color _backgroundColor;

  OnBoardingScreenData(this._title, this._description, this._localImageSrc, this._backgroundColor);

  String get title => _title;

  String get description => _description;

  String get localImageSrc => _localImageSrc;

  Color get backgroundColor => _backgroundColor;
}

class OnBoardingScreenDataList {
  static final List<OnBoardingScreenData> screen_list = [];
  static void prepareDataList() {
    for (int i = 0; i < 3; i++) {
      OnBoardingScreenData screen = OnBoardingScreenData(OnBoardingScreenStrings.title[i], OnBoardingScreenStrings.description[i],
          OnBoardingScreenStrings.localImagesPNG[i], OnBoardingScreenStrings.backgroundColor[i]);
      screen_list.add(screen);
    }
  }
}
