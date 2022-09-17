import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
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
              ? CommentCard(comment, savedUserData[comment.fromUserID])
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

                        return CommentCard(comment, userData?.data());
                    }
                  });
        },
      ),
    );
  }

  Row CommentCard(Comment comment, Map<String, dynamic>? userData) {
    bool _isProfileVisiable = userData?["isProfileVisible"] as bool? ?? false;

    ValueNotifier<int> _liked = ValueNotifier(comment.liked ?? 0);
    ValueNotifier<int> _disliked = ValueNotifier(comment.disliked ?? 0);
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
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    _liked.value++;
                  },
                  child: ValueListenableBuilder(
                      valueListenable: _liked,
                      builder: (context, _, __) {
                        return Text("${_liked.value} beğeni");
                      }),
                ),
                TextButton(
                  onPressed: () {
                    _disliked.value++;
                  },
                  child: ValueListenableBuilder(
                      valueListenable: _disliked,
                      builder: (context, _, __) {
                        return Text("${_disliked.value} beğenmeme");
                      }),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
