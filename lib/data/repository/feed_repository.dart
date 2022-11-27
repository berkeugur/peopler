import 'package:flutter/cupertino.dart';
import 'package:peopler/data/repository/user_repository.dart';

import '../../others/locator.dart';
import '../../others/strings.dart';
import '../model/activity.dart';
import '../model/feed.dart';
import '../model/user.dart';
import '../services/db/firestore_db_service_feeds.dart';
import '../services/db/firestore_db_service_users.dart';

class FeedRepository {
  static const int _numberOfElementsMen = 8;
  static const int _numberOfElementsWomen = 12;

  final FirestoreDBServiceFeeds _firestoreDBServiceFeeds = locator<FirestoreDBServiceFeeds>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  bool _hasMoreKadin = true;
  bool _hasMoreErkek = true;
  bool _hasMoreOther = true;

  Future<List<MyFeed>> getFeedWithPagination(MyFeed? lastFeedListElement, String gender) async {
    int _numberOfElementsWillBeSelected = (gender == 'Kadın') ? (_numberOfElementsWomen) : (_numberOfElementsMen);

    if (gender == 'Kadın') {
      if (_hasMoreKadin == false) return [];
    } else if (gender == 'Erkek'){
      if (_hasMoreErkek == false) return [];
    } else if (gender == 'Diğer'){
      if (_hasMoreOther == false) return [];
    }

    List<MyFeed> feedList = await _firestoreDBServiceFeeds.getFeedWithPagination(lastFeedListElement, _numberOfElementsWillBeSelected, gender);

    if (feedList.length < _numberOfElementsWillBeSelected) {
      if (gender == 'Kadın') {
        _hasMoreKadin = false;
      } else if (gender == 'Erkek') {
        _hasMoreErkek = false;
      } else if (gender == 'Diğer') {
        _hasMoreOther = false;
      }
    }

    if (feedList.isEmpty) return [];

    List<String> deletedUserIDs = [];

    for (int index = 0; index < feedList.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(feedList[index].userID);

      // DİKKAT
      // remove deleted users
      if(_user == null) {
        deletedUserIDs.add(feedList[index].userID);
        continue;
      }

      feedList[index].userDisplayName = _user.displayName;
      feedList[index].userPhotoUrl = _user.profileURL;
      feedList[index].numberOfConnections = _user.connectionUserIDs.length;
    }

    for(String deletedUserID in deletedUserIDs) {
      feedList.removeWhere((element) => element.userID == deletedUserID);
    }

    return feedList;
  }


  Future<bool> deleteFeed(String userID, String feedID) async {
    try {
      await _firestoreDBServiceUsers.deleteFeedIDsField(userID, feedID);
      await _firestoreDBServiceUsers.removeActivity(userID, feedID);
      return await _firestoreDBServiceFeeds.deleteFeed(feedID);
    } catch (e) {
      return false;
    }
  }

  Future<MyFeed?> readFeedWithFeedId(String feedID) async {
    return await _firestoreDBServiceFeeds.readFeed(feedID);
  }

  Future<MyFeed?> addFeed(MyFeed myFeed) async {
    try {
      /// Create Feed
      bool _result = await _firestoreDBServiceFeeds.createFeed(myFeed);

      /// Add Activity
      MyActivity _myActivity = MyActivity();
      _myActivity.feedID = myFeed.feedID;
      _myActivity.activityType = Strings.activityShared;
      _myActivity.liked = myFeed.liked;
      _myActivity.disliked = myFeed.disliked;
      _myActivity.feedExplanation = myFeed.feedExplanation;
      _myActivity.userDisplayName = myFeed.userDisplayName;
      _myActivity.userPhotoUrl = myFeed.userPhotoUrl;
      debugPrint("this activity= ${_myActivity.toMap()}");

      await _firestoreDBServiceUsers.addActivity(myFeed.userID, _myActivity);

      await _firestoreDBServiceUsers.updateFeedIDsField(myFeed.userID, myFeed.feedID);

      /// Read Feed and Return
      if (_result == false) return null;
      return await _firestoreDBServiceFeeds.readFeed(myFeed.feedID);
    } catch(e) {
     return null;
    }
  }

  void restartFeedCache() async {
    _hasMoreErkek = true;
    _hasMoreKadin = true;
    _hasMoreOther = true;
  }
}
