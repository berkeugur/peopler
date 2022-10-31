import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<String> savedUserIDs = [];
  List<String> connectionUserIDs = [];
  List<String> receivedRequestUserIDs = [];
  List<String> transmittedRequestUserIDs = [];
  List<String> blockedUsers = [];
  List<String> whoBlockedYou = [];

  /// Firebase Rules private fields
  String email = "";
  bool isTheAccountConfirmed = false;
  bool missingInfo = true;
  String region = 'empty';
  int latitude = 0;
  int longitude = 0;
  int numOfSendRequest = 15;
  DateTime? updatedAtNumOfSendRequest;

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
      'savedUserIDs': savedUserIDs,
      'connectionUserIDs': connectionUserIDs,
      'receivedRequestUserIDs': receivedRequestUserIDs,
      'transmittedRequestUserIDs': transmittedRequestUserIDs,
      'blockedUsers': blockedUsers,
      'whoBlockedYou': whoBlockedYou,
    };
  }

  void fromPublicMap(Map<String, dynamic> map) {
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
    createdAt = map['createdAt'].runtimeType == DateTime
        ? map['createdAt']
        : map['createdAt'].runtimeType == Timestamp
            ? (map['createdAt'] as Timestamp).toDate()
            : map['createdAt'].toDate();
    updatedAt = map['updatedAt'].runtimeType == DateTime
        ? map['updatedAt']
        : map['updatedAt'].runtimeType == Timestamp
            ? (map['updatedAt'] as Timestamp).toDate()
            : map['updatedAt'].toDate();
    hobbies = map['hobbies'];
    photosURL = map['photosURL'].map<String>((data) => data.toString()).toList();
    savedUserIDs = map['savedUserIDs'].map<String>((data) => data.toString()).toList();
    connectionUserIDs = map['connectionUserIDs'].map<String>((data) => data.toString()).toList();
    receivedRequestUserIDs = map['receivedRequestUserIDs'].map<String>((data) => data.toString()).toList();
    transmittedRequestUserIDs = map['transmittedRequestUserIDs'].map<String>((data) => data.toString()).toList();
    blockedUsers = map['blockedUsers'].map<String>((data) => data.toString()).toList();
    whoBlockedYou = map['whoBlockedYou'].map<String>((data) => data.toString()).toList();
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
      'numOfSendRequest': numOfSendRequest,
      'updatedAtNumOfSendRequest': updatedAtNumOfSendRequest ?? DateTime.now(),
    };
  }

  void fromPrivateMap(Map<String, dynamic> map) {
    print(map['updatedAtNumOfSendRequest'].runtimeType);
    email = map['email'] as String;
    isTheAccountConfirmed = map['isTheAccountConfirmed'] as bool;
    missingInfo = map['missingInfo'] as bool;
    region = map['region'] as String;
    latitude = map['latitude'] as int;
    longitude = map['longitude'] as int;
    numOfSendRequest = map['numOfSendRequest'] as int;
    updatedAtNumOfSendRequest = map['updatedAtNumOfSendRequest'].runtimeType == DateTime
        ? map['updatedAtNumOfSendRequest']
        : map['updatedAtNumOfSendRequest'].runtimeType == Timestamp
            ? (map['updatedAtNumOfSendRequest'] as Timestamp).toDate()
            : map['updatedAtNumOfSendRequest'].toDate();
  }

  String randomNumberGenerator() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
