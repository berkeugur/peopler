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

  Future<List<MyFeed>> getFeedWithPagination(MyFeed? lastFeedListElement, String gender) async {
    int _numberOfElementsWillBeSelected = (gender == 'Kadın') ? (_numberOfElementsWomen) : (_numberOfElementsMen);

    if (gender == 'Kadın') {
      if (_hasMoreKadin == false) return [];
    } else {
      if (_hasMoreErkek == false) return [];
    }

    List<MyFeed> feedList = await _firestoreDBServiceFeeds.getFeedWithPagination(lastFeedListElement, _numberOfElementsWillBeSelected, gender);

    if (feedList.length < _numberOfElementsWillBeSelected) {
      if (gender == 'Kadın') {
        _hasMoreKadin = false;
      } else {
        _hasMoreErkek = false;
      }
    }

    if (feedList.isEmpty) return [];

    for (int index=0; index < feedList.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(feedList[index].userID);
      feedList[index].userDisplayName = _user!.displayName;
      feedList[index].userPhotoUrl = _user.profileURL;
      feedList[index].numberOfConnections = _user.connectionUserIDs.length;
    }

    return feedList;
  }

  Future<bool> deleteFeed(String feedID) async {
    return await _firestoreDBServiceFeeds.deleteFeed(feedID);
  }

  Future<MyFeed?> readFeedWithFeedId(String feedID) async {
    return await _firestoreDBServiceFeeds.readFeed(feedID);
  }

  Future<MyFeed?> addFeed(MyFeed myFeed) async {
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

    await _firestoreDBServiceUsers.addActivity(myFeed.userID, _myActivity);

    /// Read Feed and Return
    if (_result == false) return null;
    return await _firestoreDBServiceFeeds.readFeed(myFeed.feedID);
  }

  void restartFeedCache() async {
    _hasMoreErkek = true;
    _hasMoreKadin = true;
  }
}
