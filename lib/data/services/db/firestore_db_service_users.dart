import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/notifications.dart';
import '../../model/saved_user.dart';
import '../../model/user.dart';

class FirestoreDBServiceUsers {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Future<bool> saveUser(MyUser user) async {
    DocumentSnapshot _readUser = await _firebaseDB.collection('users').doc(user.userID).get();

    if (_readUser.data() != null) {
      debugPrint("saveUser ERROR: Document exists, a user with same user id cannot be created at database.");
      return false;
    }

    await _firebaseDB.collection('users').doc(user.userID).set(user.toPublicMap());
    await _firebaseDB.collection('users').doc(user.userID).collection("private").doc("private").set(user.toPrivateMap());
    return true;
  }

  // Read both public and private fields
  Future<MyUser?> readUserPrivileged(String userID) async {
    // PUBLIC FIELD
    DocumentSnapshot documentSnapshot = await _firebaseDB.collection('users').doc(userID).get();

    if(!documentSnapshot.exists) {
      debugPrint('readUser Document does not exist on the database');
      return null;
    }

    Map<String, dynamic> _readUserPublicMap = documentSnapshot.data() as Map<String, dynamic>;
    MyUser _myUserPublic;
    _myUserPublic = MyUser.fromPublicMap(_readUserPublicMap);

    // PRIVATE FIELD
    documentSnapshot = await _firebaseDB.collection('users').doc(userID).collection("private").doc("private").get();
    Map<String, dynamic> _readUserPrivateMap = documentSnapshot.data() as Map<String, dynamic>;
    return MyUser.fromPrivateMap(_readUserPrivateMap, _myUserPublic);
  }

  // Read only public fields
  Future<MyUser?> readUserRestricted(String userID) async {
    // PUBLIC FIELD
    DocumentSnapshot documentSnapshot = await _firebaseDB.collection('users').doc(userID).get();

    if(!documentSnapshot.exists) {
      debugPrint('readUser Document does not exist on the database');
      return null;
    }

    Map<String, dynamic> _readUserMap = documentSnapshot.data() as Map<String, dynamic>;
    return MyUser.fromPublicMap(_readUserMap);
  }

  Future<bool> updateUser(MyUser user) async {
    DocumentSnapshot _readUser = await _firebaseDB.collection('users').doc(user.userID).get();

    if (_readUser.data() != null) {
      await _firebaseDB
          .collection('users')
          .doc(user.userID)
          .update(user.toPublicMap());

      await _firebaseDB
          .collection('users')
          .doc(user.userID)
          .collection("private")
          .doc("private")
          .update(user.toPrivateMap());
      return true;
    } else {
      debugPrint("updateUser ERROR: Document does not exist, a user with this user id does not exist");
      return false;
    }
  }

  Future<bool> updateUserLocationAtDatabase(String userID, int latitude, int longitude, String region) async {
    DocumentSnapshot _readUser = await _firebaseDB.collection('users').doc(userID).get();

    if (_readUser.data() != null) {
      await _firebaseDB.collection('users').doc(userID).collection("private").doc("private").update({
        'latitude': latitude,
        'longitude': longitude,
        'region': region,
      });
      return true;
    } else {
      debugPrint("updateUserLocationAtDatabase ERROR: Document does not exist, a user with this user id does not exist");
      return false;
    }
  }

  Future<bool> updateAccountConfirmed(String userID, bool newAccountConfirmed) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .collection("private")
          .doc("private")
          .update({'isTheAccountConfirmed': newAccountConfirmed});
      return true;
    } catch (e) {
      debugPrint('Update isTheAccountConfirmed fail');
      return false;
    }
  }

  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .update({'profileURL': profilePhotoURL});
      return true;
    } catch (e) {
      debugPrint('Update profilePhotoURL fail');
      return false;
    }
  }

  Future<String> getToken(String userID) async {
    DocumentSnapshot _token = await _firebaseDB.doc("tokens/" + userID).get();
    Map<String, dynamic> _tokenMap = _token.data() as Map<String, dynamic>;
    return _tokenMap["token"];
  }

  Future<bool> deleteToken(String userID) async {
    try {
      await _firebaseDB
          .collection('tokens')
          .doc(userID)
          .delete();
      return true;
    } catch (e) {
      debugPrint('removeLikedDislikedFeed fail');
      return false;
    }
  }

  Future<bool> deleteUser(String userID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .delete();
      return true;
    } catch (e) {
      debugPrint('removeLikedDislikedFeed fail');
      return false;
    }
  }

  /// *************** Like Dislike Functions **********************/

  Future<bool> addLikedDislikedFeed(String userID, String feedID, String type) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .collection(type)
          .doc(feedID)
          .set({});
      return true;
    } catch (e) {
      debugPrint('addLikedDislikedFeed fail');
      return false;
    }
  }

  Future<bool> removeLikedDislikedFeed(String userID, String feedID, String type) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .collection(type)
          .doc(feedID)
          .delete();
      return true;
    } catch (e) {
      debugPrint('removeLikedDislikedFeed fail');
      return false;
    }
  }

  Future<bool?> isLikedOrDislikedByUser(String userID, String feedID) async {
    // true: liked
    // false: disliked
    // null: nothing
    DocumentSnapshot liked = await _firebaseDB
        .collection('users')
        .doc(userID)
        .collection('liked')
        .doc(feedID)
        .get();

    DocumentSnapshot disliked = await _firebaseDB
        .collection('users')
        .doc(userID)
        .collection('disliked')
        .doc(feedID)
        .get();

    if (liked.data() != null) {
      // If feedID exists on liked collection
      return true;
    } else {
      // If feedID does not exist on disliked collection, then return null
      if (disliked.data() == null) return null;
      // If feedID does exist on disliked collection, then return false
      return false;
    }
  }

  Future<bool> removeActivity(String userID, String feedID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .collection('activities')
          .doc(feedID)
          .delete();
      return true;
    } catch (e) {
      debugPrint('removeActivity fail');
      return false;
    }
  }

  Future<bool> addActivity(String userID, MyActivity myActivity) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .collection('activities')
          .doc(myActivity.feedID)
          .set(myActivity.toMap());
      return true;
    } catch (e) {
      debugPrint('addActivity fail');
      return false;
    }
  }

  Future<List<MyActivity>> getActivities(String userID) async {
    QuerySnapshot _querySnapshot;

      _querySnapshot = await _firebaseDB
          .collection('users')
          .doc(userID)
          .collection('activities')
          .orderBy('createdAt', descending: true)
          .get();

    List<MyActivity> _allActivities = [];
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      MyActivity _currentActivity = MyActivity.fromMap(snap.data() as Map<String, dynamic>);
      _allActivities.add(_currentActivity);
    }

    return _allActivities;
  }

  /// *************** Search Screen Functions **********************/
  Future<List<MyUser>> getUsersWithUserIDs(List<String> userIDList) async {
    List<MyUser> _allUsers = [];
    for (String userID in userIDList) {
      DocumentSnapshot _userDocument = await _firebaseDB
          .collection('users')
          .doc(userID)
          .get();
      MyUser _currentUser = MyUser.fromPublicMap(_userDocument.data() as Map<String, dynamic>);
      _allUsers.add(_currentUser);
    }

    return _allUsers;
  }

  Future<List<MyUser>> getUserCityWithPagination(String city, MyUser? lastSelectedUser, int numberOfElementsWillBeSelected) async {
    QuerySnapshot _querySnapshot;

    if (lastSelectedUser == null) {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .where('city', isEqualTo: city)
          .orderBy('createdAt', descending: true)
          .limit(numberOfElementsWillBeSelected)
          .get();
    } else {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .where('city', isEqualTo: city)
          .orderBy('createdAt', descending: true)
          .startAfter([lastSelectedUser.createdAt])
          .limit(numberOfElementsWillBeSelected)
          .get();
    }

    List<MyUser> _allUsers = [];
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      MyUser _currentUser = MyUser.fromPublicMap(snap.data() as Map<String, dynamic>);
      _allUsers.add(_currentUser);
    }

    return _allUsers;
  }

  /// *************** Saved Screen Functions **********************/

  Future<List<SavedUser>> getSavedUsersWithPagination(
      String myUserID,
      SavedUser? lastSelectedRequest,
      int numberOfElementsWillBeSelected) async {
    QuerySnapshot _querySnapshot;

    if (lastSelectedRequest == null) {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('savedUsers')
          .orderBy('createdAt', descending: true)
          .limit(numberOfElementsWillBeSelected)
          .get();
    } else {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('savedUsers')
          .orderBy('createdAt', descending: true)
          .startAfter([lastSelectedRequest.createdAt])
          .limit(numberOfElementsWillBeSelected)
          .get();
    }

    List<SavedUser> _allRequests = [];
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      SavedUser _currentRequest = SavedUser.fromMap(snap.data() as Map<String, dynamic>);
      _allRequests.add(_currentRequest);
    }

    return _allRequests;
  }

  Future<bool> saveUserToSavedUsers(String myUserID, SavedUser savedUser) async {
    DocumentSnapshot _readUser = await _firebaseDB
        .collection('users')
        .doc(myUserID)
        .collection('savedUsers')
        .doc(savedUser.userID)
        .get();

    if (_readUser.data() == null) {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('savedUsers')
          .doc(savedUser.userID)
          .set(savedUser.toMap());
      return true;
    } else {
      debugPrint("ERROR: Document exists, a user with same user id cannot be created at database.");
      return false;
    }
  }

  Future<bool> updateSaveUserIDsField(String myUserID, String requestUserID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection("private")
          .doc("private")
          .update({"savedUserIDs": FieldValue.arrayUnion([requestUserID])});
      return true;
    } catch (e) {
      debugPrint('Update SaveUserIDsField fail');
      return false;
    }
  }

  Future<bool> updateTransmittedUserIDsField(String myUserID, String requestUserID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection("private")
          .doc("private")
          .update({"transmittedRequestUserIDs": FieldValue.arrayUnion([requestUserID])});
      return true;
    } catch (e) {
      debugPrint('Update transmittedRequestUserIDs fail');
      return false;
    }
  }

  Future<bool> updateReceivedUserIDsField(String myUserID, String requestUserID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .update({"receivedRequestUserIDs": FieldValue.arrayUnion([requestUserID])});
      return true;
    } catch (e) {
      debugPrint('Update receivedRequestUserIDs fail');
      return false;
    }
  }

  Future<bool> deleteSaveUserIDsField(String myUserID, String requestUserID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection("private")
          .doc("private")
          .update({"savedUserIDs": FieldValue.arrayRemove([requestUserID])});
      return true;
    } catch (e) {
      debugPrint('Update SaveUserIDsField fail');
      return false;
    }
  }

  Future<bool> deleteTransmittedUserIDsField(String myUserID, String requestUserID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection("private")
          .doc("private")
          .update({"transmittedRequestUserIDs": FieldValue.arrayRemove([requestUserID])});
      return true;
    } catch (e) {
      debugPrint('Update SaveUserIDsField fail');
      return false;
    }
  }

  Future<bool> deleteReceivedUserIDsField(String myUserID, String requestUserID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .update({"receivedRequestUserIDs": FieldValue.arrayRemove([requestUserID])});
      return true;
    } catch (e) {
      debugPrint('Update SaveUserIDsField fail');
      return false;
    }
  }

  Future<bool> deleteUserFromSavedUsers(
      String myUserID, String deletedUserID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('savedUsers')
          .doc(deletedUserID)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCountdownFinished(
      String myUserID, String requestUserID, bool isCountdownFinished) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('transmitted_requests')
          .doc(requestUserID)
          .update({'isCountdownFinished': isCountdownFinished});
      return true;
    } catch (e) {
      debugPrint('Update isCountdownFinished fail');
      return false;
    }
  }

  /// *************** Notification Screen Functions **********************/

  Future<bool> saveNotification(String myUserID, Notifications myNotification) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('notifications')
          .doc(myNotification.notificationID)
          .set(myNotification.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAcceptedField(String myUserID, String notificationID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('notifications')
          .doc(notificationID)
          .update({'didAccepted': true});

      return true;
    } catch (e) {
      debugPrint('Update updateAcceptedField fail');
      return false;
    }
  }

  Future<bool> saveUserToConnections(String myUserID, String requestUserID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .update({"connectionUserIDs": FieldValue.arrayUnion([requestUserID])});
      return true;
    } catch (e) {
      debugPrint('Update SaveUserIDsField fail');
      return false;
    }
  }

  Future<bool> deleteNotificationFromUser(String myUserID, String deletedNotificationID) async {
    try {
      await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('notifications')
          .doc(deletedNotificationID)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Notifications>> getRequestsWithPagination(
      String myUserID,
      Notifications? lastSelectedRequest,
      int numberOfElementsWillBeSelected,
      String requestType) async {
    QuerySnapshot _querySnapshot;

    if (lastSelectedRequest == null) {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('notifications')
          .where('notificationType' , isEqualTo: requestType)
          .orderBy('createdAt', descending: true)
          .limit(numberOfElementsWillBeSelected)
          .get();
    } else {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('notifications')
          .where('notificationType' , isEqualTo: requestType)
          .orderBy('createdAt', descending: true)
          .startAfter([lastSelectedRequest.createdAt])
          .limit(numberOfElementsWillBeSelected)
          .get();
    }

    List<Notifications> _allRequests = [];
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Notifications _currentRequest = Notifications.fromMap(snap.data() as Map<String, dynamic>);
      _allRequests.add(_currentRequest);
    }

    return _allRequests;
  }

  Future<List<Notifications>> getNotificationsWithPagination(
      String myUserID,
      Notifications? lastSelectedRequest,
      int numberOfElementsWillBeSelected) async {
    QuerySnapshot _querySnapshot;

    if (lastSelectedRequest == null) {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(numberOfElementsWillBeSelected)
          .get();
    } else {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .doc(myUserID)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .startAfter([lastSelectedRequest.createdAt])
          .limit(numberOfElementsWillBeSelected)
          .get();
    }

    List<Notifications> _allRequests = [];
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Notifications _currentRequest = Notifications.fromMap(snap.data() as Map<String, dynamic>);
      _allRequests.add(_currentRequest);
    }

    return _allRequests;
  }

  /// ********************************************************************/
}
