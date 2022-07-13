import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:peopler/data/services/db/firestore_db_service_users.dart';
import 'package:peopler/data/services/location/location_service.dart';
import '../../others/locator.dart';
import '../model/user.dart';
import '../services/db/firebase_db_service_location.dart';

class LocationRepository {
  final LocationService _locationServices = locator<LocationService>();
  final FirestoreDBServiceLocation _firestoreDBServiceLocation = locator<FirestoreDBServiceLocation>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  static const UPDATE_WIDTH = 20; // 20 meters
  static const QUERY_WIDTH = 100; // 100 meters
  static const PAGINATION_NUM_USERS = 10;  // number of query per 9 regions, very important parameter, please do not change

  final List<bool> _hasMore = List.filled(9, true);
  final List<String?> _lastUserElement = List.filled(9, null);

  bool _hasMoreCity = true;

  /// To reference the different list instances, List of List generated like this.
  /// https://stackoverflow.com/questions/25118921/how-do-i-handle-a-list-of-lists
  final List<List<String>> _userIDsInRegion = List.generate(9, (i) => []);

  bool _isAllUsersGotFromRegion = false;

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
    /*
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(''), // App Permission Settings
              content: const Text(
                  'Sizinle aynı bölgede bulunan kullanıcıların uygulama arka planda dahi çalışırken sizi bulabilmesi için ayarlardan "Her zaman izin ver" seçiniz.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Geri'),
                ),
                TextButton(
                  onPressed: () async {
                    await _locationServices.openAppSettings();
                    Navigator.pop(context);
                  },
                  child: const Text('Open Settings'),
                )
              ],
            ));

     */
  }

  Future<void> openLocationSettings() async {
    const locationChannel = MethodChannel('mertsalar/location_setting');   // This is the same name where we have defined in Native side
    await locationChannel.invokeMethod('requestLocationSetting', []);      // This method name is the same as Native side, we call this method from Kotlin
  }

  Stream<String> serviceStatusStream() {
    return _locationServices.serviceStatusStream();
  }

  Future<Position?> getCurrentPosition() async {
    return await _locationServices.getCurrentPosition();
  }

  Future<bool> updateUserLocationAtDatabase(Position position) async {
    try{

      /// Obtain shared preferences.
      const storage = FlutterSecureStorage();
      Map<String, String> allValues = await storage.readAll();

      final String? sharedUserID = allValues['sharedUserID'];
      String? sharedRegion = allValues['sharedRegion'];
      int? sharedLatitude = int.parse(allValues['sharedLatitude']!);
      int? sharedLongitude = int.parse(allValues['sharedLongitude']!);

      int latitude = (position.latitude * 1e5).round();
      int longitude = (position.longitude * 1e5).round();

      /// If user's new location does not change more than UPDATE_WIDTH, then do not make any database operation.
      if(latitude > sharedLatitude - UPDATE_WIDTH &&
          latitude < sharedLatitude + UPDATE_WIDTH &&
          longitude > sharedLongitude - UPDATE_WIDTH &&
          longitude < sharedLongitude + UPDATE_WIDTH) {
        return false;
      }

      /// Delete user from old region
      await _firestoreDBServiceLocation.deleteUserFromRegion(sharedUserID!, sharedRegion!);

      /// Query region bottom left corner coordinates
      int bottomLatitude = latitude - latitude % QUERY_WIDTH;
      int leftLongitude = longitude - longitude % QUERY_WIDTH;

      String _region = bottomLatitude.toString() + ',' + leftLongitude.toString();

      await storage.write(key: 'sharedRegion', value: _region);
      await storage.write(key: 'sharedLatitude', value: latitude.toString());
      await storage.write(key: 'sharedLongitude', value: longitude.toString());

      await _firestoreDBServiceUsers.updateUserLocationAtDatabase(sharedUserID, latitude, longitude, _region);

      /// Update regions collection
      await _firestoreDBServiceLocation.setUserInRegion(sharedUserID, _region);

      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<List<String>> determineQueryList(int latitude, int longitude) async {
    int _latitude = latitude;
    int _longitude = longitude;

    /// Query region bottom left corner coordinates
    int bottomLatitude = _latitude - _latitude % QUERY_WIDTH;
    int leftLongitude = _longitude - _longitude % QUERY_WIDTH;

    /// Create return variable queryList which keeps regions and subRegions
    List<String> queryList = [];

    String currentRegion =       bottomLatitude.toString() + ',' +                  leftLongitude.toString();

    String bottomLeftRegion =   (bottomLatitude - QUERY_WIDTH).toString() + ',' +  (leftLongitude - QUERY_WIDTH).toString();
    String leftRegion =          bottomLatitude.toString() + ',' +                 (leftLongitude - QUERY_WIDTH).toString();
    String topLeftRegion =      (bottomLatitude + QUERY_WIDTH).toString() + ',' +  (leftLongitude - QUERY_WIDTH).toString();

    String topRegion =          (bottomLatitude + QUERY_WIDTH).toString() + ',' +   leftLongitude.toString();
    String bottomRegion =       (bottomLatitude - QUERY_WIDTH).toString() + ',' +   leftLongitude.toString();

    String bottomRightRegion =   (bottomLatitude - QUERY_WIDTH).toString() + ',' + (leftLongitude + QUERY_WIDTH).toString();
    String rightRegion =         bottomLatitude.toString() + ',' +                 (leftLongitude + QUERY_WIDTH).toString();
    String topRightRegion =      (bottomLatitude + QUERY_WIDTH).toString() + ',' + (leftLongitude + QUERY_WIDTH).toString();

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

  Future<List<MyUser>> queryUsersWithPagination(List<String> queryList) async {

    if(_isAllUsersGotFromRegion == false) {
      for(int i = 0; i<9; i++) {
        List<String> _tempList = await _firestoreDBServiceLocation.getAllUserIDsFromRegion(queryList[i]);
        _userIDsInRegion[i].addAll(_tempList);
      }
      _isAllUsersGotFromRegion = true;
    }

    List<MyUser> userList = [];
    for (int i=0; i<9; i++) {
      if (_hasMore[i] == false) continue;
      List<String> _tempUserIDList = [];

      if(_lastUserElement[i] == null) {
        if(_userIDsInRegion[i].length < PAGINATION_NUM_USERS) {
          _tempUserIDList.addAll(_userIDsInRegion[i]);
        } else {
          _tempUserIDList.addAll(_userIDsInRegion[i].take(PAGINATION_NUM_USERS).toList());
        }
      } else {
        int startingUserIDIndex = _userIDsInRegion[i].indexOf(_lastUserElement[i]!);
        if(_userIDsInRegion[i].length < startingUserIDIndex + PAGINATION_NUM_USERS) {
          _tempUserIDList.addAll(_userIDsInRegion[i].getRange(startingUserIDIndex, _userIDsInRegion[i].length-1));
        } else {
          _tempUserIDList.addAll(_userIDsInRegion[i].getRange(startingUserIDIndex, startingUserIDIndex + PAGINATION_NUM_USERS));
        }
      }

      if(_tempUserIDList.isNotEmpty) _lastUserElement[i] = _tempUserIDList.last;

      /// If number of users get is smaller than the desired, there is no more data
      if(_tempUserIDList.length < PAGINATION_NUM_USERS) _hasMore[i] = false;

      List<MyUser> tempList = await _firestoreDBServiceUsers.getUsersWithUserIDs(_tempUserIDList);

      userList.addAll(tempList);
    }

    return userList;
  }

  Future<List<MyUser>> queryUsersCityWithPagination(String city, List<MyUser> allUserList) async {
    if (_hasMoreCity == true) {
      MyUser? _lastSelectedUser;
      int _numberOfElementsWillBeSelected = 10;

      if (allUserList.isNotEmpty) {
        _lastSelectedUser = allUserList.last;
      }

      List<MyUser> newList = await _firestoreDBServiceUsers.getUserCityWithPagination(city, _lastSelectedUser, 10);

      if (newList.length < _numberOfElementsWillBeSelected) {
        _hasMoreCity = false;
      }

      if (newList.isNotEmpty) {
        return newList;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  void restartRepositoryCache() {
    for(int i=0; i<9; i++)
      {
        _hasMore[i] = true;
        _lastUserElement[i] = null;
        _userIDsInRegion[i].clear();
      }
    _hasMoreCity = true;
    _isAllUsersGotFromRegion = false;
  }
}
