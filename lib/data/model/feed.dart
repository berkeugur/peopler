class MyFeed {
  late final String feedID;
  late final String userID;
  String feedExplanation = '';
  late final String userGender;
  late final DateTime createdAt;
  DateTime? updatedAt;
  int liked = 0;
  int disliked = 0;

  /// Below fields does not exists in Firestore, get them through /users collection
  int numberOfConnections = 0;
  String userPhotoUrl = "";
  String userDisplayName = "";

  MyFeed({
    required this.userID,
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'feedID': feedID,
      'userID': userID,
      'feedExplanation': feedExplanation,
      'userGender': userGender,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'liked': liked,
      'disliked': disliked,
    };
  }

  MyFeed.fromMap(Map<String, dynamic> map)
      : feedID = map['feedID'],
        userID = map['userID'],
        feedExplanation = map['feedExplanation'],
        userGender = map['userGender'],
        createdAt = map['createdAt'].toDate(),
        updatedAt = map['updatedAt'].toDate(),
        liked = map['liked'],
        disliked = map['disliked'];
}
