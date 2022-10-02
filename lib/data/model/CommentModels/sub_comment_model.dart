class SubComment {
  String? comment;
  int? liked;
  int? disliked;
  String? fromUserID;
  String? fromUserPhotoURL;
  String? fromUserDisplayName;
  bool? fromUserProfileVisiable;
  String? taggedUserID;
  String? taggedUserDisplayName;

  SubComment(
      {this.comment,
      this.liked,
      this.disliked,
      this.fromUserID,
      this.fromUserPhotoURL,
      this.fromUserDisplayName,
      this.fromUserProfileVisiable,
      this.taggedUserID,
      this.taggedUserDisplayName});

  SubComment.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    liked = json['liked'];
    disliked = json['disliked'];
    fromUserID = json['fromUserID'];
    fromUserPhotoURL = json['fromUserPhotoURL'];
    fromUserDisplayName = json['fromUserDisplayName'];
    fromUserProfileVisiable = json['fromUserProfileVisiable'];
    taggedUserID = json['taggedUserID'];
    taggedUserDisplayName = json['taggedUserDisplayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['liked'] = liked;
    data['disliked'] = disliked;
    data['fromUserID'] = fromUserID;
    data['fromUserPhotoURL'] = fromUserPhotoURL;
    data['fromUserDisplayName'] = fromUserDisplayName;
    data['fromUserProfileVisiable'] = fromUserProfileVisiable;
    data['taggedUserID'] = taggedUserID;
    data['taggedUserDisplayName'] = taggedUserDisplayName;
    return data;
  }
}
