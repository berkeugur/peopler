import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/feed.dart';
import 'package:peopler/data/repository/location_repository.dart';
import 'package:peopler/data/services/db/firebase_db_common.dart';
import 'package:peopler/data/services/db/firebase_db_service_chat.dart';
import 'package:peopler/data/services/db/firebase_db_service_location.dart';
import 'package:peopler/data/services/db/firestore_db_service_feeds.dart';
import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../others/locator.dart';
import '../model/user.dart';
import '../services/auth/firebase_auth_service.dart';
import '../services/db/firestore_db_service_users.dart';
import '../services/storage/firebase_storage_service.dart';
import 'dart:io' as i;

class UserRepository {
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();
  final FirestoreDBServiceFeeds _firestoreDBServiceFeeds = locator<FirestoreDBServiceFeeds>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  final FirestoreDBServiceCommon _firestoreDBServiceCommon = locator<FirestoreDBServiceCommon>();
  final FirestoreDBServiceLocation _firestoreDBServiceLocation = locator<FirestoreDBServiceLocation>();
  final FirestoreDBServiceChat _firestoreDBServiceChat = locator<FirestoreDBServiceChat>();
  final LocationRepository _locationRepository = locator<LocationRepository>();


  Future<MyUser?> getCurrentUser() async {
    MyUser? currentUser = await _firebaseAuthService.getCurrentUser();

    if (currentUser == null) return null;
    return await _firestoreDBServiceUsers.readUserPrivileged(currentUser.userID);
  }

  Stream<MyUser> getMyUserWithStream(String userID) {
    return _firestoreDBServiceUsers.readMyUserWithStream(userID);
  }

  Future<MyUser?> getUserWithUserId(String userID) async {
    MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(userID);
    if (_user != null) {
      return _user;
    } else {
      debugPrint('There is no user with this user id');
      return null;
    }
  }

  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  Future<MyUser?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      MyUser? currentUser = await _firebaseAuthService.createUserWithEmailAndPassword(email, password);

      if (currentUser == null) {
        debugPrint('User not created so it cannot be stored');
        return null;
      }

      bool _result = await _firestoreDBServiceUsers.saveUser(currentUser);
      if (_result == false) {
        debugPrint('User created but cannot stored');
        return null;
      }

      return await _firestoreDBServiceUsers.readUserPrivileged(currentUser.userID);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> saveUserToCityCollection(String userID, String city) async {
    try {

      int? lastArr = await _firestoreDBServiceUsers.readCity(city);

      /// If there is no city document named city
      if(lastArr == null) {
        /// Create a city and set lastArr to 0
        await _firestoreDBServiceUsers.setCity(userID, city);

        /// Create an arr0 document and register userID to there
        await _firestoreDBServiceUsers.setArrUser(userID, city, 0);

        /// Set arr field in user document
        await _firestoreDBServiceUsers.setArrFieldInUser(userID, 0);
        return true;
      }

      List<String>? users = await _firestoreDBServiceUsers.readArrayUsers(city, lastArr);
      /// If the length of users registered in last_arr document is smaller than 100
      if (users.length < 100) {
        /// Update existing arr[x] document by adding userID
        await _firestoreDBServiceUsers.updateArrUser(userID, city, lastArr);

        /// Set arr field in user document
        await _firestoreDBServiceUsers.setArrFieldInUser(userID, lastArr);
        return true;
      }

      /// Create a new arr[x] document
      lastArr = lastArr + 1;
      /// Update lastArr + 1 in city document
      await _firestoreDBServiceUsers.updateCity(userID, city);

      /// Create new arr[x] document and add userID
      await _firestoreDBServiceUsers.setArrUser(userID, city, lastArr);

      /// Set arr field in user document
      await _firestoreDBServiceUsers.setArrFieldInUser(userID, lastArr);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeUserToCityCollection(String userID, String city) async {
    try {
      /// Change city
      await _firestoreDBServiceUsers.updateUserCityAtDatabase(userID, city);

      /// Delete user from city collection
      await _firestoreDBServiceUsers.removeArrUser(UserBloc.user!.userID, UserBloc.user!.city, UserBloc.user!.city_arr);

      return await saveUserToCityCollection(userID, city);
    } catch (e) {
      return false;
    }
  }

  Future<MyUser?> signInWithLinkedIn(String customToken) async {
    try {
      MyUser? currentUser = await _firebaseAuthService.signInWithCustomToken(customToken);

      if (currentUser == null) {
        debugPrint('User not created so it cannot be stored');
        return null;
      }

      MyUser? _userResult = await _firestoreDBServiceUsers.readUserPrivileged(currentUser.userID);
      if (_userResult != null) {
        debugPrint('User exists so return existing user');
        return _userResult;
      }

      bool _result = await _firestoreDBServiceUsers.saveUser(currentUser);
      if (_result == false) {
        debugPrint('User created but cannot stored');
        return null;
      }

      return await _firestoreDBServiceUsers.readUserPrivileged(currentUser.userID);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuthService.sendEmailVerification();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> listenForEmailVerification() {
    return _firebaseAuthService.listenForEmailVerification();
  }

  Future<MyUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      MyUser? currentUser = await _firebaseAuthService.signInWithEmailAndPassword(email, password);

      if (currentUser == null) return null;
      updateAccountConfirmed(currentUser.userID, currentUser.isTheAccountConfirmed);
      return await _firestoreDBServiceUsers.readUserPrivileged(currentUser.userID);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateAccountConfirmed(String userID, bool newAccountConfirmed) async {
    return await _firestoreDBServiceUsers.updateAccountConfirmed(userID, newAccountConfirmed);
  }

  Future<bool> updateUser(MyUser myUser) async {
    myUser.updatedAt = DateTime.now();
    return await _firestoreDBServiceUsers.updateUser(myUser);
  }

  Future<String> uploadFile(String userID, String fileType, String fileName, i.File profilePhoto) async {
    // File type is type of dart:io not dart:html
    String _filePath = userID + "/" + fileType;
    String profilePhotoURL = await _firebaseStorageService.uploadFile(_filePath, fileName, profilePhoto);
    return profilePhotoURL;
  }

  Future<void> updateProfilePhoto(String? userID, String? profilePhotoURL) async {
    await _firestoreDBServiceUsers.updateProfilePhoto(userID, profilePhotoURL);
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuthService.resetPassword(email);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addLikedDislikedFeed(String userID, String feedID, String type) async {
    await _firestoreDBServiceUsers.addLikedDislikedFeed(userID, feedID, type);
    await _firestoreDBServiceFeeds.incrementLikedDisliked(feedID, type);

    MyFeed? _feed = await _firestoreDBServiceFeeds.readFeed(feedID);

    MyActivity _myActivity = MyActivity();
    _myActivity.feedID = feedID;
    _myActivity.activityType = type;
    _myActivity.liked = _feed!.liked;
    _myActivity.disliked = _feed.disliked;
    _myActivity.feedExplanation = _feed.feedExplanation;

    await _firestoreDBServiceUsers.addActivity(userID, _myActivity);
  }

  Future<void> removeLikedDislikedFeed(String userID, String feedID, String type) async {
    await _firestoreDBServiceUsers.removeLikedDislikedFeed(userID, feedID, type);
    await _firestoreDBServiceFeeds.decrementLikedDisliked(feedID, type);

    await _firestoreDBServiceUsers.removeActivity(userID, feedID);
  }

  Future<List<MyActivity>> getActivities(String userID) async {
    return await _firestoreDBServiceUsers.getActivities(userID);
  }

  Future<bool?> isLikedOrDislikedByUser(String userID, String feedID) async {
    return await _firestoreDBServiceUsers.isLikedOrDislikedByUser(userID, feedID);
  }

  Future<bool> deleteToken(String userID) async {
    return await _firestoreDBServiceUsers.deleteToken(userID);
  }

  Future<void> deleteUser(MyUser myUser, {String? password}) async {
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + myUser.userID + "/activities");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + myUser.userID + "/notifications");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + myUser.userID + "/liked");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + myUser.userID + "/disliked");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + myUser.userID + "/savedUsers");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + myUser.userID + "/private");

    /// Delete all messages
    List<String> chatIDList = await _firestoreDBServiceCommon.getAllDocumentIDs("users/" + myUser.userID + "/chats");
    for (String chatID in chatIDList) {
      await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + myUser.userID + "/chats/" + chatID + "/messages");
    }

    /// Delete all chats after messages (subcollections of chats) deleted
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + myUser.userID + "/chats");

    /// Delete user from his/her last regions
    List<String> regions = _locationRepository.determineRegionList(myUser.latitude, myUser.longitude);
    for (String region in regions) {
      _firestoreDBServiceLocation.deleteUserFromRegion(myUser.userID, region);
    }

    /// Delete user from city collection
    await _firestoreDBServiceUsers.removeArrUser(myUser.userID, myUser.city, myUser.city_arr);

    /// Delete user from firestore
    await _firestoreDBServiceUsers.deleteUser(myUser.userID);

    /// Delete userID's folder from Storage
    await _firebaseStorageService.deleteFolder(myUser.userID);

    await _firestoreDBServiceUsers.deleteToken(myUser.userID);

    /// Sign-in recently is required to delete user
    if(password != null) {
      await _firebaseAuthService.signInWithEmailAndPassword(myUser.email, password);
    } else {
      String? customToken = await _firebaseAuthService.recreateCustomToken(myUser.email);
      await _firebaseAuthService.signInWithCustomToken(customToken!);
    }

    /// Following command must be the last one because without authentication, Firebase is inaccessible.
    /// Delete user from firebase authentication
    await _firebaseAuthService.deleteUser();

    UserBloc.user = null;
  }

  Future<void> removeConnection(String myUserID, String otherUserID) async {
    /// Delete notifications
    await _firestoreDBServiceUsers.deleteNotificationFromUser(myUserID, otherUserID);
    await _firestoreDBServiceUsers.deleteNotificationFromUser(otherUserID, myUserID);

    /// Delete messages
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + myUserID + "/chats/" + otherUserID + "/messages");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + otherUserID + "/chats/" + myUserID + "/messages");

    /// Delete Chat
    await _firestoreDBServiceChat.deleteChat(myUserID, otherUserID);
    await _firestoreDBServiceChat.deleteChat(otherUserID, myUserID);

    /// Delete connectionID
    await _firestoreDBServiceUsers.deleteUserFromConnections(myUserID, otherUserID);
    await _firestoreDBServiceUsers.deleteUserFromConnections(otherUserID, myUserID);
  }

  Future<void> blockUser(String myUserID, String otherUserID) async {
    /// Remove from saved users for me
    _firestoreDBServiceUsers.deleteUserFromSavedUsers(myUserID, otherUserID);
    _firestoreDBServiceUsers.deleteSaveUserIDsField(myUserID, otherUserID);

    /// Remove from saved users for otherUser
    _firestoreDBServiceUsers.deleteUserFromSavedUsers(otherUserID, myUserID);
    _firestoreDBServiceUsers.deleteSaveUserIDsField(otherUserID, myUserID);

    /// Remove connection
    removeConnection(myUserID, otherUserID);

    /// Update blockedUsers for you and whoBlockedYou for requestUser
    await _firestoreDBServiceUsers.updateBlockedUsers(myUserID, otherUserID);
    await _firestoreDBServiceUsers.updateWhoBlockedYou(otherUserID, myUserID);
  }

  Future<void> unblockUser(String myUserID, String otherUserID) async {
    /// Update blockedUsers for you and whoBlockedYou for requestUser
    await _firestoreDBServiceUsers.deleteFromBlockedUsers(myUserID, otherUserID);
    await _firestoreDBServiceUsers.deleteFromWhoBlockedYou(otherUserID, myUserID);
  }
}
