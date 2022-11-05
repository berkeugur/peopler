class Strings {
  /// VERSION
  static const String peopler_version = "update_v1_1";

  /// LinkedIn Parameters (From LinkedIn Developer Page)
  static const String redirectUrlLinkedIn = 'https://us-central1-peopler-2376c.cloudfunctions.net/app/linkedin_callback';
  static const String clientIDLinkedIn = '86y9muk6ijz659';

  /// Firebase Functions URl for recreate LinkedIn custom token
  static const String recreateCustomTokenUrl = 'https://us-central1-peopler-2376c.cloudfunctions.net/app/linkedin_recreate_token';

  /// Firebase Parameters
  /// Firebase Server Key for Cloud Messaging (Firebase Console -> Project Settings -> Cloud Messaging)
  static const String firebaseServerKey =
      'AAAAolOeL4k:APA91bHz6zy5WVSLFoAbYZAMv1vPN92IECllzNxgpjP7sN3Tx1eCKG6HlzHxjdPmpsA1fMQWY96XuhLh9JBnn2KLTIfLNG8fSBv0GJaQKN43hsN3bpc2u9toPpnvPo3kh6yQmgMkI_kh';

  /// Default Firebase Storage File Paths
  static const String defaultMaleProfilePhotoUrl =
      "https://firebasestorage.googleapis.com/v0/b/peopler-2376c.appspot.com/o/default_images%2Fmale.jfif?alt=media&token=a5aebfa1-483f-48bb-aa46-fe7b6c08125c";
  static const String defaultFemaleProfilePhotoUrl =
      "https://firebasestorage.googleapis.com/v0/b/peopler-2376c.appspot.com/o/default_images%2Ffemale.jfif?alt=media&token=86f92d7a-9f3e-4add-a52f-f2b0e40a17d7";
  static const String defaultNonBinaryProfilePhotoUrl =
      "https://firebasestorage.googleapis.com/v0/b/peopler-2376c.appspot.com/o/default_images%2Fother.jfif?alt=media&token=db3e4f44-0147-4d05-8ef7-f33809ba211b";

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

  /// Kaydet duration
  static const int kaydetDurationHour = 6;

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
