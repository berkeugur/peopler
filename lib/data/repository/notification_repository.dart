import 'package:peopler/data/model/notifications.dart';

import '../../others/locator.dart';
import '../model/user.dart';
import '../services/db/firestore_db_service_users.dart';

class NotificationRepository {
  static const int _numberOfElements = 10;

  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  bool _hasMoreTransmitted = true;
  bool _hasMoreReceived = true;
  bool _hasMoreNotification = true;

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

  Future<List<Notifications>> getNotificationWithPagination(String myUserID, Notifications? lastElement) async {
    if (_hasMoreNotification == false) return [];

    List<Notifications> notificationList = await _firestoreDBServiceUsers.getNotificationsWithPagination(myUserID, lastElement, _numberOfElements);

    if (notificationList.length < _numberOfElements) {
      _hasMoreNotification = false;
    }

    if (notificationList.isEmpty) return [];

    for (int index=0; index < notificationList.length; index++) {
      if(notificationList[index].requestUserID == null) continue;

      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(notificationList[index].requestUserID!);
      notificationList[index].requestDisplayName = _user!.displayName;
      notificationList[index].requestProfileURL = _user.profileURL;
      notificationList[index].requestBiography = _user.biography;
    }

    return notificationList;
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

  void restartNotificationCache() async {
    _hasMoreNotification = true;
  }
}
