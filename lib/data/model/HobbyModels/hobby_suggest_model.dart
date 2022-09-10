class HobbySuggestion {
  String? suggest;
  String? createdDate;
  String? fromUserID;
  String? primaryHobby;

  HobbySuggestion({this.suggest, this.createdDate, this.fromUserID, this.primaryHobby});

  HobbySuggestion.fromJson(Map<String, dynamic> json) {
    suggest = json['suggest'];
    createdDate = json['createdDate'];
    fromUserID = json['fromUserID'];
    primaryHobby = json['primaryHobby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['suggest'] = suggest;
    data['createdDate'] = createdDate;
    data['fromUserID'] = fromUserID;
    data['primaryHobby'] = primaryHobby;
    return data;
  }
}
