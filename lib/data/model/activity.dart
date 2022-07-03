class MyActivity {
  String feedID = "";
  String activityType = "";
  DateTime? createdAt;
  int liked = 0;
  int disliked = 0;
  String feedExplanation = "";
  String userDisplayName = "";
  String userPhotoUrl = "";

  MyActivity() {
    createdAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'feedID': feedID,
      'activityType': activityType,
      'createdAt': createdAt,
      'liked': liked,
      'disliked': disliked,
      'feedExplanation': feedExplanation,
      'userDisplayName': userDisplayName,
      'userPhotoUrl': userPhotoUrl
    };
  }

  MyActivity.fromMap(Map<String, dynamic> map)
      : feedID = map['feedID'],
        activityType = map['activityType'],
        createdAt = map['createdAt'].toDate(),
        liked = map['liked'],
        disliked = map['disliked'],
        feedExplanation = map['feedExplanation'],
        userDisplayName = map['userDisplayName'],
        userPhotoUrl = map['userPhotoUrl'];
}
