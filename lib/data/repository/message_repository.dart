import '../../others/locator.dart';
import '../model/chat.dart';
import '../model/message.dart';
import '../services/db/firebase_db_service_chat.dart';
import '../services/db/firebase_db_service_message.dart';

class MessageRepository {

  final FirestoreDBServiceMessage _firestoreDBServiceMessage = locator<FirestoreDBServiceMessage>();
  final FirestoreDBServiceChat _firestoreDBServiceChat = locator<FirestoreDBServiceChat>();

  Stream<List<Message>> getMessages(String currentUserID, String chatID) {
    return _firestoreDBServiceMessage.getMessages(currentUserID, chatID);
  }

  Future<bool> saveMessage(Message message) async {
    String currentUserID = message.from;
    String hostUserID = message.to;

    /// Create a new messageID
    String messageID = await _firestoreDBServiceMessage.createNewMessageID(currentUserID, hostUserID);
    message.messageID = messageID;

    /// OWNER CHANGES
    // Save new message to doc(owner's chat) -> subcollections(messages)
    await _firestoreDBServiceMessage.saveMessage(currentUserID, hostUserID, messageID, message);

    // Update owner chat's lastMessage, lastMessageCreatedAt, isLastMessageFromMe fields.
    Chat _ownerChat = Chat(
        hostID: message.to,
        isLastMessageFromMe: true,              // It means owner wrote the message
        isLastMessageReceivedByHost: false,     // Since the message sent yet, message assumed not to be received by host at t=0
        isLastMessageSeenByHost: false,         // Since the message sent yet, message assumed not to be seen by host at t=0
        lastMessageCreatedAt: DateTime.now(),
        lastMessage: message.message,
        numberOfMessagesThatIHaveNotOpened: 0   // 0 because if I have sent a message, that means I have opened messages screen and read all the messages from host
    );
    await _firestoreDBServiceChat.updateChat(currentUserID, _ownerChat);

    /// HOST CHANGES
    message.isFromMe = false;

    // Save new message to doc(host's chat) -> subcollections(messages)
    await _firestoreDBServiceMessage.saveMessage(hostUserID, currentUserID, messageID, message);

    // Read host's number of new messages field of chat
    int _hostNumberOfNewMessages = await _firestoreDBServiceChat.readNumberOfNewMessages(hostUserID, currentUserID);

    // Update host chat's lastMessage, lastMessageCreatedAt, isLastMessageFromMe fields.
    Chat _hostChat = Chat(
        hostID: message.from,
        isLastMessageFromMe: false,
        isLastMessageReceivedByHost: false,     // This field does not matter, because in host's phone chat screen, owner's message is seen as last message
        isLastMessageSeenByHost: false,         // This field does not matter, because in host's phone chat screen, owner's message is seen as last message
        lastMessageCreatedAt: DateTime.now(),
        lastMessage: message.message,
        numberOfMessagesThatIHaveNotOpened: _hostNumberOfNewMessages + 1   // 0 because if I have sent a message, that means I have opened messages screen and read all the messages from host
    );
    await _firestoreDBServiceChat.updateChat(hostUserID, _hostChat);

    return true;
    /*
    if (dbWriteProcess) {
      var token = "";
      if (kullaniciToken.containsKey(message.kime)) {
        token = kullaniciToken[message.kime];
        //print("Localden geldi:" + token);
      } else {
        token = await _firestoreDBService.tokenGetir(message.to);
        if (token != null) kullaniciToken[message.to] = token;
        //print("Veri tabanından geldi:" + token);
      }

      if (token != null)
        await _bildirimGondermeServis.bildirimGonder(
            message, currentUser, token);

      return true;
    } else
      return false;
     */
  }

  Future<List<Message>> getMessageWithPagination(String currentUserID,
      String hostUserID, Message? lastSelectedMessage, int numberOfElements) async {
    return await _firestoreDBServiceMessage.getMessageWithPagination(currentUserID, hostUserID, lastSelectedMessage, numberOfElements);
  }
}
