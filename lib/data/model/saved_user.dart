class SavedUser {
  String userID = "";
  DateTime? createdAt;
  int countDownDurationMinutes = 1440; // 24 hour
  bool isCountdownFinished = false;

  /// Below fields does not exists in Firestore, get them through /users collection
  String displayName = "";
  String profileURL = "";
  String biography = "";
  String gender = "";
  String pplName = "";
  List<dynamic> hobbies = [];

  SavedUser() {
    createdAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'createdAt': createdAt ?? DateTime.now(),
      'countDownDurationMinutes': countDownDurationMinutes,
      'isCountdownFinished': isCountdownFinished,
    };
  }

  SavedUser.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        createdAt = map['createdAt'].toDate(),
        countDownDurationMinutes = map['countDownDurationMinutes'],
        isCountdownFinished = map['isCountdownFinished'];
}
