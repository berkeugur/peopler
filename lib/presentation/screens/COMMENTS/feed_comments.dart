import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/core/constants/queries/queries.dart';
import 'package:peopler/data/model/CommentModels/comment_model.dart';
import 'package:peopler/data/model/feed.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/classes/variables.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

/*

class FeedComments extends StatefulWidget {
  final MyFeed feed;
  const FeedComments({Key? key, required this.feed}) : super(key: key);

  @override
  State<FeedComments> createState() => _FeedCommentsState();
}

class _FeedCommentsState extends State<FeedComments> {
  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PeoplerAppBars(context: context).COMMENTS,
          body: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Column(
                children: [
                  _buildFeedDisplay(),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: FirestoreListView<Comment>(
                        physics: const NeverScrollableScrollPhysics(),
                        loadingBuilder: (context) => const CircularProgressIndicator(),
                        errorBuilder: (context, error, stackTrace) => Text("$error $stackTrace"),
                        query: Queries.feedCommentListQuery(feedID: widget.feed.feedID),
                        shrinkWrap: true,
                        itemBuilder: (context, commentSnapshot) {
                          printf("firestoreListView");
                          Comment comment = commentSnapshot.data();
                          return Variables.savedUserData[comment.fromUserID] != null
                              ? CommentCard(
                                  comment,
                                  Variables.savedUserData[comment.fromUserID],
                                  widget.feed.feedID,
                                )
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
                                        printf("********* UserSnapShot *************");
                                        printf(userData?.data().toString());
                                        if (comment.fromUserID != null) {
                                          Variables.savedUserData.addAll({comment.fromUserID!: userData?.data()});
                                        }

                                        return CommentCard(
                                          comment,
                                          userData?.data(),
                                          widget.feed.feedID,
                                        );
                                    }
                                  },
                                );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 2.0, spreadRadius: 0, offset: const Offset(0.0, 0.75))
                  ],
                  color: Mode().enabledMenuItemBackground(),
                ),
                height: 50,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        await Future.delayed(const Duration(milliseconds: 200), (() {
                          emojiShowing = !emojiShowing;
                        }));
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.tag_faces,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          onTap: () {},
                          controller: _controller,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          maxLines: 99,
                          minLines: 1,
                          maxLength: MaxLengthConstants.MESSAGE,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Yorumunuzu yazın',
                            counterText: "",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                          Random _rnd = Random();

                          String getRandomString(int length) =>
                              String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
                          String uniqDocumentID = getRandomString(20);
                          await FirebaseFirestore.instance.collection("feeds").doc(widget.feed.feedID).collection("comments").doc(uniqDocumentID).set(Comment(
                                comment: _controller.text,
                                commentID: uniqDocumentID,
                                liked: 0,
                                disliked: 0,
                                fromUserID: UserBloc.user?.userID,
                                createdAt: Timestamp.now(),
                              ).toJson());
                          _controller.clear;
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.send,
                          size: 25,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedDisplay() {
    String imageUrl =
        widget.feed.userPhotoUrl != '' ? widget.feed.userPhotoUrl : 'https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      //padding: MediaQuery.of(context).size.width < 340 ? const EdgeInsets.fromLTRB(10, 20, 0, 20) : const EdgeInsets.fromLTRB(20, 20, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                  imageUrl,
                  //myFeed.userPhotoUrl,
                ),
                backgroundColor: Colors.white,
              )

              /*CircleAvatar(
              backgroundColor:
                  Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(1.0),
            )*/
              ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // color: Colors.red,
                              width: MediaQuery.of(context).size.width - 200,
                              child: Text(
                                widget.feed.userDisplayName,
                                textScaleFactor: 1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion(), fontSize: 16),
                              ),
                            ),
                            Text(
                              widget.feed.numberOfConnections.toString() + " Bağlantı",
                              textScaleFactor: 1,
                              style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion(), fontSize: 14),
                            ),
                          ],
                        ),
                        MediaQuery.of(context).size.width < 320
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //Text("1 saat önce",style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(),fontSize: 14),),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.more_vert_outlined,
                                      color: Mode().blackAndWhiteConversion()?.withOpacity(0.6),
                                      size: 20,
                                    ),
                                  )
                                ],
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      //color: Colors.purple,
                      child: Padding(
                        padding: MediaQuery.of(context).size.width < 340 ? const EdgeInsets.only(right: 10.0) : const EdgeInsets.only(right: 20.0),
                        child: Text(
                          widget.feed.feedExplanation,
                          textScaleFactor: 1,
                          style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion(), fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width < 600 ? MediaQuery.of(context).size.width * 0.15 : 600 * 0.15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildDislike(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width < 600 ? MediaQuery.of(context).size.width * 0.1 : 600 * 0.1,
                      ),
                      buildLike(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildLike() {
    return Row(
      children: [
        //BlocBuilder<LikedBloc, LikedState>(bloc: _likedBloc, builder: (context, state) {return
        GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            "assets/images/svg_icons/up_arrow.svg",
            color: Mode().blackAndWhiteConversion(),
            fit: BoxFit.contain,
          ),
        ),
        //build   },
        //),
        const SizedBox(
          width: 5,
        ),

        Text(
          widget.feed.liked.toString(),
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
            color: Mode().blackAndWhiteConversion(),
          ),
        )
      ],
    );
  }

  Row buildDislike() {
    return Row(
      children: [
        SizedBox(
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              "assets/images/svg_icons/down_arrow.svg",
              color: Mode().blackAndWhiteConversion(),
              fit: BoxFit.contain,
            )),
        const SizedBox(
          width: 5,
        ),
        Text(
          widget.feed.disliked.toString(),
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
            color: Mode().blackAndWhiteConversion(),
          ),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget CommentCard(
    Comment comment,
    Map<String, dynamic>? userData,
    String feedID,
  ) {
    bool _isProfileVisiable = userData?["isProfileVisible"] as bool? ?? false;

    ValueNotifier<int> _liked = ValueNotifier(comment.liked ?? 0);

    bool? isLiked;
    getData() async {
      var commentLikedData =
          await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).collection("likedComments").doc(comment.commentID).get();
      Map<String, dynamic>? _commentLikedData = commentLikedData.data();
      isLiked = _commentLikedData == null ? false : true;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                      child: CircleAvatar(
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
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              text: TextSpan(
                                text: _isProfileVisiable ? (userData?["displayName"] ?? "null display name") : ("#${userData?["pplName"]}"),
                                style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                children: [
                                  TextSpan(
                                    text: " " + (comment.comment ?? "null"),
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),

//comment.createdAt.toDate()
                            Row(
                              children: [
                                Text(
                                  DateTime.now().difference((comment.createdAt ?? Timestamp.now as Timestamp).toDate()).inMinutes.toString() + "dk önce",
                                  style: GoogleFonts.dmSans(),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "${_liked.value} beğeni",
                                  style: GoogleFonts.dmSans(
                                    color: isLiked ?? false ? Colors.green : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return const Text("none");
                        case ConnectionState.waiting:
                          return const SizedBox();
                        case ConnectionState.active:
                          return const Text("active");
                        case ConnectionState.done:
                          return SizedBox(width: 50, child: _likeButton(isLiked, comment, feedID, _liked));
                      }
                    }),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  TextButton _likeButton(bool? isLiked, Comment comment, String feedID, ValueNotifier<int> _liked) {
    return TextButton(
      onPressed: () async {
        if (isLiked!) {
          //beğeniyi geri alma
          await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).collection("likedComments").doc(comment.commentID).delete();
          await FirebaseFirestore.instance
              .collection('feeds')
              .doc(feedID)
              .collection("comments")
              .doc(comment.commentID)
              .update({"liked": (comment.liked ?? 0) - 1});
          _liked.value--;
        } else {
          //yeni beğeni

          await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).collection("likedComments").doc(comment.commentID).set({});
          await FirebaseFirestore.instance
              .collection('feeds')
              .doc(feedID)
              .collection("comments")
              .doc(comment.commentID)
              .update({"liked": (comment.liked ?? 0) + 1});
          _liked.value++;
        }
      },
      child: ValueListenableBuilder(
        valueListenable: _liked,
        builder: (context, _, __) {
          return isLiked == true ? const Icon(Icons.favorite) : const Icon(Icons.favorite_outline);
        },
      ),
    );
  }
}

*/
