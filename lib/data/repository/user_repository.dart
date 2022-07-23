import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/feed.dart';
import 'package:peopler/data/services/db/firebase_db_common.dart';
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
  final FirestoreDBServiceLocation _firestoreDBServiceLocation= locator<FirestoreDBServiceLocation>();

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

      if (currentUser != null) {
        bool _result = await _firestoreDBServiceUsers.saveUser(currentUser);
        if (_result) {
          return await _firestoreDBServiceUsers.readUserPrivileged(currentUser.userID);
        } else {
          debugPrint('User created but cannot stored');
          return null;
        }
      } else {
        debugPrint('User not created so it cannot be stored');
        return null;
      }
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

  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      MyUser? currentUser = await _firebaseAuthService.signInWithEmailandPassword(email, password);

      if (currentUser == null) return null;
      updateAccountConfirmed(currentUser.userID, currentUser.isTheAccountConfirmed);
      return await _firestoreDBServiceUsers.readUserPrivileged(currentUser.userID);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<MyUser?> signInWithLinkedIn(String customToken) async {
    try {
      MyUser? currentUser = await _firebaseAuthService.signInWithCustomToken(customToken);

      if (currentUser != null) {
        MyUser? _result = await _firestoreDBServiceUsers.readUserPrivileged(currentUser.userID);
        if (_result != null) {
          return _result;
        } else {
          await _firestoreDBServiceUsers.saveUser(currentUser);
          return await _firestoreDBServiceUsers.readUserPrivileged(currentUser.userID);
        }
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
    return null;
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

  Future<void> updateProfilePhoto(String userID, String profilePhotoURL) async {
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

  Future<void> deleteUser(String userID, String region) async {
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + userID + "/activities");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + userID + "/notifications");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + userID + "/liked");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + userID + "/disliked");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + userID + "/savedUsers");
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + userID + "/private");

    /// Delete all messages
    List<String> chatIDList = await _firestoreDBServiceCommon.getAllDocumentIDs("users/" + userID + "/chats");
    for (String chatID in chatIDList) {
      await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + userID + "/chats/" + chatID + "/messages");
    }

    /// Delete all chats after messages (subcollections of chats) deleted
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + userID + "/chats");

    /// Delete user from his/her last region
    _firestoreDBServiceLocation.deleteUserFromRegion(userID, region);

    /// Delete user from firestore
    await _firestoreDBServiceUsers.deleteUser(userID);

    /// Delete userID's folder from Storage
    await _firebaseStorageService.deleteFolder(userID);

    await _firestoreDBServiceUsers.deleteToken(userID);

    /// Following command must be the last one because without authentication, Firebase is inaccessible.
    /// Delete user from firebase authentication
    await _firebaseAuthService.deleteUser();

    UserBloc.user = null;
  }
}
