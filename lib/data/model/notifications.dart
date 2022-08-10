class Notifications {
  String notificationID = "";
  String notificationType = "";   /// NewFeeds, AddedToSaved, TransmittedRequest, ReceivedRequest, TryOurNewFeature
  String? requestUserID;
  bool? didAccepted;
  int? youAreOnOtherPeoplesListLength;
  int? numberOfNewFeed;
  bool notificationVisible = true;
  DateTime? createdAt;

  /// Below fields does not exists in Firestore, get them through /users collection
  String requestProfileURL = "";
  String requestDisplayName = "";
  String requestBiography = "";

  Notifications(){
    createdAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationID': notificationID,
      'notificationType': notificationType,
      'requestUserID': requestUserID ?? "",
      'didAccepted': didAccepted ?? false,
      'youAreOnOtherPeoplesListLength': youAreOnOtherPeoplesListLength ?? 0,
      'numberOfNewFeed': numberOfNewFeed ?? 0,
      'notificationVisible': notificationVisible,
      'createdAt': createdAt ?? DateTime.now()
    };
  }

  Notifications.fromMap(Map<String, dynamic> map)
      : notificationID = map['notificationID'],
        notificationType = map['notificationType'],
        requestUserID = map['requestUserID'],
        didAccepted = map['didAccepted'],
        youAreOnOtherPeoplesListLength = map['youAreOnOtherPeoplesListLength'],
        numberOfNewFeed = map['numberOfNewFeed'],
        notificationVisible = map['notificationVisible'],
        createdAt = map['createdAt'].toDate();
}
