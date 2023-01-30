import 'package:peopler/data/model/notifications.dart';
import 'package:peopler/data/repository/user_repository.dart';

import '../../others/locator.dart';
import '../model/user.dart';
import '../services/db/firestore_db_service_users.dart';

class NotificationRepository {
  static const int _numberOfElements = 10;

  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();
  final UserRepository _userRepository = locator<UserRepository>();

  bool _hasMoreTransmitted = true;
  bool _hasMoreReceived = true;
  bool _hasMoreNotification = true;

  Future<List<Notifications>> getNotificationTransmittedWithPagination(String myUserID, Notifications? lastElement) async {
    if (_hasMoreTransmitted == false) return [];

    List<Notifications> requestList =
        await _firestoreDBServiceUsers.getRequestsWithPagination(myUserID, lastElement, _numberOfElements, 'TransmittedRequest');

    if (requestList.length < _numberOfElements) {
      _hasMoreTransmitted = false;
    }

    if (requestList.isEmpty) return [];

    List<String> deletedUserIDs = [];

    for (int index = 0; index < requestList.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(requestList[index].requestUserID!);

      // DİKKAT
      // remove deleted users
      if (_user == null) {
        deletedUserIDs.add(requestList[index].requestUserID!);
        await _userRepository.removeConnection(myUserID, requestList[index].requestUserID!);
        continue;
      }

      requestList[index].requestDisplayName = _user.displayName;
      requestList[index].requestProfileURL = _user.profileURL;
      requestList[index].requestBiography = _user.biography;
    }

    for (String deletedUserID in deletedUserIDs) {
      requestList.removeWhere((element) => element.requestUserID == deletedUserID);
    }

    return requestList;
  }

  Future<List<Notifications>> getNotificationReceivedWithPagination(String myUserID, Notifications? lastElement) async {
    if (_hasMoreReceived == false) return [];

    List<Notifications> requestList =
        await _firestoreDBServiceUsers.getRequestsWithPagination(myUserID, lastElement, _numberOfElements, 'ReceivedRequest');

    if (requestList.length < _numberOfElements) {
      _hasMoreReceived = false;
    }

    if (requestList.isEmpty) return [];

    List<String> deletedUserIDs = [];

    for (int index = 0; index < requestList.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(requestList[index].requestUserID!);

      // DİKKAT
      // remove deleted users
      if (_user == null) {
        deletedUserIDs.add(requestList[index].requestUserID!);
        await _userRepository.removeConnection(myUserID, requestList[index].requestUserID!);
        continue;
      }

      requestList[index].requestDisplayName = _user.displayName;
      requestList[index].requestProfileURL = _user.profileURL;
      requestList[index].requestBiography = _user.biography;
    }

    for (String deletedUserID in deletedUserIDs) {
      requestList.removeWhere((element) => element.requestUserID == deletedUserID);
    }

    return requestList;
  }

  Future<List<Notifications>> getNotificationWithPagination(String myUserID, Notifications? lastElement) async {
    if (_hasMoreNotification == false) return [];

    List<Notifications> _allNotifications = await _firestoreDBServiceUsers.getNotificationsWithPagination(myUserID, lastElement, _numberOfElements);

    if (_allNotifications.length < _numberOfElements) {
      _hasMoreNotification = false;
    }

    if (_allNotifications.isEmpty) return [];

    List<String> deletedUserIDs = [];

    for (int index = 0; index < _allNotifications.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(_allNotifications[index].requestUserID!);

      // DİKKAT
      // remove deleted users
      if (_user == null) {
        deletedUserIDs.add(_allNotifications[index].requestUserID!);
        await _userRepository.removeConnection(myUserID, _allNotifications[index].requestUserID!);
        continue;
      }

      _allNotifications[index].requestDisplayName = _user.displayName;
      _allNotifications[index].requestProfileURL = _user.profileURL;
      _allNotifications[index].requestBiography = _user.biography;
    }

    for (String deletedUserID in deletedUserIDs) {
      _allNotifications.removeWhere((element) => element.requestUserID == deletedUserID);
    }

    return _allNotifications;
  }

  Stream<List<Notifications>> getNotificationWithStream(String currentUserID) {
    return _firestoreDBServiceUsers.getNotificationWithStream(currentUserID);
  }

  // When the "Accept" button is clicked, this function run
  Future<void> acceptConnectionRequest(String myUserID, String requestUserID) async {
    // requestUserID is notificationID for incoming request for me
    await _firestoreDBServiceUsers.updateAcceptedField(myUserID, requestUserID);

    // myUserID is notificationID for outgoing request for host
    await _firestoreDBServiceUsers.updateAcceptedField(requestUserID, myUserID);

    await _firestoreDBServiceUsers.saveUserToConnections(myUserID, requestUserID);
    await _firestoreDBServiceUsers.saveUserToConnections(requestUserID, myUserID);

    await _firestoreDBServiceUsers.deleteTransmittedUserIDsField(requestUserID, myUserID);
    await _firestoreDBServiceUsers.deleteReceivedUserIDsField(myUserID, requestUserID);
  }

  Future<void> deleteNotification(String myUserID, String requestUserID) async {
    await _firestoreDBServiceUsers.deleteTransmittedUserIDsField(myUserID, requestUserID);
    await _firestoreDBServiceUsers.deleteReceivedUserIDsField(requestUserID, myUserID);

    await _firestoreDBServiceUsers.deleteNotificationFromUser(requestUserID, myUserID);
    await _firestoreDBServiceUsers.deleteNotificationFromUser(myUserID, requestUserID);
  }

  Future<void> makeNotificationInvisible(String myUserID, String notificationID) async {
    await _firestoreDBServiceUsers.makeNotificationInvisible(myUserID, notificationID);
  }

  void restartTransmittedRequestCache() async {
    _hasMoreTransmitted = true;
  }

  void restartReceivedRequestCache() async {
    _hasMoreReceived = true;
  }

  void restartNotificationCache() async {
    _hasMoreNotification = true;
  }
}
