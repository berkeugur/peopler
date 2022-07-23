import 'package:peopler/data/model/notifications.dart';

import '../../others/locator.dart';
import '../model/user.dart';
import '../services/db/firestore_db_service_users.dart';

class NotificationRepository {
  static const int _numberOfElements = 10;

  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  bool _hasMoreTransmitted = true;
  bool _hasMoreReceived = true;

  Future<List<Notifications>> getNotificationTransmittedWithPagination(String myUserID, Notifications? lastElement) async {
    if (_hasMoreTransmitted == false) return [];

    List<Notifications> requestList = await _firestoreDBServiceUsers.getRequestsWithPagination(myUserID, lastElement, _numberOfElements, 'TransmittedRequest');

    if (requestList.length < _numberOfElements) {
      _hasMoreTransmitted = false;
    }

    if (requestList.isEmpty) return [];

    for (int index=0; index < requestList.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(requestList[index].requestUserID!);
      requestList[index].requestDisplayName = _user!.displayName;
      requestList[index].requestProfileURL = _user.profileURL;
      requestList[index].requestBiography = _user.biography;
    }

    return requestList;
  }

  Future<List<Notifications>> getNotificationReceivedWithPagination(String myUserID, Notifications? lastElement) async {
    if (_hasMoreReceived == false) return [];

    List<Notifications> requestList = await _firestoreDBServiceUsers.getRequestsWithPagination(myUserID, lastElement, _numberOfElements, 'ReceivedRequest');

    if (requestList.length < _numberOfElements) {
      _hasMoreReceived = false;
    }

    if (requestList.isEmpty) return [];

    for (int index=0; index < requestList.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(requestList[index].requestUserID!);
      requestList[index].requestDisplayName = _user!.displayName;
      requestList[index].requestProfileURL = _user.profileURL;
      requestList[index].requestBiography = _user.biography;
    }

    return requestList;
  }



  Stream<List<Notifications>> getNotificationWithStream(String currentUserID) {
    return _firestoreDBServiceUsers.getNotificationWithStream(currentUserID);
  }

  Future<List<Notifications>> getNotificationWithPagination(String currentUserID, Notifications? lastNotification, int numberOfElements) async {
    List<Notifications> _allNotifications = await _firestoreDBServiceUsers.getNotificationsWithPagination(currentUserID, lastNotification, numberOfElements);

    for (int index=0; index < _allNotifications.length; index++) {
      if(_allNotifications[index].requestUserID == null) continue;

      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(_allNotifications[index].requestUserID!);
      _allNotifications[index].requestDisplayName = _user!.displayName;
      _allNotifications[index].requestProfileURL = _user.profileURL;
      _allNotifications[index].requestBiography = _user.biography;
    }

    return _allNotifications;
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

  // When the "Not Accept" button is clicked, this function run
  Future<void> notAcceptConnectionRequest(String myUserID, String requestUserID) async {
    // requestUserID is notificationID for incoming request for me
    await _firestoreDBServiceUsers.deleteNotificationFromUser(myUserID, requestUserID);

    // myUserID is notificationID for outgoing request for host
    await _firestoreDBServiceUsers.deleteNotificationFromUser(requestUserID, myUserID);

    await _firestoreDBServiceUsers.deleteTransmittedUserIDsField(requestUserID, myUserID);
    await _firestoreDBServiceUsers.deleteReceivedUserIDsField(myUserID, requestUserID);
  }


  void restartTransmittedRequestCache() async {
    _hasMoreTransmitted = true;
  }

  void restartReceivedRequestCache() async {
    _hasMoreReceived = true;
  }
}
