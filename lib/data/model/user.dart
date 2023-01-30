import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  /// Firebase Rules public fields
  String userID = "";
  String? pplName;
  String displayName = "";
  String gender = "";
  String city = "";
  int city_arr = 0;
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
  bool newNotification = false;
  bool newMessage = false;
  DateTime? lastNotificationCreatedAt;
  DateTime? lastMessageCreatedAt;

  /// Firebase Rules private fields
  String email = "";
  bool isTheAccountConfirmed = false;
  bool missingInfo = true;
  int latitude = 0;
  int longitude = 0;
  int numOfSendRequest = 15;
  DateTime? updatedAtNumOfSendRequest;
  List<String> feedIDs = [];

  MyUser();

  Map<String, dynamic> toPublicMap() {
    return {
      'userID': userID,
      'pplName': pplName ?? "ppl" + randomNumberGenerator(),
      'displayName': displayName,
      'gender': gender,
      'city': city,
      'city_arr': city_arr,
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
      'newNotification': newNotification,
      'newMessage': newMessage,
      'lastNotificationCreatedAt': lastNotificationCreatedAt ?? DateTime.now(),
      'lastMessageCreatedAt': lastMessageCreatedAt ?? DateTime.now(),
    };
  }

  void fromPublicMap(Map<String, dynamic> map) {
    userID = map['userID'] as String;
    pplName = map['pplName'] as String;
    displayName = map['displayName'] as String;
    gender = map['gender'] as String;
    city = map['city'] as String;
    city_arr = map['city_arr'] as int;
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
    newNotification = map['newNotification'] as bool;
    newMessage = map['newMessage'] as bool;
    lastNotificationCreatedAt = map['lastNotificationCreatedAt'].runtimeType == DateTime
        ? map['lastNotificationCreatedAt']
        : map['lastNotificationCreatedAt'].runtimeType == Timestamp
            ? (map['lastNotificationCreatedAt'] as Timestamp).toDate()
            : map['lastNotificationCreatedAt'].toDate();
    lastMessageCreatedAt = map['lastMessageCreatedAt'].runtimeType == DateTime
        ? map['lastMessageCreatedAt']
        : map['lastMessageCreatedAt'].runtimeType == Timestamp
            ? (map['lastMessageCreatedAt'] as Timestamp).toDate()
            : map['lastMessageCreatedAt'].toDate();
  }

  Map<String, dynamic> toPrivateMap() {
    return {
      'userID': userID,
      'email': email,
      'isTheAccountConfirmed': isTheAccountConfirmed,
      'missingInfo': missingInfo,
      'latitude': latitude,
      'longitude': longitude,
      'numOfSendRequest': numOfSendRequest,
      'updatedAtNumOfSendRequest': updatedAtNumOfSendRequest ?? DateTime.now(),
      'feedIDs': feedIDs,
    };
  }

  void fromPrivateMap(Map<String, dynamic> map) {
    email = map['email'] as String;
    isTheAccountConfirmed = map['isTheAccountConfirmed'] as bool;
    missingInfo = map['missingInfo'] as bool;
    latitude = map['latitude'] as int;
    longitude = map['longitude'] as int;
    numOfSendRequest = map['numOfSendRequest'] as int;
    updatedAtNumOfSendRequest = map['updatedAtNumOfSendRequest'].runtimeType == DateTime
        ? map['updatedAtNumOfSendRequest']
        : map['updatedAtNumOfSendRequest'].runtimeType == Timestamp
            ? (map['updatedAtNumOfSendRequest'] as Timestamp).toDate()
            : map['updatedAtNumOfSendRequest'].toDate();
    feedIDs = map['feedIDs'].map<String>((data) => data.toString()).toList();
  }

  String randomNumberGenerator() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
