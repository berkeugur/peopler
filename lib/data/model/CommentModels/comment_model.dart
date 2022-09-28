import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peopler/data/model/CommentModels/sub_comment_model.dart';

class Comment {
  String? comment;
  String? commentID;
  int? liked;
  int? disliked;
  String? fromUserID;
  Timestamp? createdAt;

  Comment({
    this.comment,
    this.commentID,
    this.liked,
    this.disliked,
    this.fromUserID,
    this.createdAt,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    commentID = json['commentID'];
    liked = json['liked'];
    disliked = json['disliked'];
    fromUserID = json['fromUserID'];
    createdAt = json['createdAt'] as Timestamp;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['commentID'] = commentID;
    data['liked'] = liked;
    data['disliked'] = disliked;
    data['fromUserID'] = fromUserID;
    data['createdAt'] = createdAt as Timestamp;

    return data;
  }
}
