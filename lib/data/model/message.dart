class Message {
  String messageID = "";
  final String from;
  final String to;
  late  bool isFromMe;
  bool isReceived;
  bool isSeen;
  final String message;
  late final DateTime createdAt;

  Message(
      {
      required this.from,
      required this.to,
      required this.isFromMe,
      required this.isReceived,
      required this.isSeen,
      required this.message}) {
    createdAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'from': from,
      'to': to,
      'isFromMe': isFromMe,
      'isReceived': isReceived,
      'isSeen': isSeen,
      'message': message,
      'createdAt': createdAt,
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : messageID = map['messageID'],
        from = map['from'],
        to = map['to'],
        isFromMe = map['isFromMe'],
        isReceived = map['isReceived'],
        isSeen = map['isSeen'],
        message = map['message'],
        createdAt = map['createdAt'].toDate();

  /*
  @override
  String toString() {
    return 'Message{from: $from, to: $to, isFromMe: $isFromMe, message: $message, createdAt: $createdAt}';
  }
   */
}
