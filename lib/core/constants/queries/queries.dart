import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/model/CommentModels/comment_model.dart';

class Queries {
  static CollectionReference<Comment> feedCommentListQuery({required String feedID}) =>
      FirebaseFirestore.instance.collection('feeds').doc(feedID).collection("comments").withConverter<Comment>(
            fromFirestore: (snapshot, _) => Comment.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );
}
