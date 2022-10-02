import 'package:flutter/material.dart';

class TutorialScreenStrings {
  static const List<String> title = [
    "PEOPLER'A HOŞGELDİN",
    "PEOPLER GİZLİLİĞİNİ ÖNEMSER",
    "DÜŞÜNCELERİNİ PAYLAŞ",
  ];

  static const List<String> description = [
    "Peopler içerisinde, aynı ortamı paylaştığın insanlara kolayca baglantı istekleri göndebilirsin. \n\nBöylece aynı kafe veya ortam içerisinde bulunduğun insanlara rahatsızlık vermeden onlarla baglantı kurabilirsin. ",
    "Sen izin vermeden aynı ortamı paylaştığın insanlara fotoğraflarını ve ismini göstermez. \n\nPeopler ile hayat, insanlarlar, deneyimler, kitaplar, yemekler hakkında hep daha fazlasını keşfet. ",
    "Yakınında birileri yoksa düşüncelerini paylaşarak yeni insanların senle bağlantıya geçmesini sağlamak da fena fikir sayılmaz. :) \n\nFeed ekranı üzerinden düşüncelerini paylaşan diğer Peopler kullanıcılarını görüntüleyip direkt bağlantı isteği yollaman mümkün!"
  ];

  static const List<String> localImageSrc = [
    "assets/images/onboardingscreen/1.svg",
    "assets/images/onboardingscreen/2.svg",
    "assets/images/onboardingscreen/3.svg",
  ];

  static List<Color> backgroundColor = [
    Colors.white,
    Colors.white,
    Colors.white,
  ];
}

class TutorialScreenData {
  final String _title;
  final String _description;
  final String _localImageSrc;
  final Color _backgroundColor;

  TutorialScreenData(this._title, this._description, this._localImageSrc, this._backgroundColor);

  String get title => _title;

  String get description => _description;

  String get localImageSrc => _localImageSrc;

  Color get backgroundColor => _backgroundColor;
}

class TutorialDataList {
  static final List<TutorialScreenData> screen_list = [];
  static void prepareDataList() {
    for (int i = 0; i < 3; i++) {
      TutorialScreenData screen = TutorialScreenData(
          TutorialScreenStrings.title[i],
          TutorialScreenStrings.description[i],
          TutorialScreenStrings.localImageSrc[i],
          TutorialScreenStrings.backgroundColor[i]);
      screen_list.add(screen);
    }
  }
}
