import 'package:peopler/data/services/db/firestore_db_service_users.dart';
import '../../others/locator.dart';
import '../model/chat.dart';
import '../model/user.dart';
import '../services/db/firebase_db_service_chat.dart';

class ChatRepository {
  final FirestoreDBServiceChat _firestoreDBServiceChats = locator<FirestoreDBServiceChat>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  Stream<List<Chat>> getChatWithStream(String currentUserID) {
    return _firestoreDBServiceChats.getChatWithStream(currentUserID);
  }

  Future<List<Chat>> getChatWithPagination(String currentUserID, Chat? lastSelectedMessage, int numberOfElements) async {
    List<Chat> _allChats = await _firestoreDBServiceChats.getChatWithPagination(currentUserID, lastSelectedMessage, numberOfElements);

    for (int index=0; index < _allChats.length; index++) {
      MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(_allChats[index].hostID);
      _allChats[index].hostUserName = _user!.displayName;
      _allChats[index].hostUserProfileUrl = _user.profileURL;
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
}
