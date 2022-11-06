import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

import '../others/strings.dart';
import 'fcm_and_local_notifications.dart';

const String taskFetchBackground = "fetchBackground";

class MyWorkManager {
  /// To call constructor operations only once, we use this variable to check if class instantiated already.
  /// When the class instantiated first-time, this variable set to true.
  static bool isClassInstantiated = false;

  /// This private named constructor is the only constructor of this class,
  /// so it's impossible to accidentally create an improperly initialized object out of the class
  /// because the only named constructor is private so cannot be called.
  MyWorkManager._create();

  /// Create a final instance of this class to make it singleton
  static final MyWorkManager _singleton = MyWorkManager._create();

  /// The only way to create an object is with this function, which performs proper async initialization
  static Future<MyWorkManager> create() async {
    /// If the class is not instantiated yet, then run this block and then never run again for any instantiation
    if (isClassInstantiated == false) {
      /// Do initialization that requires async
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

      isClassInstantiated = true;
    }

    /// Return the fully initialized object
    return _singleton;
  }

  static void fetchLocationBackground() async {
    if (Platform.isAndroid) {
      await Workmanager().registerPeriodicTask("1", taskFetchBackground,
          frequency: const Duration(minutes: 15),
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
          existingWorkPolicy: ExistingWorkPolicy.keep);
    }
  }
}

/// Top-level function
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case taskFetchBackground:
        await fetchBackgroundFunction();
        break;
      case Workmanager.iOSBackgroundTask:
        await fetchBackgroundFunction();
        break;
    }

    return Future.value(true);
  });
}

Future<bool> fetchBackgroundFunction() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  /// Firebase App Check
  if(Platform.isAndroid) {
    await FirebaseAppCheck.instance.activate(
        webRecaptchaSiteKey: 'recaptcha-v3-site-key',
        androidProvider: Strings.isDebug ? AndroidProvider.debug : AndroidProvider.playIntegrity
    );
  } else {
    await FirebaseAppCheck.instance.activate(
        webRecaptchaSiteKey: 'recaptcha-v3-site-key'
    );
  }


  FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;
  FCMAndLocalNotifications.initializeAwesomeNotifications();

  Position _position;

  /// CHECK LOCATION PERMISSION
  /// *********************************************************************************************************
  LocationPermission _permission = await Geolocator.checkPermission();
  if (!(_permission == LocationPermission.whileInUse || _permission == LocationPermission.always)) {
    /// For debug purposes
    debugPrint("WorkManager: not while in use nor always");
    // await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: not while in use nor always");
    return Future.value(false);
  }

  /// CHECK LOCATION SETTING
  /// *********************************************************************************************************
  bool locationStatus = await Geolocator.isLocationServiceEnabled();
  if (locationStatus == false) {
    /// For debug purposes
    debugPrint("WorkManager: location setting is closed");
    // await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: location setting is closed");
    return Future.value(false);
  }

  /// GET LOCATION
  /// *********************************************************************************************************
  _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);


  /// ALL BULK OF LOGIC
  /// *********************************************************************************************************
  await updateUserLocationAtDatabase(_position, _firebaseDB);

  /// *********************************************************************************************************

  /// For debug purposes
  debugPrint("Basarili ${_position.toString()}");
  // await FCMAndLocalNotifications.showNotificationForDebugPurposes("Basarili ${_position.toString()}");
  return Future.value(true);
}

Future<bool> updateUserLocationAtDatabase(Position position, FirebaseFirestore firebaseDB) async {
  try {
    /// Obtain shared preferences.
    const storage = FlutterSecureStorage();
    Map<String, String> allValues = await storage.readAll();

    final String? sharedUserID = allValues['sharedUserID'];
    int? oldLatitude = int.parse(allValues['sharedLatitude']!);
    int? oldLongitude = int.parse(allValues['sharedLongitude']!);

    int newLatitude = (position.latitude * 1e5).round();
    int newLongitude = (position.longitude * 1e5).round();

    /// If user's new location does not change more than UPDATE_WIDTH, then do not make any database operation.
    if (newLatitude > oldLatitude - Strings.UPDATE_WIDTH &&
        newLatitude < oldLatitude + Strings.UPDATE_WIDTH &&
        newLongitude > oldLongitude - Strings.UPDATE_WIDTH &&
        newLongitude < oldLongitude + Strings.UPDATE_WIDTH) {
      return Future.value(true);
    }

    /// Delete user from old region
    List<String> oldRegions = determineRegionList(oldLatitude, oldLongitude);
    for (String region in oldRegions) {
      await deleteUserFromRegion(sharedUserID!, region, firebaseDB);
    }

    /// Query region bottom left corner coordinates
    int bottomLatitude = newLatitude - newLatitude % Strings.REGION_WIDTH;
    int leftLongitude = newLongitude - newLongitude % Strings.REGION_WIDTH;

    String newRegion = bottomLatitude.toString() + ',' + leftLongitude.toString();

    await storage.write(key: 'sharedLatitude', value: newLatitude.toString());
    await storage.write(key: 'sharedLongitude', value: newLongitude.toString());

    await updateUserLocationAtDatabaseService(sharedUserID!, newLatitude, newLongitude, newRegion, firebaseDB);

    /// Update regions collection
    List<String> newRegions = determineRegionList(newLatitude, newLongitude);
    for (String region in newRegions) {
      await setUserInRegion(sharedUserID, region, firebaseDB);
    }

    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteUserFromRegion(String userID, String region, FirebaseFirestore firebaseDB) async {
  try {
    DocumentSnapshot _readRegion = await firebaseDB.collection('regions').doc(region).get();
    // if a region exists with this region on regions collections, then add userID to array field of users
    if (_readRegion.data() != null) {
      await firebaseDB.collection('regions').doc(region).update({
        "users": FieldValue.arrayRemove([userID])
      });
      return true;
    } else {
      debugPrint("WorkManager: ERROR: Document does not exist, a region with this regionID does not exist");
      // await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: ERROR: Document does not exist, a region with this regionID does not exist");
      return false;
    }
  } catch (e) {
    /// For debug purposes
    debugPrint("WorkManager: ERROR in deleteUserFromRegion function: $e");
    // await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: ERROR in deleteUserFromRegion function: $e");
    return Future.value(false);
  }
}

List<String> determineRegionList(int latitude, int longitude) {
  int _latitude = latitude;
  int _longitude = longitude;

  /// Query region bottom left corner coordinates
  int bottomLatitude = _latitude - _latitude % Strings.REGION_WIDTH;
  int leftLongitude = _longitude - _longitude % Strings.REGION_WIDTH;

  /// Create return variable queryList which keeps regions and subRegions
  List<String> queryList = [];

  String currentRegion = bottomLatitude.toString() + ',' + leftLongitude.toString();

  String bottomLeftRegion = (bottomLatitude - Strings.REGION_WIDTH).toString() + ',' + (leftLongitude - Strings.REGION_WIDTH).toString();
  String leftRegion = bottomLatitude.toString() + ',' + (leftLongitude - Strings.REGION_WIDTH).toString();
  String topLeftRegion = (bottomLatitude + Strings.REGION_WIDTH).toString() + ',' + (leftLongitude - Strings.REGION_WIDTH).toString();

  String topRegion = (bottomLatitude + Strings.REGION_WIDTH).toString() + ',' + leftLongitude.toString();
  String bottomRegion = (bottomLatitude - Strings.REGION_WIDTH).toString() + ',' + leftLongitude.toString();

  String bottomRightRegion = (bottomLatitude - Strings.REGION_WIDTH).toString() + ',' + (leftLongitude + Strings.REGION_WIDTH).toString();
  String rightRegion = bottomLatitude.toString() + ',' + (leftLongitude + Strings.REGION_WIDTH).toString();
  String topRightRegion = (bottomLatitude + Strings.REGION_WIDTH).toString() + ',' + (leftLongitude + Strings.REGION_WIDTH).toString();

  queryList.add(currentRegion);
  queryList.add(bottomLeftRegion);
  queryList.add(leftRegion);
  queryList.add(topLeftRegion);
  queryList.add(topRegion);
  queryList.add(bottomRegion);
  queryList.add(bottomRightRegion);
  queryList.add(rightRegion);
  queryList.add(topRightRegion);

  return queryList;
}

Future<bool> updateUserLocationAtDatabaseService(String userID, int latitude, int longitude, String region, FirebaseFirestore firebaseDB) async {
  DocumentSnapshot _readUser = await firebaseDB.collection('users').doc(userID).get();

  if (_readUser.data() != null) {
    await firebaseDB.collection('users').doc(userID).collection("private").doc("private").update({
      'latitude': latitude,
      'longitude': longitude,
    });
    return true;
  } else {
    /// For debug purposes
    debugPrint("WorkManager: ERROR: update user location");
    // await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: ERROR: update user location");
    return Future.value(false);
  }
}

Future<bool> setUserInRegion(String userID, String region, FirebaseFirestore firebaseDB) async {
  try {
    DocumentSnapshot _readRegion = await firebaseDB.collection('regions').doc(region).get();
    // if a region exists with this region on regions collections, then add userID to array field of users
    if (_readRegion.data() != null) {
      await firebaseDB.collection('regions').doc(region).update({
        "users": FieldValue.arrayUnion([userID])
      });
      return true;
    } else {
      await firebaseDB.collection('regions').doc(region).set({
        "users": FieldValue.arrayUnion([userID])
      });
      /// For debug purposes
      debugPrint("WorkManager: Document does not exist, so regionID created");
      // await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: Document does not exist, so regionID created");

      return true;
    }
  } catch (e) {
      /// For debug purposes
      debugPrint("WorkManager: ERROR in setUserInRegion function: $e");
      // await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: ERROR in setUserInRegion function: $e");
      return Future.value(false);
  }
}