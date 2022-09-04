import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import '../../../../../../data/model/activity.dart';
import '../../../../../data/model/user.dart';
import '../../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../../others/locator.dart';
import '../../../../../../others/strings.dart';

class AllActivityListMyProfile extends StatefulWidget {
  const AllActivityListMyProfile({Key? key, required this.profileData, required this.myActivities}) : super(key: key);

  final MyUser profileData;
  final List<MyActivity> myActivities;

  @override
  _AllActivityListMyProfileState createState() => _AllActivityListMyProfileState();
}

class _AllActivityListMyProfileState extends State<AllActivityListMyProfile> {
  @override
  Widget build(BuildContext context) {
    final Mode _mode = locator<Mode>();

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: _mode.search_peoples_scaffold_background(),
              body: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _mode.bottomMenuBackground(),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            txt.backArrowSvgTXT,
                            width: 25,
                            height: 25,
                            color: _mode.homeScreenIconsColor(),
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          txt.peoplerTXT,
                          textScaleFactor: 1,
                          style: GoogleFonts.spartan(color: _mode.homeScreenTitleColor(), fontWeight: FontWeight.w800, fontSize: 24),
                        ),
                        const SizedBox.square(
                          dimension: 25,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                            child: Text(
                              "Hareketler",
                              textScaleFactor: 1,
                              style: GoogleFonts.rubik(
                                color: _mode.blackAndWhiteConversion(),
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              //i use +1 because last index for less more see more widget
                              itemCount: widget.myActivities.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(
                                parent: NeverScrollableScrollPhysics(),
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: _mode.bottomMenuBackground(),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(color: Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
                                    ],
                                    //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "#" + widget.profileData.pplName!,
                                                style: GoogleFonts.rubik(fontSize: 14, color: _mode.blackAndWhiteConversion(), fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                " " + activityText(index),
                                                style: GoogleFonts.rubik(fontSize: 14, color: _mode.blackAndWhiteConversion(), fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                          // Text("+9 :)   0 :("),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: _mode.homeScreenFeedBackgroundColor(),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(color: Color(0xFF939393).withOpacity(0.6), blurRadius: 1, spreadRadius: 0.2, offset: const Offset(0, 0))
                                          ],
                                        ),
                                        child: feedView(context, index),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Container feedView(BuildContext context, int index) {
    final Mode _mode = locator<Mode>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width / 2 - 300 : 0, vertical: 5),
      padding: MediaQuery.of(context).size.width < 340 ? const EdgeInsets.fromLTRB(10, 20, 0, 20) : const EdgeInsets.fromLTRB(20, 20, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeedScreenFeedUserPhoto(index),
          SizedBox(
            width: MediaQuery.of(context).size.width > 600 ? 600 - 90 - 60 : MediaQuery.of(context).size.width - 90 - 60,
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
                            _buildFeedScreenDisplayName(index, context),
                            _buildFeedScreenNumberOfConnections(),
                          ],
                        ),
                        MediaQuery.of(context).size.width < 320
                            ? SizedBox.shrink()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //Text("1 saat önce",style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(),fontSize: 14),),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.more_vert_outlined,
                                      color: _mode.blackAndWhiteConversion()?.withOpacity(0.6),
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
                    _buildFeedScreenExplanation(index, context),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width < 600 ? MediaQuery.of(context).size.width * 0.15 : 600 * 0.15),
                  child: _buildLikeDislikeIcons(context, index),
                  //BlocProvider<LikedBloc>(create: (context) => _likedBloc, child: _buildLikeDislikeIcons(context,)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildLikeDislikeIcons(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildDislike(index),
        SizedBox(
          width: MediaQuery.of(context).size.width < 600 ? MediaQuery.of(context).size.width * 0.1 : 600 * 0.1,
        ),
        buildLike(index),
      ],
    );
  }

  Row buildLike(index) {
    final Mode _mode = locator<Mode>();
    return Row(
      children: [
        //BlocBuilder<LikedBloc, LikedState>(bloc: _likedBloc, builder: (context, state) {return
        GestureDetector(
          onTap: () {
            /*
                if (state is LikeState) {
                  _likedBloc.add(SwapLikedEvent(
                      type: 'liked',
                      setClear: false,
                      feedID: myFeed.feedID,
                      userID: UserBloc.user!.userID));
                  myFeed.liked -= 1;
                } else if (state is DislikeState) {
                  _likedBloc.add(SwapLikedEvent(
                      type: 'liked',
                      setClear: true,
                      feedID: myFeed.feedID,
                      userID: UserBloc.user!.userID));
                  myFeed.liked += 1;
                  myFeed.disliked -= 1;
                } else {
                  _likedBloc.add(SwapLikedEvent(
                      type: 'liked',
                      setClear: true,
                      feedID: myFeed.feedID,
                      userID: UserBloc.user!.userID));
                  myFeed.liked += 1;
                }

                 */
          },
          child: SvgPicture.asset(
            "assets/images/svg_icons/up_arrow.svg",
            color: _mode.blackAndWhiteConversion(),
            fit: BoxFit.contain,
          ),
        ),
        //build   },
        //),
        const SizedBox(
          width: 5,
        ),

        Text(
          widget.myActivities[index].liked.toString(),
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            color: _mode.blackAndWhiteConversion(),
          ),
        )
      ],
    );
  }

  Row buildDislike(int index) {
    final Mode _mode = locator<Mode>();
    return Row(
      children: [
        SizedBox(
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              "assets/images/svg_icons/down_arrow.svg",
              color: _mode.blackAndWhiteConversion(),
              fit: BoxFit.contain,
            )),
        const SizedBox(
          width: 5,
        ),
        Text(
          widget.myActivities[index].disliked.toString(),
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            color: _mode.blackAndWhiteConversion(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedScreenExplanation(index, BuildContext context) {
    final Mode _mode = locator<Mode>();
    return Container(
      //color: Colors.purple,
      child: Padding(
        padding: MediaQuery.of(context).size.width < 340 ? const EdgeInsets.only(right: 10.0) : const EdgeInsets.only(right: 20.0),
        child: Text(
          widget.myActivities[index].feedExplanation,
          textScaleFactor: 1,
          style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 14),
        ),
      ),
    );
  }

  Text _buildFeedScreenNumberOfConnections() {
    final Mode _mode = locator<Mode>();
    int numberOfConnections = 622;
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

  Widget _buildFeedScreenDisplayName(index, BuildContext context) {
    final Mode _mode = locator<Mode>();
    double screeenWidth = MediaQuery.of(context).size.width;
    return Container(
      //color: Colors.red,
      width: screeenWidth - 200,
      child: Text(
        widget.myActivities[index].userDisplayName,
        textScaleFactor: 1,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: false,
        style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 16),
      ),
    );
  }

  Container _buildFeedScreenFeedUserPhoto(int index) {
    String imageUrl = widget.myActivities[index].userPhotoUrl != ''
        ? widget.myActivities[index].userPhotoUrl
        : 'https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png';
    //String imageUrl = myFeed.userPhotoUrl != '' ? myFeed.userPhotoUrl : 'https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png';

    return Container(
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
        );
  }

  String activityText(index) {
    switch (widget.myActivities[index].activityType) {
      case Strings.activityShared:
        return "bir fikir paylaştı.";
      case Strings.activityLiked:
        return "bir fikre katıldı.";
      case Strings.activityDisliked:
        return "bir fikre katılmadı.";
      default:
        {
          return "hata";
        }
    }
  }
}
