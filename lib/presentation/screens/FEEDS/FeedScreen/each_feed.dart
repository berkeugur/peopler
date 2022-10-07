import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/LikedBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import 'package:peopler/core/constants/visibility/widget_visibility.dart';
import 'package:peopler/data/model/feed.dart';
import 'package:peopler/others/functions/guest_login_alert_dialog.dart';
import 'package:peopler/presentation/screens/COMMENTS/feed_comments.dart';
import '../../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../../../../others/strings.dart';
import '../../../../others/widgets/snack_bars.dart';

import '../../PROFILE/OthersProfile/functions.dart';
import '../../PROFILE/OthersProfile/profile/profile_screen_components.dart';
import 'feed_functions.dart';

class eachFeedWidget extends StatefulWidget {
  final MyFeed myFeed;
  final int index;

  eachFeedWidget({Key? key, required this.myFeed, required this.index}) : super(key: key);

  @override
  State<eachFeedWidget> createState() => _eachFeedWidgetState();
}

class _eachFeedWidgetState extends State<eachFeedWidget> with TickerProviderStateMixin {
  final LikedBloc _likedBloc = LikedBloc();

  final Mode _mode = locator<Mode>();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    {
      if (UserBloc.user != null) {
        _likedBloc.add(GetInitialLikedEvent(userID: UserBloc.user!.userID, feedID: widget.myFeed.feedID));
      }
      return ValueListenableBuilder(
          valueListenable: setTheme,
          builder: (context, x, y) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2 - 300 : 0, vertical: 5),
              padding: widget.index == 0 ? const EdgeInsets.fromLTRB(20, 110, 0, 20) : const EdgeInsets.fromLTRB(20, 20, 0, 20),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
                ],
                color: _mode.homeScreenFeedBackgroundColor(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeedScreenFeedUserPhoto(context),
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 600 ? 600 - 90 : MediaQuery.of(context).size.width - 90,
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
                                    _buildFeedScreenDisplayName(),
                                    _buildFeedScreenNumberOfConnections(widget.myFeed.numberOfConnections),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    (UserBloc.user != null && widget.myFeed.userID == UserBloc.user!.userID) || (UserBloc.user == null)
                                        ? const SizedBox.shrink()
                                        : IconButton(
                                            onPressed: () {
                                              tripleDotOnPressed(
                                                context,
                                                widget.myFeed.feedID,
                                                widget.myFeed.feedExplanation,
                                                widget.myFeed.userID,
                                                widget.myFeed.userDisplayName,
                                                widget.myFeed.userGender,
                                                widget.myFeed.createdAt,
                                                widget.myFeed.userPhotoUrl,
                                                _controller,
                                              );
                                            },
                                            icon: Icon(
                                              Icons.more_vert_outlined,
                                              color: _mode.blackAndWhiteConversion()?.withOpacity(0.6),
                                              size: 25,
                                            ),
                                          )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildFeedScreenExplanation(),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: MediaQuery.of(context).size.width < 600 ? MediaQuery.of(context).size.width * 0.15 : 600 * 0.15),
                          child: BlocProvider<LikedBloc>(
                              create: (context) => _likedBloc,
                              child: _buildLikeDislikeIcons(
                                context,
                                widget.myFeed.feedID,
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  Row _buildLikeDislikeIcons(BuildContext context, String feedID) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        WidgetVisibility.isCommentsVisiable
            ? TextButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("feedID: $feedID");
                  }
                  BlocProvider.of<UserBloc>(context).mainKey.currentState?.push(
                        MaterialPageRoute(
                          builder: (context) => FeedComments(
                            feed: widget.myFeed,
                          ),
                        ),
                      );
                },
                child: const Text("Yorumlar"),
              )
            : const SizedBox.shrink(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildDislike(),
            SizedBox(
              width: MediaQuery.of(context).size.width < 600 ? MediaQuery.of(context).size.width * 0.1 : 600 * 0.1,
            ),
            _buildLike(),
          ],
        ),
      ],
    );
  }

  Widget _buildLike() {
    return BlocBuilder<LikedBloc, LikedState>(
        bloc: _likedBloc,
        builder: (context, state) {
          return Container(
            child: InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () {
                if (UserBloc.user != null) {
                  if (state is LikeState) {
                    _likedBloc.add(SwapLikedEvent(type: 'liked', setClear: false, feedID: widget.myFeed.feedID, userID: UserBloc.user!.userID));
                    widget.myFeed.liked -= 1;
                  } else if (state is DislikeState) {
                    _likedBloc.add(SwapLikedEvent(type: 'liked', setClear: true, feedID: widget.myFeed.feedID, userID: UserBloc.user!.userID));
                    widget.myFeed.liked += 1;
                    widget.myFeed.disliked -= 1;
                  } else {
                    _likedBloc.add(SwapLikedEvent(type: Strings.activityLiked, setClear: true, feedID: widget.myFeed.feedID, userID: UserBloc.user!.userID));
                    widget.myFeed.liked += 1;
                  }
                } else {
                  GuestAlert.dialog(context);
                }
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Container(
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset(
                            "assets/images/svg_icons/up_arrow.svg",
                            color: (state is LikeState) ? Colors.green : Mode().blackAndWhiteConversion(),
                            fit: BoxFit.contain,
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.myFeed.liked.toString(),
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(
                        color: _mode.blackAndWhiteConversion(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildDislike() {
    return BlocBuilder<LikedBloc, LikedState>(
        bloc: _likedBloc,
        builder: (context, state) {
          return Container(
            child: InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () {
                if (UserBloc.user != null) {
                  if (state is DislikeState) {
                    _likedBloc
                        .add(SwapLikedEvent(type: Strings.activityDisliked, setClear: false, feedID: widget.myFeed.feedID, userID: UserBloc.user!.userID));
                    widget.myFeed.disliked -= 1;
                  } else if (state is LikeState) {
                    _likedBloc.add(SwapLikedEvent(type: Strings.activityDisliked, setClear: true, feedID: widget.myFeed.feedID, userID: UserBloc.user!.userID));
                    widget.myFeed.disliked += 1;
                    widget.myFeed.liked -= 1;
                  } else {
                    _likedBloc.add(SwapLikedEvent(type: Strings.activityDisliked, setClear: true, feedID: widget.myFeed.feedID, userID: UserBloc.user!.userID));
                    widget.myFeed.disliked += 1;
                  }
                } else {
                  GuestAlert.dialog(context);
                }
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                          "assets/images/svg_icons/down_arrow.svg",
                          color: (state is DislikeState) ? Colors.pink : Mode().blackAndWhiteConversion(),
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.myFeed.disliked.toString(),
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(
                        color: _mode.blackAndWhiteConversion(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Container _buildFeedScreenFeedUserPhoto(context) {
    return Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: () {
            if (UserBloc.user == null) {
              showYouNeedToLogin(context);
              return;
            }

            if (UserBloc.user!.whoBlockedYou.toSet().contains(widget.myFeed.userID)) {
              return;
            }

            if (widget.myFeed.userID != UserBloc.user!.userID) {
              openOthersProfile(context, widget.myFeed.userID, SendRequestButtonStatus.connect);
            } else {
              FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
              _homeScreen.currentTab = TabItem.profile;
              _homeScreen.changeFloatingActionButtonEvent();
            }
          },
          child: CachedNetworkImage(
            imageUrl: widget.myFeed.userPhotoUrl,
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
        )

        /*CircleAvatar(
              backgroundColor:
                  Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(1.0),
            )*/
        );
  }

  Padding _buildFeedScreenExplanation() {
    return Padding(
      padding: const EdgeInsets.only(right: 28.0),
      child: Text(
        widget.myFeed.feedExplanation,
        textScaleFactor: 1,
        style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 14),
      ),
    );
  }

  Text _buildFeedScreenNumberOfConnections(int numberOfConnections) {
    bool caseStatus = numberOfConnections > 500 ? true : false;
    String numberOfConnectionString;

    switch (caseStatus) {
      case true:
        numberOfConnectionString = "500+ bağlantı";
        break;
      case false:
        numberOfConnectionString = "$numberOfConnections bağlantı";
        break;
      default:
        numberOfConnectionString = "error##31895";
    }

    return Text(
      numberOfConnectionString,
      textScaleFactor: 1,
      style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 14),
    );
  }

  Text _buildFeedScreenDisplayName() {
    return Text(
      widget.myFeed.userDisplayName,
      textScaleFactor: 1,
      style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 18),
    );
  }
}
