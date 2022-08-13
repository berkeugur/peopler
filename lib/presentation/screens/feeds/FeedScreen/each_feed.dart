import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/LikedBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/data/model/feed.dart';
import '../../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../../../../others/strings.dart';
import '../../../../others/widgets/snack_bars.dart';
import '../../../tab_item.dart';
import '../../profile/OthersProfile/functions.dart';
import '../../profile/OthersProfile/profile/profile_screen_components.dart';
import 'feed_functions.dart';

class eachFeedWidget extends StatelessWidget {
  final MyFeed myFeed;
  final int index;

  eachFeedWidget({Key? key, required this.myFeed, required this.index}) : super(key: key);

  final LikedBloc _likedBloc = LikedBloc();
  final Mode _mode = locator<Mode>();

  @override
  Widget build(BuildContext context) {
    {
      if(UserBloc.user != null) {
        _likedBloc.add(GetInitialLikedEvent(userID: UserBloc.user!.userID, feedID: myFeed.feedID));
      }
      return ValueListenableBuilder(
          valueListenable: setTheme,
          builder: (context, x, y) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2 - 300 : 0, vertical: 5),
              padding: index == 0 ? const EdgeInsets.fromLTRB(20, 110, 0, 20) : const EdgeInsets.fromLTRB(20, 20, 0, 20),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[BoxShadow(color: Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))],
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
                                    _buildFeedScreenNumberOfConnections(myFeed.numberOfConnections),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //Text("1 saat önce",style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(),fontSize: 14),),
                                    IconButton(
                                      onPressed: () {
                                        tripleDotOnPressed(
                                          context,
                                          myFeed.feedID,
                                          myFeed.feedExplanation,
                                          myFeed.userID,
                                          myFeed.userDisplayName,
                                          myFeed.userGender,
                                          myFeed.createdAt,
                                          myFeed.userPhotoUrl,
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

  Row _buildLikeDislikeIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildDislike(),
        SizedBox(
          width: MediaQuery.of(context).size.width < 600 ? MediaQuery.of(context).size.width * 0.1 : 600 * 0.1,
        ),
        _buildLike(),
      ],
    );
  }

  Row _buildLike() {
    return Row(
      children: [
        BlocBuilder<LikedBloc, LikedState>(
          bloc: _likedBloc,
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                if(UserBloc.user != null) {
                  if (state is LikeState) {
                    _likedBloc.add(SwapLikedEvent(type: 'liked', setClear: false, feedID: myFeed.feedID, userID: UserBloc.user!.userID));
                    myFeed.liked -= 1;
                  } else if (state is DislikeState) {
                    _likedBloc.add(SwapLikedEvent(type: 'liked', setClear: true, feedID: myFeed.feedID, userID: UserBloc.user!.userID));
                    myFeed.liked += 1;
                    myFeed.disliked -= 1;
                  } else {
                    _likedBloc.add(SwapLikedEvent(type: Strings.activityLiked, setClear: true, feedID: myFeed.feedID, userID: UserBloc.user!.userID));
                    myFeed.liked += 1;
                  }
                }
              },
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    "assets/images/svg_icons/up_arrow.svg",
                    color: (state is LikeState) ? Colors.green : Mode().blackAndWhiteConversion(),
                    fit: BoxFit.contain,
                  )),
            );
          },
        ),
        const SizedBox(
          width: 5,
        ),
        BlocBuilder<LikedBloc, LikedState>(
          bloc: _likedBloc,
          builder: (context, state) {
            return Text(
              myFeed.liked.toString(),
              textScaleFactor: 1,
              style: GoogleFonts.rubik(
                color: _mode.blackAndWhiteConversion(),
              ),
            );
          },
        ),
      ],
    );
  }

  Row _buildDislike() {
    return Row(
      children: [
        BlocBuilder<LikedBloc, LikedState>(
          bloc: _likedBloc,
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                if(UserBloc.user != null) {
                  if (state is DislikeState) {
                    _likedBloc.add(SwapLikedEvent(type: Strings.activityDisliked,
                        setClear: false,
                        feedID: myFeed.feedID,
                        userID: UserBloc.user!.userID));
                    myFeed.disliked -= 1;
                  } else if (state is LikeState) {
                    _likedBloc.add(SwapLikedEvent(type: Strings.activityDisliked,
                        setClear: true,
                        feedID: myFeed.feedID,
                        userID: UserBloc.user!.userID));
                    myFeed.disliked += 1;
                    myFeed.liked -= 1;
                  } else {
                    _likedBloc.add(SwapLikedEvent(type: Strings.activityDisliked,
                        setClear: true,
                        feedID: myFeed.feedID,
                        userID: UserBloc.user!.userID));
                    myFeed.disliked += 1;
                  }
                }
              },
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: SvgPicture.asset(
                    "assets/images/svg_icons/down_arrow.svg",
                    color: (state is DislikeState) ? Colors.pink : Mode().blackAndWhiteConversion(),
                    fit: BoxFit.contain,
                  )),
            );
          },
        ),
        const SizedBox(
          width: 5,
        ),
        BlocBuilder(
          bloc: _likedBloc,
          builder: (context, state) {
            return Text(
              myFeed.disliked.toString(),
              textScaleFactor: 1,
              style: GoogleFonts.rubik(
                color: _mode.blackAndWhiteConversion(),
              ),
            );
          },
        ),
      ],
    );
  }

  Container _buildFeedScreenFeedUserPhoto(context) {
    String imageUrl = myFeed.userPhotoUrl != '' ? myFeed.userPhotoUrl : 'https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png';

    return Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(right: 10),
        child: InkWell(
          onTap: () {
            if(UserBloc.user == null) {
              showYouNeedToLogin(context);
              return;
            }

            if (myFeed.userID != UserBloc.user!.userID) {
              openOthersProfile(context, myFeed.userID, SendRequestButtonStatus.connect);
            } else {
              FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
              _homeScreen.currentTab = TabItem.profile;
              _homeScreen.changeFloatingActionButtonEvent();
            }
          },
          child: CircleAvatar(
            radius: 70,
            backgroundImage:
                /*
            ImageNetwork(
              image: widget.myFeed.userPhotoUrl,
              imageCache: CachedNetworkImageProvider(widget.myFeed.userPhotoUrl),
              height: 60,
              width: 60,
              duration: 500,
              curve: Curves.easeIn,
              onPointer: true,
              debugPrint: false,
              fullScreen: false,
              fitAndroidIos: BoxFit.cover,
              fitWeb: BoxFitWeb.cover,
              borderRadius: BorderRadius.circular(70),
              onLoading: const CircularProgressIndicator(
                color: Colors.indigoAccent,
              ),
              onError: const Icon(
                Icons.error,
                color: Colors.blue,
              ),
              onTap: () {
                debugPrint("©gabriel_patrick_souza");
              },
            ),
             */
                NetworkImage(
              myFeed.userPhotoUrl,
            ),
            backgroundColor: Colors.white,
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
        myFeed.feedExplanation,
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
      myFeed.userDisplayName,
      textScaleFactor: 1,
      style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 18),
    );
  }
}
