import 'dart:math';

class MyUser {
  /// Firebase Rules public fields
  String userID = "";
  String? pplName;
  String displayName = "";
  String gender = "";
  String city = "";
  String biography = "";
  String schoolName = "";
  String currentJobName = "";
  String company = "";
  bool isProfileVisible = true;
  String profileURL = "";
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic> hobbies = [];
  List<String> photosURL = [];
  List<String> connectionUserIDs = [];
  List<String> receivedRequestUserIDs = [];
  List<String> transmittedRequestUserIDs = [];

  /// Firebase Rules private fields
  String email = "";
  bool isTheAccountConfirmed = false;
  bool missingInfo = true;
  String region = 'empty';
  int latitude = 0;
  int longitude = 0;
  List<String> savedUserIDs = [];
  int numOfSendRequest = 15;

  MyUser();

  Map<String, dynamic> toPublicMap() {
    return {
      'userID': userID,
      'pplName': pplName ?? "ppl" + randomNumberGenerator(),
      'displayName': displayName,
      'gender': gender,
      'city': city,
      'biography': biography,
      'schoolName': schoolName,
      'currentJobName': currentJobName,
      'company': company,
      'isProfileVisible': isProfileVisible,
      'profileURL': profileURL,
      'createdAt': createdAt ?? DateTime.now(),
      'updatedAt': updatedAt ?? DateTime.now(),
      'hobbies': hobbies,
      'photosURL': photosURL,
      'connectionUserIDs': connectionUserIDs,
      'receivedRequestUserIDs': receivedRequestUserIDs,
      'transmittedRequestUserIDs': transmittedRequestUserIDs,
    };
  }

  void updateFromPublicMap(Map<String, dynamic> map) {
    userID = map['userID'] as String;
    pplName = map['pplName'] as String;
    displayName = map['displayName'] as String;
    gender = map['gender'] as String;
    city = map['city'] as String;
    biography = map['biography'] as String;
    schoolName = map['schoolName'] as String;
    currentJobName = map['currentJobName'] as String;
    company = map['company'] as String;
    isProfileVisible = map['isProfileVisible'];
    profileURL = map['profileURL'];
    createdAt = map['createdAt'].runtimeType == DateTime ? map['createdAt'] : map['createdAt'].toDate();
    updatedAt = map['updatedAt'].runtimeType == DateTime ? map['updatedAt'] : map['updatedAt'].toDate();
    hobbies = map['hobbies'];
    photosURL = map['photosURL'].map<String>((data) => data.toString()).toList();
    connectionUserIDs = map['connectionUserIDs'].map<String>((data) => data.toString()).toList();
    receivedRequestUserIDs = map['receivedRequestUserIDs'].map<String>((data) => data.toString()).toList();
    transmittedRequestUserIDs = map['transmittedRequestUserIDs'].map<String>((data) => data.toString()).toList();
  }

  Map<String, dynamic> toPrivateMap() {
    return {
      'userID': userID,
      'email': email,
      'isTheAccountConfirmed': isTheAccountConfirmed,
      'missingInfo': missingInfo,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
      'savedUserIDs': savedUserIDs,
      'numOfSendRequest': numOfSendRequest,
    };
  }

  void updateFromPrivateMap(Map<String, dynamic> map) {
    email = map['email'] as String;
    isTheAccountConfirmed = map['isTheAccountConfirmed'] as bool;
    missingInfo = map['missingInfo'] as bool;
    region = map['region'] as String;
    latitude = map['latitude'] as int;
    longitude = map['longitude'] as int;
    savedUserIDs = map['savedUserIDs'].map<String>((data) => data.toString()).toList() as List<String>;
    numOfSendRequest = map['numOfSendRequest'] as int;
  }

  String randomNumberGenerator() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
