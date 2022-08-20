class MyReport {
  String reportID = "";
  String userID = "";
  String type = "";

  late final DateTime createdAt;
  late final DateTime? updatedAt;

  /// If a feed reported, below fields are initialized
  String? feedID;
  String? feedExplanation;

  MyReport({
    required this.userID,
    required this.type,
    this.feedID,
    this.feedExplanation
  }) {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'reportID': reportID,
      'userID': userID,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'feedID': feedID ?? "",
      'feedExplanation': feedExplanation ?? "",
    };
  }

  MyReport.fromMap(Map<String, dynamic> map)
      : reportID = map['reportID'],
        userID = map['userID'],
        type = map['type'],
        createdAt = map['createdAt'].toDate(),
        updatedAt = map['updatedAt'].toDate(),
        feedID = map['feedID'],
        feedExplanation = map['feedExplanation'];
}
