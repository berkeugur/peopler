import 'package:peopler/data/repository/notification_repository.dart';
import 'package:peopler/data/repository/user_repository.dart';
import 'package:peopler/data/services/db/firestore_db_service_users.dart';
import '../../others/locator.dart';
import '../model/chat.dart';
import '../model/user.dart';
import '../services/db/firebase_db_common.dart';
import '../services/db/firebase_db_service_chat.dart';

class ChatRepository {
  final FirestoreDBServiceChat _firestoreDBServiceChats = locator<FirestoreDBServiceChat>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();
  final UserRepository _userRepository = locator<UserRepository>();
  final FirestoreDBServiceCommon _firestoreDBServiceCommon = locator<FirestoreDBServiceCommon>();

  Stream<List<Chat>> getChatWithStream(String currentUserID) {
    return _firestoreDBServiceChats.getChatWithStream(currentUserID);
  }

  Future<List<Chat>> getChatWithPagination(String currentUserID, Chat? lastSelectedMessage, int numberOfElements) async {
    List<Chat> _allChats = await _firestoreDBServiceChats.getChatWithPagination(currentUserID, lastSelectedMessage, numberOfElements);

    List<String> deletedUserIDs = [];

    for (int index=0; index < _allChats.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(_allChats[index].hostID);

      // DİKKAT
      // remove deleted users
      if(_user == null) {
        deletedUserIDs.add(_allChats[index].hostID);
        await _userRepository.removeConnection(currentUserID, _allChats[index].hostID);
        continue;
      }

      _allChats[index].hostUserName = _user.displayName;
      _allChats[index].hostUserProfileUrl = _user.profileURL;
    }

    for(String deletedUserID in deletedUserIDs) {
      _allChats.removeWhere((element) => element.hostID == deletedUserID);
    }

    return _allChats;
  }

  Future<void> updateIsLastMessageReceivedByHost(String currentUserID, String chatID, bool received) async {
    await _firestoreDBServiceChats.updateIsLastMessageReceivedByHost(currentUserID, chatID, received);
  }

  Future<void> updateIsLastMessageSeenByHost(String currentUserID, String chatID, bool seen) async {
    await _firestoreDBServiceChats.updateIsLastMessageSeenByHost(currentUserID, chatID, seen);
  }

  Future<void> resetNumberOfNotOpenedMessages(String currentUserID, String chatID) async {
    await _firestoreDBServiceChats.resetNumberOfNotOpenedMessages(currentUserID, chatID);
  }

  Future<void> createChat(String currentUserID, Chat chat) async {
    await _firestoreDBServiceChats.createChat(currentUserID, chat);
  }

  Future<void> deleteChat(String currentUserID, String hostID) async {
    /// Delete all messages
    await _firestoreDBServiceCommon.deleteNestedSubCollections("users/" + currentUserID + "/chats/" + hostID + "/messages");

    /// Delete chat
    await _firestoreDBServiceChats.deleteChat(currentUserID, hostID);
  }
}
