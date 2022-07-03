import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';

import 'fcm_and_local_notifications.dart';

const String taskFetchBackground =  "fetchBackground";

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
    if(isClassInstantiated == false) {
      /// Do initialization that requires async
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

      isClassInstantiated = true;
    }

    /// Return the fully initialized object
    return _singleton;
  }

  static void fetchLocationBackground() async {
    await Workmanager().registerPeriodicTask("1", taskFetchBackground,
        frequency: const Duration(minutes: 15),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        existingWorkPolicy: ExistingWorkPolicy.keep);
  }
}

/// Top-level function
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case taskFetchBackground:
        return await fetchBackgroundFunction();
      default:
        return Future.value(true);
    }
  });
}

Future<bool> fetchBackgroundFunction() async {
  if(Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
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
    await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: not while in use nor always");
    return Future.value(false);
  }

  /// CHECK LOCATION SETTING
  /// *********************************************************************************************************
  bool locationStatus = await Geolocator.isLocationServiceEnabled();
  if (locationStatus == false) {
    /// For debug purposes
    debugPrint("WorkManager: location setting is closed");
    await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: location setting is closed");
    return Future.value(false);
  }

  /// GET LOCATION
  /// *********************************************************************************************************
  _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

  const int UPDATE_WIDTH = 20; // 20 meters
  const int QUERY_WIDTH = 100; // 100 meters

  /// GET SECURE STORAGE VALUES
  /// *********************************************************************************************************
  const storage = FlutterSecureStorage();
  Map<String, String> allValues = await storage.readAll();

  final String? sharedUserID = allValues['sharedUserID'];
  String? sharedRegion = allValues['sharedRegion'];
  int? sharedLatitude = int.parse(allValues['sharedLatitude']!);
  int? sharedLongitude = int.parse(allValues['sharedLongitude']!);

  /// CHECK LOCATION CHANGE
  /// *********************************************************************************************************
  int latitude = (_position.latitude * 1e5).round();
  int longitude = (_position.longitude * 1e5).round();

  /// If user's new location does not change more than UPDATE_WIDTH, then do not make any database operation.
  if (latitude > sharedLatitude - UPDATE_WIDTH &&
      latitude < sharedLatitude + UPDATE_WIDTH &&
      longitude > sharedLongitude - UPDATE_WIDTH &&
      longitude < sharedLongitude + UPDATE_WIDTH) {
    return Future.value(true);
  }

  /// DELETE USER FROM regions COLLECTIONS IF EXISTS (old region)
  /// *********************************************************************************************************
  try {
    DocumentSnapshot _readRegion = await _firebaseDB.collection('regions').doc(sharedRegion).get();

    /// if a region exists with this region on regions collections, then delete userID from array field of users document of regions collections
    if (_readRegion.data() != null) {
      await _firebaseDB.collection('regions').doc(sharedRegion).update({
        "users": FieldValue.arrayRemove([sharedUserID])
      });
    } else {
      /// For debug purposes
      debugPrint("WorkManager: ERROR: Document does not exist, a region with this regionID does not exist");
      await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: ERROR: Document does not exist, a region with this regionID does not exist");
    }
  } catch (e) {
    /// For debug purposes
    debugPrint("WorkManager: ERROR in deleteUserFromRegion function: $e");
    await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: ERROR in deleteUserFromRegion function: $e");
    return Future.value(false);
  }

  /// UPDATE SECURE STORAGE VALUES
  /// *********************************************************************************************************
  /// Query region bottom left corner coordinates
  int bottomLatitude = latitude - latitude % QUERY_WIDTH;
  int leftLongitude = longitude - longitude % QUERY_WIDTH;

  String _region = bottomLatitude.toString() + ',' + leftLongitude.toString();

  await storage.write(key: 'sharedRegion', value: _region);
  await storage.write(key: 'sharedLatitude', value: latitude.toString());
  await storage.write(key: 'sharedLongitude', value: longitude.toString());

  /// UPDATE user DOCUMENT LOCATION PARAMETERS IF EXISTS
  /// *********************************************************************************************************
  DocumentSnapshot _readUser = await _firebaseDB.collection('users').doc(sharedUserID).get();
  if (_readUser.data() != null) {
    await _firebaseDB.collection('users').doc(sharedUserID).collection('private').doc('private').update({
      'latitude': latitude,
      'longitude': longitude,
      'region': _region,
    });
  } else {
    /// For debug purposes
    debugPrint("WorkManager: ERROR: update user location");
    await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: ERROR: update user location");
  }

  /// UPDATE regions COLLECTIONS IF EXISTS, SET IF NOT EXISTS
  /// *********************************************************************************************************
  try {
    DocumentSnapshot _readRegion = await _firebaseDB.collection('regions').doc(_region).get();

    /// if a region exists with this region on regions collections, then add userID to array field of users
    if (_readRegion.data() != null) {
      await _firebaseDB.collection('regions').doc(_region).update({
        "users": FieldValue.arrayUnion([sharedUserID])
      });
    } else {
      await _firebaseDB.collection('regions').doc(_region).set({
        "users": FieldValue.arrayUnion([sharedUserID])
      });
      /// For debug purposes
      debugPrint("WorkManager: Document does not exist, so regionID created");
      await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: Document does not exist, so regionID created");
    }
  } catch (e) {
    /// For debug purposes
    debugPrint("WorkManager: ERROR in setUserInRegion function: $e");
    await FCMAndLocalNotifications.showNotificationForDebugPurposes("WorkManager: ERROR in setUserInRegion function: $e");
    return Future.value(false);
  }
  /// *********************************************************************************************************

  /// For debug purposes
  debugPrint("Basarili ${_position.toString()}");
  await FCMAndLocalNotifications.showNotificationForDebugPurposes("Basarili ${_position.toString()}");
  return Future.value(true);
}
