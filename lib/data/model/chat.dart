class Chat {
  final String hostID;
  bool isLastMessageFromMe;
  bool isLastMessageReceivedByHost;
  bool isLastMessageSeenByHost;
  DateTime lastMessageCreatedAt;
  String lastMessage;
  int numberOfMessagesThatIHaveNotOpened;

  /// Below fields does not exists in Firestore, get them through /users collection
  String hostUserProfileUrl = "";
  String hostUserName = "";

  Chat(
      {
      required this.hostID,
      required this.isLastMessageFromMe,
      required this.isLastMessageReceivedByHost,
      required this.isLastMessageSeenByHost,
      required this.lastMessageCreatedAt,
      required this.lastMessage,
      required this.numberOfMessagesThatIHaveNotOpened});

  Map<String, dynamic> toMap() {
    return {
      'hostID': hostID,
      'isLastMessageFromMe': isLastMessageFromMe,
      'isLastMessageReceivedByHost': isLastMessageReceivedByHost,
      'isLastMessageSeenByHost': isLastMessageSeenByHost,
      'lastMessageCreatedAt': lastMessageCreatedAt,
      'lastMessage': lastMessage,
      'numberOfMessagesThatIHaveNotOpened': numberOfMessagesThatIHaveNotOpened,
    };
  }

  Chat.fromMap(Map<String, dynamic> map)
      :
        hostID = map['hostID'],
        isLastMessageFromMe = map['isLastMessageFromMe'],
        isLastMessageReceivedByHost = map['isLastMessageReceivedByHost'],
        isLastMessageSeenByHost = map['isLastMessageSeenByHost'],
        lastMessageCreatedAt = map['lastMessageCreatedAt'].toDate(),
        lastMessage = map['lastMessage'],
        numberOfMessagesThatIHaveNotOpened = map['numberOfMessagesThatIHaveNotOpened'];
}
