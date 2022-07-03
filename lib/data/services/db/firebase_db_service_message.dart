import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/message.dart';

class FirestoreDBServiceMessage {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages(String currentUserID, String hostUserID) {
    var snapShot = _firebaseDB
        .collection('users')
        .doc(currentUserID)
        .collection("chats")
        .doc(hostUserID)
        .collection("messages")
        .where("from", isEqualTo: hostUserID)
        .orderBy("createdAt", descending: true)
        .limit(1)
        .snapshots();
    return snapShot.map((messageList) => messageList.docs.map((message) => Message.fromMap(message.data())).toList());
  }


  Future<String> createNewMessageID(String currentUserID, String hostUserID) async {
    // Create new message with id
    return _firebaseDB
        .collection('users')
        .doc(currentUserID)
        .collection("chats")
        .doc(hostUserID)
        .collection('messages')
        .doc()
        .id;
  }

  Future<bool> saveMessage(String currentUserID, String hostUserID, String messageID, Message message) async {
    // Write new message to database
    await _firebaseDB
        .collection('users')
        .doc(currentUserID)
        .collection("chats")
        .doc(hostUserID)
        .collection("messages")
        .doc(messageID)
        .set(message.toMap());

    return true;
  }

  Future<List<Message>> getMessageWithPagination(String currentUserID, String hostUserID, Message? lastSelectedMessage, int numberOfElementsWillBeSelected) async {
    QuerySnapshot _querySnapshot;
    List<Message> _allMessages = [];

    if (lastSelectedMessage == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID)
          .collection("chats")
          .doc(hostUserID)
          .collection("messages")
          .orderBy("createdAt", descending: true)
          .limit(numberOfElementsWillBeSelected)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID)
          .collection("chats")
          .doc(hostUserID)
          .collection("messages")
          .orderBy("createdAt", descending: true)
          .startAfter([lastSelectedMessage.createdAt])
          .limit(numberOfElementsWillBeSelected)
          .get();
    }

    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Message _message = Message.fromMap(snap.data() as Map<String, dynamic>);
      _allMessages.add(_message);
    }

    return _allMessages;
  }

}
