import 'dart:async';
import 'dart:math';
import 'package:peopler/data/services/db/firestore_db_service_users.dart';
import '../../others/locator.dart';
import '../model/user.dart';

class CityRepository {
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  static const PAGINATION_NUM_USERS = 10;

  bool _hasMoreCity = true;
  bool _hasMoreArr = false;

  List<String> arrayUserList = [];
  Set<int> _randomArr = {};
  int? randomNumber;

  Future<List<MyUser>> queryUsersCityWithPagination(String city, Set<String> unnecessaryUsers) async {
    if (_hasMoreCity == false) return [];

    int? lastArr = await _firestoreDBServiceUsers.readCity(city);
    if(lastArr == null) {
      _hasMoreCity = false;
      return [];
    }

    /// If current array has consumed,
    if(_hasMoreArr == false) {
      /// If num of arrays in database is equal to num of consumed arrays in local, there is no users left
      if((lastArr + 1) == _randomArr.length) {
        _hasMoreCity = false;
        return [];
      }

      /// If there are more arrays in database which we have not consumed yet locally,
      Set<int> setOfRestRandomNumbers = {for(int i=0; i<(lastArr + 1); i+=1) i};
      List<int> listOfRestRandomNumbers = List.from(setOfRestRandomNumbers.difference(_randomArr));
      randomNumber = listOfRestRandomNumbers[Random().nextInt(listOfRestRandomNumbers.length)];
      _randomArr.add(randomNumber!);

      arrayUserList = await _firestoreDBServiceUsers.readArrayUsers(city, randomNumber!);
      _hasMoreArr = true;
    }

    /// remove unneccessary users from all user list in the array
    arrayUserList = arrayUserList.toSet().difference(unnecessaryUsers).toList();

    /// Take first n element of all user list and remove them from all user list
    List<String> tempList;
    if (arrayUserList.length < PAGINATION_NUM_USERS) {
      _hasMoreArr = false;
      tempList = arrayUserList.take(arrayUserList.length).toList();
      arrayUserList.removeRange(0, tempList.length);
    } else {
      tempList = arrayUserList.take(PAGINATION_NUM_USERS).toList();
      arrayUserList.removeRange(0, PAGINATION_NUM_USERS);
    }

    List<MyUser> newUsers = await _firestoreDBServiceUsers.getUsersWithUserIDs(tempList);

    return newUsers;
  }

  void restartRepositoryCache() {
    _hasMoreCity = true;
    _hasMoreArr = false;
    _randomArr = {};
  }
}
