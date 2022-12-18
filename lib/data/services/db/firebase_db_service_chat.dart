import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peopler/business_logic/blocs/NotificationBloc/bloc.dart';
import 'package:peopler/data/model/notifications.dart';
import '../../model/chat.dart';

class FirestoreDBServiceChat {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Future<List<Chat>> getChatWithPagination(String currentUserID, Chat? lastSelectedChat, int numberOfElementsWillBeSelected) async {
    QuerySnapshot _querySnapshot;
    List<Chat> _allChats = [];

    if (lastSelectedChat == null) {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .doc(currentUserID)
          .collection("chats")
          .orderBy("lastMessageCreatedAt", descending: true)
          .limit(numberOfElementsWillBeSelected)
          .get();
    } else {
      _querySnapshot = await _firebaseDB
          .collection('users')
          .doc(currentUserID)
          .collection("chats")
          .orderBy("lastMessageCreatedAt", descending: true)
          .startAfter([lastSelectedChat.lastMessageCreatedAt])
          .limit(numberOfElementsWillBeSelected)
          .get();
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Chat _chat = Chat.fromMap(snap.data() as Map<String, dynamic>);
      _allChats.add(_chat);
    }

    return _allChats;
  }

  Stream<List<Chat>> getChatWithStream(String currentUserID) {
    var snapShot =
        _firebaseDB.collection('users').doc(currentUserID).collection("chats").orderBy("lastMessageCreatedAt", descending: true).limit(1).snapshots();

    return snapShot.map(
        // Convert Stream<docs> to Stream<List<Object>>
        (chatList) => chatList.docs.map(
            // Convert Stream<List<Object>> to Stream<List<Chat>>
            (chat) => Chat.fromMap(chat.data())).toList());
  }

  Future<DateTime?> getLastMessageCreatedAt(String currentUserID) async {
    var snapShot =
        await _firebaseDB.collection('users').doc(currentUserID).collection("chats").orderBy("lastMessageCreatedAt", descending: true).limit(1).get();

    for (DocumentSnapshot snap in snapShot.docs) {
      Chat chat = Chat.fromMap(snap.data() as Map<String, dynamic>);
      return chat.lastMessageCreatedAt;
    }

    return null;
  }

  Future<DateTime?> getLastNotificationCreatedAt(String currentUserID) async {
    var snapShot =
        await _firebaseDB.collection('users').doc(currentUserID).collection("notifications").orderBy("createdAt", descending: true).limit(1).get();

    for (DocumentSnapshot snap in snapShot.docs) {
      Notifications notification = Notifications.fromMap(snap.data() as Map<String, dynamic>);
      return notification.createdAt;
    }

    return null;
  }

  Future<void> updateIsLastMessageReceivedByHost(String currentUserID, String hostID, bool received) async {
    _firebaseDB.collection('users').doc(currentUserID).collection("chats").doc(hostID).update({'isLastMessageReceivedByHost': received});
  }

  Future<void> updateIsLastMessageSeenByHost(String currentUserID, String hostID, bool seen) async {
    _firebaseDB.collection('users').doc(currentUserID).collection("chats").doc(hostID).update({'isLastMessageSeenByHost': seen});
  }

  Future<void> updateChat(String currentUserID, Chat chat) async {
    _firebaseDB.collection('users').doc(currentUserID).collection("chats").doc(chat.hostID).update(chat.toMap());
  }

  Future<int> readNumberOfNewMessages(String currentUserID, String hostID) async {
    DocumentSnapshot _hostChat = await _firebaseDB.collection('users').doc(currentUserID).collection("chats").doc(hostID).get();
    if (_hostChat.data() == null) {
      return 0;
    } else {
      Map<String, dynamic> _hostMap = _hostChat.data() as Map<String, dynamic>;
      return _hostMap['numberOfMessagesThatIHaveNotOpened'];
    }
  }

  Future<void> resetNumberOfNotOpenedMessages(String currentUserID, String hostID) async {
    _firebaseDB.collection('users').doc(currentUserID).collection("chats").doc(hostID).update({'numberOfMessagesThatIHaveNotOpened': 0});
  }

  Future<bool> createChat(String currentUserID, Chat chat) async {
    try {
      await _firebaseDB.collection('users').doc(currentUserID).collection('chats').doc(chat.hostID).set(chat.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteChat(String currentUserID, String otherUserID) async {
    try {
      await _firebaseDB.collection('users').doc(currentUserID).collection('chats').doc(otherUserID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
