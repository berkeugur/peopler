import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:peopler/data/model/feed.dart';

class FirestoreDBServiceFeeds {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Future<List<MyFeed>> getFeedWithPagination(MyFeed? lastSelectedEvent,
      int numberOfElementsWillBeSelected, String gender) async {
    QuerySnapshot _querySnapshot;

    if (lastSelectedEvent == null) {
      _querySnapshot = await _firebaseDB
          .collection('feeds')
          .where('userGender', isEqualTo: gender)
          .orderBy('createdAt', descending: true)
          .limit(numberOfElementsWillBeSelected)
          .get();
    } else {
      _querySnapshot = await _firebaseDB
          .collection('feeds')
          .where('userGender', isEqualTo: gender)
          .orderBy('createdAt', descending: true)
          .startAfter([lastSelectedEvent.createdAt])
          .limit(numberOfElementsWillBeSelected)
          .get();
    }

    List<MyFeed> _allFeeds = [];
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      MyFeed _currentEvent = MyFeed.fromMap(snap.data() as Map<String, dynamic>);
      _allFeeds.add(_currentEvent);
    }

    return _allFeeds;
  }

  Future<MyFeed?> readFeed(String feedID) async {
    DocumentSnapshot documentSnapshot = await _firebaseDB.collection('feeds').doc(feedID).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> _readEventMap =
          documentSnapshot.data() as Map<String, dynamic>;
      return MyFeed.fromMap(_readEventMap);
    } else {
      debugPrint('Document does not exist on the database');
    }
    return null;
  }

  Future<bool> createFeed(MyFeed feed) async {
    String _feedID = _firebaseDB
        .collection('feeds')
        .doc()
        .id; // Free feed document created with ID.
    feed.feedID = _feedID;

    try {
      await _firebaseDB.collection('feeds').doc(feed.feedID).set(feed.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFeed(String feedID) async {
    try {
      await _firebaseDB.collection('feeds').doc(feedID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> incrementLikedDisliked(String feedID, String type) async {
    try {
      await _firebaseDB
          .collection('feeds')
          .doc(feedID)
          .update({type: FieldValue.increment(1)});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> decrementLikedDisliked(String feedID, String type) async {
    try {
      await _firebaseDB
          .collection('feeds')
          .doc(feedID)
          .update({type: FieldValue.increment(-1)});
      return true;
    } catch (e) {
      return false;
    }
  }
}
