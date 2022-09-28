class Strings {
  /// VERSION
  static const String version = "update_v1_0";

  /// LinkedIn Parameters (From LinkedIn Developer Page)
  static const String redirectUrl = 'https://us-central1-peopler-2376c.cloudfunctions.net/app/linkedin_callback';
  static const String clientId = '86y9muk6ijz659';

  /// Firebase Parameters
  // Firebase Server Key for Cloud Messaging (Firebase Console -> Project Settings -> Cloud Messaging)
  static const String firebaseServerKey =
      'AAAAolOeL4k:APA91bHz6zy5WVSLFoAbYZAMv1vPN92IECllzNxgpjP7sN3Tx1eCKG6HlzHxjdPmpsA1fMQWY96XuhLh9JBnn2KLTIfLNG8fSBv0GJaQKN43hsN3bpc2u9toPpnvPo3kh6yQmgMkI_kh';

  /// Default Firebase Storage File Paths
  static const String defaultProfilePhotoUrl = "";

  /// Push Notification Payload Types
  static const String sendRequest = "send_request";
  static const String receiveRequest = "receive_request";
  static const String permissionSettings = "permission_settings";
  static const String requestPermission = "request_permission";
  static const String googleDialog = "google_dialog";
  static const String message = "my_message";

  /// Awesome Notification Channel Keys
  static const String keyDebug = "key_debug";
  static const String keyPermission = "key_permission";
  static const String keyMain = "key_main";

  /// Activity Types
  static const String activityShared = "shared";
  static const String activityLiked = "liked";
  static const String activityDisliked = "disliked";

  static const List<String> cityData = [
    "İstanbul",
    "Ankara",
    "İzmir",
    "Adana",
    "Adıyaman",
    "Afyonkarahisar",
    "Ağrı",
    "Amasya",
    "Antalya",
    "Artvin",
    "Aydın",
    "Balıkesir",
    "Bilecik",
    "Bingöl",
    "Bitlis",
    "Bolu",
    "Burdur",
    "Bursa",
    "Çanakkale",
    "Çankırı",
    "Çorum",
    "Denizli",
    "Diyarbakır",
    "Edirne",
    "Elazığ",
    "Erzincan",
    "Erzurum",
    "Eskişehir",
    "Gaziantep",
    "Giresun",
    "Gümüşhane",
    "Hakkari",
    "Hatay",
    "Isparta",
    "Mersin",
    "Kars",
    "Kastamonu",
    "Kayseri",
    "Kırklareli",
    "Kırşehir",
    "Kocaeli",
    "Konya",
    "Kütahya",
    "Malatya",
    "Manisa",
    "Kahramanmaraş",
    "Mardin",
    "Muğla",
    "Muş",
    "Nevşehir",
    "Niğde",
    "Ordu",
    "Rize",
    "Sakarya",
    "Samsun",
    "Siirt",
    "Sinop",
    "Sivas",
    "Tekirdağ",
    "Tokat",
    "Trabzon",
    "Tunceli",
    "Şanlıurfa",
    "Uşak",
    "Van",
    "Yozgat",
    "Zonguldak",
    "Aksaray",
    "Bayburt",
    "Karaman",
    "Kırıkkale",
    "Batman",
    "Şırnak",
    "Bartın",
    "Ardahan",
    "Iğdır",
    "Yalova",
    "Karabük",
    "Kilis",
    "Osmaniye",
    "Düzce"
  ];
}

ProjectText txt = ProjectText();

class ProjectText {
  String get peoplerTXT {
    return "peoplssssssssssser";
  }

  String get backArrowSvgTXT {
    return "assets/images/svg_icons/back_arrow.svg";
  }
}
