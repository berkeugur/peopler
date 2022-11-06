import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:peopler/data/services/db/firestore_db_service_users.dart';
import 'package:peopler/data/services/location/location_service.dart';
import '../../others/locator.dart';
import '../../others/strings.dart';
import '../model/user.dart';
import '../services/db/firebase_db_service_location.dart';

class LocationRepository {
  final LocationService _locationServices = locator<LocationService>();
  final FirestoreDBServiceLocation _firestoreDBServiceLocation = locator<FirestoreDBServiceLocation>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  static const PAGINATION_NUM_USERS = 10;

  bool _hasMore = true;
  bool allUsersGotFromRegion = false;
  List<String> allUserIDList = [];

  Future<bool> checkLocationSetting() async {
    return await _locationServices.checkLocationService();
  }

  Future<void> requestLocationSetting() async {
    /// Different from requestPermission, app leaves this function when Google's location request dialog comes. Thus, the function does not return any value.
    await openLocationSettings();
  }

  Future<LocationPermission> checkPermissions() async {
    return await _locationServices.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    LocationPermission _permission = await _locationServices.requestPermission();
    return _permission;
  }

  Future<void> openPermissionSettings() async {
    await _locationServices.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    const locationChannel = MethodChannel('mertsalar/location_setting'); // This is the same name where we have defined in Native side
    await locationChannel.invokeMethod('requestLocationSetting', []); // This method name is the same as Native side, we call this method from Kotlin
  }

  Stream<String> serviceStatusStream() {
    return _locationServices.serviceStatusStream();
  }

  Future<Position?> getCurrentPosition() async {
    return await _locationServices.getCurrentPosition();
  }

  Future<bool> updateUserLocationAtDatabase(Position position) async {
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
        return false;
      }

      /// Delete user from old region
      List<String> oldRegions = determineRegionList(oldLatitude, oldLongitude);
      for (String region in oldRegions) {
        await _firestoreDBServiceLocation.deleteUserFromRegion(sharedUserID!, region);
      }

      await storage.write(key: 'sharedLatitude', value: newLatitude.toString());
      await storage.write(key: 'sharedLongitude', value: newLongitude.toString());

      await _firestoreDBServiceUsers.updateUserLocationAtDatabase(sharedUserID!, newLatitude, newLongitude);

      /// Update regions collection
      List<String> newRegions = determineRegionList(newLatitude, newLongitude);
      for (String region in newRegions) {
        await _firestoreDBServiceLocation.setUserInRegion(sharedUserID, region);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateGuestUserLocation(Position position) async {
    try {
      /// Obtain shared preferences.
      const storage = FlutterSecureStorage();
      Map<String, String> allValues = await storage.readAll();

      int? sharedLatitude = int.parse(allValues['sharedLatitude']!);
      int? sharedLongitude = int.parse(allValues['sharedLongitude']!);

      int latitude = (position.latitude * 1e5).round();
      int longitude = (position.longitude * 1e5).round();

      /// If user's new location does not change more than UPDATE_WIDTH, then do not make any database operation.
      if (latitude > sharedLatitude - Strings.UPDATE_WIDTH &&
          latitude < sharedLatitude + Strings.UPDATE_WIDTH &&
          longitude > sharedLongitude - Strings.UPDATE_WIDTH &&
          longitude < sharedLongitude + Strings.UPDATE_WIDTH) {
        return false;
      }

      await storage.write(key: 'sharedLatitude', value: latitude.toString());
      await storage.write(key: 'sharedLongitude', value: longitude.toString());

      return true;
    } catch (e) {
      return false;
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

  Future<List<MyUser>> queryUsersWithPagination(int latitude, int longitude, Set<String> unnecessaryUsers) async {
    if (_hasMore == false) return [];

    if(allUsersGotFromRegion == false) {
      /// Get all userIDs
      int bottomLatitude = latitude - latitude % Strings.REGION_WIDTH;
      int leftLongitude = longitude - longitude % Strings.REGION_WIDTH;
      String queryRegion = bottomLatitude.toString() + ',' + leftLongitude.toString();
      allUserIDList = await _firestoreDBServiceLocation.getAllUserIDsFromRegion(queryRegion);

      /// remove unneccessary users from all user list in the array
      allUserIDList = allUserIDList.toSet().difference(unnecessaryUsers).toList();

      allUsersGotFromRegion = true;
    }

    /// Take first n element of all user list and remove them from all user list
    List<String> tempList;
    if (allUserIDList.length < PAGINATION_NUM_USERS) {
      _hasMore = false;
      tempList = allUserIDList.take(allUserIDList.length).toList();
    } else {
      tempList = allUserIDList.take(PAGINATION_NUM_USERS).toList();
      allUserIDList.removeRange(0, PAGINATION_NUM_USERS);
    }

    List<MyUser> newUsers = await _firestoreDBServiceUsers.getUsersWithUserIDs(tempList);

    return newUsers;
  }

  void restartRepositoryCache() {
      _hasMore = true;
      allUsersGotFromRegion = false;
      allUserIDList = [];
  }
}

