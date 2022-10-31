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

  static const PAGINATION_NUM_USERS = 10;

  bool _hasMoreCity = true;
  MyUser? _lastSelectedUser;

  Future<List<MyUser>> queryUsersCityWithPagination(String city) async {
    if (_hasMoreCity == false) return [];

    List<MyUser> newList = await _firestoreDBServiceUsers.getUserCityWithPagination(city, _lastSelectedUser, 10);

    _lastSelectedUser = newList.last;

    if (newList.length < PAGINATION_NUM_USERS) {
      _hasMoreCity = false;
    }

    return newList;
  }

  void restartRepositoryCache() {
    _hasMoreCity = true;
    _lastSelectedUser = null;
  }
}
