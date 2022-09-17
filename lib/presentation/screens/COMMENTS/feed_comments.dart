import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/core/constants/queries/queries.dart';
import 'package:peopler/data/model/CommentModels/comment_model.dart';

class FeedComments extends StatefulWidget {
  final String feedID;
  const FeedComments({Key? key, required this.feedID}) : super(key: key);

  @override
  State<FeedComments> createState() => _FeedCommentsState();
}

class _FeedCommentsState extends State<FeedComments> {
  Map<String, Map<String, dynamic>?> savedUserData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FirestoreListView<Comment>(
        loadingBuilder: (context) => const CircularProgressIndicator(),
        errorBuilder: (context, error, stackTrace) => Text("$error $stackTrace"),
        query: Queries.feedCommentListQuery(feedID: widget.feedID),
        shrinkWrap: true,
        itemBuilder: (context, commentSnapshot) {
          print("firestoreListView");
          Comment comment = commentSnapshot.data();
          return savedUserData[comment.fromUserID] != null
              ? CommentCard(comment, savedUserData[comment.fromUserID], widget.feedID)
              : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection("users").doc(comment.fromUserID).get(),
                  builder: (context, userSnapshot) {
                    switch (userSnapshot.connectionState) {
                      case ConnectionState.none:
                        return const Text("none");
                      case ConnectionState.waiting:
                        return const Text("waiting");
                      case ConnectionState.active:
                        return const Text("active");
                      case ConnectionState.done:
                        var userData = userSnapshot.data;
                        print("********* UserSnapShot *************");
                        print(userData?.data().toString());
                        if (comment.fromUserID != null) {
                          savedUserData.addAll({comment.fromUserID!: userData?.data()});
                        }

                        return CommentCard(comment, userData?.data(), widget.feedID);
                    }
                  });
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CommentCard(Comment comment, Map<String, dynamic>? userData, String feedID) {
    bool _isProfileVisiable = userData?["isProfileVisible"] as bool? ?? false;

    ValueNotifier<int> _liked = ValueNotifier(comment.liked ?? 0);
    ValueNotifier<int> _disliked = ValueNotifier(comment.disliked ?? 0);
    bool? isLiked;
    bool? isDisliked;
    getData() async {
      var commentLikedData =
          await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).collection("likedComments").doc(comment.commentID).get();
      Map<String, dynamic>? _commentLikedData = commentLikedData.data();
      isLiked = _commentLikedData == null ? false : true;
//
//
//
      var commentDislikedData =
          await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).collection("dislikedComments").doc(comment.commentID).get();
      Map<String, dynamic>? _commentDislikedData = commentDislikedData.data();
      isDisliked = _commentDislikedData == null ? false : true;
    }

    return Row(
      children: [
        CircleAvatar(
          child: CachedNetworkImage(
            imageUrl: _isProfileVisiable
                ? (userData?["profileURL"] ?? 'https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png')
                : 'https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png',
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                ClipRRect(borderRadius: BorderRadius.circular(999), child: CircularProgressIndicator(value: downloadProgress.progress)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(_isProfileVisiable ? (userData?["displayName"] ?? "null display name") : ("#${userData?["pplName"]}")),
            Text(
              comment.comment ?? "null",
            ),
            FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text("none");
                    case ConnectionState.waiting:
                      return Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "${_liked.value} beğeni",
                              style: TextStyle(
                                color: isLiked ?? false ? Colors.green : null,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "${_disliked.value} beğenmeme",
                              style: TextStyle(
                                color: isDisliked ?? false ? Colors.redAccent : null,
                              ),
                            ),
                          ),
                        ],
                      );
                    case ConnectionState.active:
                      return const Text("active");
                    case ConnectionState.done:
                      return Row(
                        children: [
                          //
                          //Build LikeButton
                          //
                          TextButton(
                            onPressed: () async {
                              if (isLiked != null) {
                                if (isLiked!) {
                                  //beğeniyi geri alma
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(UserBloc.user!.userID)
                                      .collection("likedComments")
                                      .doc(comment.commentID)
                                      .delete();
                                  await FirebaseFirestore.instance
                                      .collection('feeds')
                                      .doc(feedID)
                                      .collection("comments")
                                      .doc(comment.commentID)
                                      .update({"liked": (comment.liked ?? 0) - 1});
                                  _liked.value--;
                                } else {
                                  //yeni beğeni
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(UserBloc.user!.userID)
                                      .collection("likedComments")
                                      .doc(comment.commentID)
                                      .set({});
                                  await FirebaseFirestore.instance
                                      .collection('feeds')
                                      .doc(feedID)
                                      .collection("comments")
                                      .doc(comment.commentID)
                                      .update({"liked": (comment.liked ?? 0) + 1});
                                  _liked.value++;
                                }
                              }
                            },
                            child: ValueListenableBuilder(
                                valueListenable: _liked,
                                builder: (context, _, __) {
                                  return Text(
                                    "${_liked.value} beğeni",
                                    style: TextStyle(
                                      color: isLiked ?? false ? Colors.green : null,
                                    ),
                                  );
                                }),
                          ),

                          //
                          //Build DislikeButton
                          //

                          TextButton(
                            onPressed: () async {
                              if (isDisliked != null) {
                                if (isDisliked!) {
                                  //beğeniyi geri alma
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(UserBloc.user!.userID)
                                      .collection("dislikedComments")
                                      .doc(comment.commentID)
                                      .delete();
                                  await FirebaseFirestore.instance
                                      .collection('feeds')
                                      .doc(feedID)
                                      .collection("comments")
                                      .doc(comment.commentID)
                                      .update({"disliked": (comment.disliked ?? 0) - 1});
                                  _disliked.value--;
                                } else {
                                  //yeni beğeni
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(UserBloc.user!.userID)
                                      .collection("dislikedComments")
                                      .doc(comment.commentID)
                                      .set({});
                                  await FirebaseFirestore.instance
                                      .collection('feeds')
                                      .doc(feedID)
                                      .collection("comments")
                                      .doc(comment.commentID)
                                      .update({"disliked": (comment.disliked ?? 0) + 1});
                                  _disliked.value++;
                                }
                              }
                            },
                            child: ValueListenableBuilder(
                                valueListenable: _disliked,
                                builder: (context, _, __) {
                                  return Text(
                                    "${_disliked.value} beğenmeme",
                                    style: TextStyle(
                                      color: isDisliked ?? false ? Colors.redAccent : null,
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                  }
                }),
          ],
        )
      ],
    );
  }
}
