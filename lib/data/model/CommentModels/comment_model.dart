import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peopler/data/model/CommentModels/sub_comment_model.dart';

class Comment {
  String? comment;
  int? liked;
  int? disliked;
  String? fromUserID;
  DateTime? createdAt;

  Comment({
    this.comment,
    this.liked,
    this.disliked,
    this.fromUserID,
    this.createdAt,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    liked = json['liked'];
    disliked = json['disliked'];
    fromUserID = json['fromUserID'];
    createdAt = (json['createdAt'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['liked'] = liked;
    data['disliked'] = disliked;
    data['fromUserID'] = fromUserID;
    data['createdAt'] = (createdAt as Timestamp).toDate();

    return data;
  }
}
