import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:peopler/data/services/db/firestore_db_service_users.dart';
import 'package:peopler/data/services/location/location_service.dart';
import '../../others/locator.dart';
import '../model/user.dart';
import '../services/db/firebase_db_service_location.dart';

class CityRepository {
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  bool _hasMoreCity = true;

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
    _hasMoreCity = true;
  }
}
