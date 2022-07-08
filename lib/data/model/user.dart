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
  List<String> hobbies = [];
  List<String> photosURL = [];
  List<String> connectionUserIDs = [];

  /// Firebase Rules private fields
  String email = "";
  bool isTheAccountConfirmed = false;
  bool missingInfo = true;
  String region = 'empty';
  int latitude = 0;
  int longitude = 0;
  List<String> savedUserIDs = [];
  List<String> transmittedRequestUserIDs = [];
  List<String> receivedRequestUserIDs = [];

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
    };
  }

  MyUser.fromPublicMap(Map<String, dynamic> map)
      : userID = map['userID'],
        pplName = map['pplName'],
        displayName = map['displayName'],
        gender = map['gender'],
        city = map['city'],
        biography = map['biography'],
        schoolName = map['schoolName'],
        currentJobName = map['currentJobName'],
        company = map['company'],
        isProfileVisible = map['isProfileVisible'],
        profileURL = map['profileURL'],
        createdAt = map['createdAt'].toDate(),
        updatedAt = map['updatedAt'].toDate(),
        hobbies = map['hobbies'].map<String>((data) => data.toString()).toList(),
        photosURL = map['photosURL'].map<String>((data) => data.toString()).toList(),
        connectionUserIDs = map['connectionUserIDs']
            .map<String>((data) => data.toString())
            .toList();

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
      'transmittedRequestUserIDs': transmittedRequestUserIDs,
      'receivedRequestUserIDs': receivedRequestUserIDs,
    };
  }

  MyUser.fromPrivateMap(Map<String, dynamic> map, MyUser myPublicUser)
      : userID = myPublicUser.userID,
        pplName = myPublicUser.pplName,
        displayName = myPublicUser.displayName,
        gender = myPublicUser.gender,
        city = myPublicUser.city,
        biography = myPublicUser.biography,
        schoolName = myPublicUser.schoolName,
        currentJobName = myPublicUser.currentJobName,
        company = myPublicUser.company,
        isProfileVisible = myPublicUser.isProfileVisible,
        profileURL = myPublicUser.profileURL,
        createdAt = myPublicUser.createdAt,
        updatedAt = myPublicUser.updatedAt,
        hobbies = myPublicUser.hobbies,
        photosURL = myPublicUser.photosURL,
        connectionUserIDs = myPublicUser.connectionUserIDs,

        email = map['email'],
        isTheAccountConfirmed = map['isTheAccountConfirmed'],
        missingInfo = map['missingInfo'],
        region = map['region'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        savedUserIDs = map['savedUserIDs'].map<String>((data) => data.toString()).toList(),
        transmittedRequestUserIDs = map['transmittedRequestUserIDs']
            .map<String>((data) => data.toString())
            .toList(),
        receivedRequestUserIDs = map['receivedRequestUserIDs']
            .map<String>((data) => data.toString())
            .toList();

  String randomNumberGenerator() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
