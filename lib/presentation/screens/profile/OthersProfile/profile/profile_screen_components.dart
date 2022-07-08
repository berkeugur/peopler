import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/others/classes/hobbies.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/ProfileScreen/hobby_functions.dart';
import 'package:peopler/presentation/screens/profile/OthersProfile/profile/all_activity_list.dart';
import '../../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../../others/locator.dart';
import '../../../../../../others/strings.dart';
import '../../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../../data/model/chat.dart';
import '../../../MessageScreen/message_screen.dart';

class ProfileScreenComponentsOthersProfile {
  final MyUser profileData;
  final List<String> mutualConnectionUserIDs;
  final List<MyActivity> myActivities;

  ProfileScreenComponentsOthersProfile(
      {required this.profileData, required this.mutualConnectionUserIDs, required this.myActivities});

  final Mode _mode = locator<Mode>();

  nameField() {
    return Text(
      profileData.isProfileVisible == true ? profileData.displayName : profileData.pplName!,
      textScaleFactor: 1,
      style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  biographyField(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Text(
                "Hakkında",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                  color: _mode.blackAndWhiteConversion(),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        AnimatedContainer(
            decoration: BoxDecoration(
              color: Mode().homeScreenScaffoldBackgroundColor(),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color(0xFF939393).withOpacity(0.6),
                    blurRadius: 0.5,
                    spreadRadius: 0,
                    offset: const Offset(0, 0))
              ],
            ),
            width: MediaQuery.of(context).size.width,
            duration: const Duration(seconds: 1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              profileData.biography,
              textScaleFactor: 1,
              style: GoogleFonts.rubik(
                fontSize: 15,
                color: _mode.blackAndWhiteConversion(),
              ),
            )

            //ExpandableText(text: profileData.biography, max: 0.5,),
            ),
      ],
    );
  }

  photos(context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        profileData.photosURL.isNotEmpty ? horizontalPhotoList(context) : const SizedBox.shrink(),
        profilePhoto(context),
      ],
    );
  }

  profilePhoto(context) {
    Size _size = MediaQuery.of(context).size;
    double _screenWidth = _size.width;
    double _photoSize = _screenWidth / 4.2;
    return Stack(
      children: [
        Container(
          height: _photoSize,
          width: _photoSize,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                width: 5,
                color: _mode.search_peoples_scaffold_background() as Color,
              )),
          child: const CircleAvatar(
            backgroundColor: Color(0xFF0353EF),
            child: Text(
              "ppl",
              textScaleFactor: 1,
            ),
          ),
        ),
        Container(
          height: _photoSize,
          width: _photoSize,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                width: 5,
                color: _mode.search_peoples_scaffold_background() as Color,
              )),
          child: //_userBloc != null ?
              CircleAvatar(
            radius: 999,
            backgroundImage: NetworkImage(
              profileData.profileURL,
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  horizontalPhotoList(context) {
    Size _size = MediaQuery.of(context).size;
    double _screenWidth = _size.width;

    double _photoHeight = profileData.photosURL.length >= 3 ? _screenWidth / 3.5 : _screenWidth / 2.8;
    double _photoRatio = 4 / 3;
    double _photoWidth = _photoHeight * _photoRatio;
    double _photoPadding = 2.5;

    int _numberOfPhoto = 4;
    ValueNotifier<int> _itemCount = ValueNotifier(
        profileData.photosURL.length > _numberOfPhoto ? _numberOfPhoto + 1 : profileData.photosURL.length);

    BorderRadius _customBorderRadius() => BorderRadius.circular(7.5);
    return ValueListenableBuilder(
        valueListenable: _itemCount,
        builder: (context, value, _) {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: _photoHeight,
                child: Align(
                  alignment: profileData.photosURL.length != 1 ? Alignment.center : Alignment.centerLeft,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    //i use +1 because last index for less more see more widget
                    itemCount: _itemCount.value,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemBuilder: (context, index) {
                      return index == _itemCount.value - 1 && _itemCount.value == _numberOfPhoto + 1
                          ? Container(
                              height: _photoHeight,
                              width: _photoWidth,
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    _itemCount.value == _numberOfPhoto + 1
                                        ? _itemCount.value = profileData.photosURL.length + 1
                                        : _itemCount.value = _numberOfPhoto + 1;
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 21,
                                        color: _mode.blackAndWhiteConversion(),
                                      ),
                                      Text(
                                        "see more",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.rubik(
                                          color: _mode.blackAndWhiteConversion(),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          : index == _itemCount.value - 1 && _itemCount.value == profileData.photosURL.length + 1
                              ? Container(
                                  height: _photoHeight,
                                  width: _photoWidth,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        _itemCount.value == _numberOfPhoto + 1
                                            ? _itemCount.value = profileData.photosURL.length + 1
                                            : _itemCount.value = _numberOfPhoto + 1;
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 21,
                                            color: _mode.blackAndWhiteConversion(),
                                          ),
                                          Text(
                                            "less more",
                                            textScaleFactor: 1,
                                            style: GoogleFonts.rubik(
                                              color: _mode.blackAndWhiteConversion(),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              : Container(
                                  height: _photoHeight,
                                  width: _photoWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: _customBorderRadius(),
                                    color: Colors.grey[400],
                                  ),
                                  margin: EdgeInsets.only(
                                      left: index == 0 && profileData.photosURL.length >= 3
                                          ? 5
                                          : profileData.photosURL.length == 1
                                              ? 10
                                              : _photoPadding,
                                      right: _photoPadding),
                                  child: ClipRRect(
                                    borderRadius: _customBorderRadius(),
                                    child: Image.network(
                                      profileData.photosURL[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                    },
                  ),
                ),
              ),
              SizedBox.square(
                dimension: profileData.photosURL.length >= 3 ? _photoHeight / 2 : _photoHeight / 3,
              ),
            ],
          );
        });
  }

  locationText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 21,
          color: _mode.blackAndWhiteConversion(),
        ),
        Text(
          "${profileData.city}",
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            color: _mode.blackAndWhiteConversion(),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  sendRequestButton(BuildContext context, SendRequestButtonStatus status, MyUser otherUser) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: 30,
      width: 105,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(width: 1, color: const Color(0xFF0353EF)),
        color: status == SendRequestButtonStatus.saved
            ? Color(0xFF0353EF) //,_mode.inActiveColor()
            : Color(0xFF0353EF),
      ),
      child: Center(child: buttonContent(context, status, otherUser)),
    );
  }

  Widget buttonContent(BuildContext context, SendRequestButtonStatus status, MyUser otherUser) {
    switch (status) {
      case SendRequestButtonStatus.save:
          return _buildSaveStatus();
      case SendRequestButtonStatus.saved:
        return _buildSavedStatus();
      case SendRequestButtonStatus.connect:
        return _buildConnectStatus();
      case SendRequestButtonStatus.requestSent:
        return _buildRequestSentStatus();
      case SendRequestButtonStatus.accept:
        return _buildAcceptStatus();
      case SendRequestButtonStatus.connected:
        return _buildConnectedStatus(otherUser, context);
      default:
          return const Text("error");
    }
  }


  InkWell _buildSaveStatus() {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: SvgPicture.asset(
              "assets/images/svg_icons/saved.svg",
              color: Colors.white,
              matchTextDirection: true,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            "Kaydet",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(color: const Color(0xFFFFFFFF), fontSize: 14),
          ),
          const SizedBox.square(
            dimension: 5,
          )
        ],
      ),
    );
  }

  Text _buildSavedStatus() {
    return Text(
      "Kaydedildi",
      textScaleFactor: 1,
      style: GoogleFonts.rubik(color: const Color(0xFFFFFFFF), fontSize: 14),
    );
  }

  InkWell _buildConnectStatus() {
    return InkWell(
      onTap: () {},
      child: Text(
        "Bağlantı Kur",
        textScaleFactor: 1,
        style: GoogleFonts.rubik(color: const Color(0xFFFFFFFF), fontSize: 14),
      ),
    );
  }

  InkWell _buildRequestSentStatus() {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: SvgPicture.asset(
              "assets/images/svg_icons/saved.svg",
              color: Colors.white,
              matchTextDirection: true,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            "İstek Gönderildi",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(color: const Color(0xFFFFFFFF), fontSize: 14),
          ),
          const SizedBox.square(
            dimension: 5,
          )
        ],
      ),
    );
  }

  InkWell _buildAcceptStatus() {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.5),
            child: SvgPicture.asset(
              "assets/images/svg_icons/saved.svg",
              color: Colors.white,
              matchTextDirection: true,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            "Kabul Et",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(color: const Color(0xFFFFFFFF), fontSize: 14),
          ),
          const SizedBox.square(
            dimension: 5,
          )
        ],
      ),
    );
  }

  InkWell _buildConnectedStatus(MyUser otherUser, BuildContext context) {
    return InkWell(
      onTap: () {
        Chat currentChat =  Chat(
            hostID: otherUser.userID,
            isLastMessageFromMe: false,
            isLastMessageReceivedByHost: true,
            isLastMessageSeenByHost: true,
            lastMessageCreatedAt: DateTime.now(),
            lastMessage: "",
            numberOfMessagesThatIHaveNotOpened: 0);

        currentChat.hostUserProfileUrl = otherUser.profileURL;
        currentChat.hostUserName = otherUser.displayName;

        UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
        _userBloc.mainKey.currentState?.push(
          MaterialPageRoute(builder: (context) => MessageScreen(currentChat: currentChat,)),
        );
      },
      child: Text(
        "Mesajlaş",
        textScaleFactor: 1,
        style: GoogleFonts.rubik(color: const Color(0xFFFFFFFF), fontSize: 14),
      ),
    );
  }

  mutualFriends(context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.people,
                color: Colors.grey[500],
              ),
              mutualConnectionUserIDs.isNotEmpty
                  ? Text(
                      "${mutualConnectionUserIDs.length} ortak bağlantı",
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(
            height: 3,
          ),

          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.transparent, //Colors.pinkAccent,
                child: Center(
                  child: Stack(
                    children: [
                      profileData.mutualConnectionsProfilePhotos.length >= 3 ? mutualFriendProfilePhotoItem(context, 0, profileData.mutualConnectionsProfilePhotos[2]) : const SizedBox(),
                      profileData.mutualConnectionsProfilePhotos.length >= 2 ? mutualFriendProfilePhotoItem(context, 1, profileData.mutualConnectionsProfilePhotos[1]) : const SizedBox(),
                      profileData.mutualConnectionsProfilePhotos.isNotEmpty  ? mutualFriendProfilePhotoItem(context, 2, profileData.mutualConnectionsProfilePhotos[0]) : const SizedBox(),
                    ],
                  ),
                ),
              ),
              Text(
                profileData.mutualConnectionsProfilePhotos.length > 3 ? "  +${profileData.mutualConnectionsProfilePhotos.length-3}" : "", //+0 bağlantı hatasını önlemek için.
                textScaleFactor: 1,
                style: GoogleFonts.rubik(fontSize: _customSmallTextSize(), color:  Color(0xFF0353EF)),
              ),
            ],
          ),
           */
        ],
      ),
    );
  }

  Row buildLike(index) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/svg_icons/smile.svg",
          color: Colors.pink,
          fit: BoxFit.contain,
        ),
        //build   },
        //),
        const SizedBox(
          width: 5,
        ),

        Text(
          myActivities[index].liked.toString(),
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            color: _mode.blackAndWhiteConversion(),
          ),
        )
      ],
    );
  }

  Row buildDislike(int index) {
    return Row(
      children: [
        SizedBox(
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              "assets/images/svg_icons/meh.svg",
              color: _mode.blackAndWhiteConversion(),
              fit: BoxFit.contain,
            )),
        const SizedBox(
          width: 5,
        ),
        Text(
          myActivities[index].disliked.toString(),
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            color: _mode.blackAndWhiteConversion(),
          ),
        ),
      ],
    );
  }

  activityList(BuildContext context) {
    int minNumberOfActivity = 1;
    ValueNotifier<int> numberOfActivity = ValueNotifier(minNumberOfActivity + 1); //profileData.experiences.length+1;
    return myActivities.isEmpty
        ? const SizedBox.shrink()
        : ValueListenableBuilder(
            valueListenable: numberOfActivity,
            builder: (context, snapshot, _) {
              numberOfActivity.value;
              return Column(
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
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      //i use +1 because last index for less more see more widget
                      itemCount: numberOfActivity.value,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                        parent: NeverScrollableScrollPhysics(),
                      ),
                      itemBuilder: (context, index) {
                        if (index == numberOfActivity.value - 1) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllActivityListOthersProfile(
                                        profileData: profileData, myActivities: myActivities)),
                              );

                              numberOfActivity.value == minNumberOfActivity + 1
                                  ? numberOfActivity.value = myActivities.length + 1
                                  : numberOfActivity.value = minNumberOfActivity + 1;
                              debugPrint("çalıştı .........");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: _mode.bottomMenuBackground(),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Color(0xFF939393).withOpacity(0.6),
                                      blurRadius: 0.5,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 0))
                                ],
                                //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                              ),
                              child: Center(
                                  child: Text(
                                numberOfActivity.value == minNumberOfActivity + 1
                                    ? "Daha Fazla Göster"
                                    : "Daha Az Göster",
                                textScaleFactor: 1,
                                style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 16),
                              )),
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: _mode.bottomMenuBackground(),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color(0xFF939393).withOpacity(0.6),
                                    blurRadius: 0.5,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 0))
                              ],
                              //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      profileData.pplName!,
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                          fontSize: 14,
                                          color: _mode.blackAndWhiteConversion(),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      " " + activityText(index),
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                          fontSize: 14,
                                          color: _mode.blackAndWhiteConversion(),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                MediaQuery.of(context).size.width < 320
                                    ? SizedBox.shrink()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          buildDislike(index),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width < 600
                                                ? MediaQuery.of(context).size.width * 0.05
                                                : 600 * 0.05,
                                          ),
                                          buildLike(index),
                                        ],
                                      ),
                              ],
                            ),
                          );
                        }
                      }),
                ],
              );
            });
  }

  experiencesList(BuildContext context) {
    int minNumberOfExperience = 3;
    ValueNotifier<int> numberOfExperience = profileData.hobbies.length < ValueNotifier(minNumberOfExperience + 1).value
        ? ValueNotifier(profileData.hobbies.length)
        : ValueNotifier(minNumberOfExperience + 1); //profileData.experiences.length+1;
    double _photoSize = 50;

    return ValueListenableBuilder(
        valueListenable: numberOfExperience,
        builder: (context, snapshot, _) {
          numberOfExperience.value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  "Deneyimler",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                    color: _mode.blackAndWhiteConversion(),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              profileData.hobbies.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      //i use +1 because last index for less more see more widget
                      itemCount: numberOfExperience.value,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                        parent: NeverScrollableScrollPhysics(),
                      ),
                      itemBuilder: (context, index) {
                        String hobbyDateRange(index) {
                          DateTime _startDate = DateTime(int.parse(profileData.hobbies[index].split("%")[2]),
                              monthToInt(profileData.hobbies[index].split("%")[1]));
                          DateTime _finishDate = profileData.hobbies[index].split("%").length == 3
                              ? DateTime.now()
                              : DateTime(int.parse(profileData.hobbies[index].split("%")[4]),
                                  monthToInt(profileData.hobbies[index].split("%")[3]));

                          int _days = _finishDate.difference(_startDate).inDays;
                          int _months = _days ~/ 30 != 0 ? _days ~/ 30 : 1;
                          if (_months < 12) {
                            return "$_months Ay";
                          } else if (_months >= 12) {
                            return "${_months ~/ 12} Yıl " + (_months % 12 != 0 ? "${_months % 12} Ay" : "");
                          } else {
                            return "error";
                          }
                        }

                        if (profileData.hobbies.length > numberOfExperience.value &&
                            index == numberOfExperience.value - 1) {
                          return InkWell(
                            onTap: () {
                              /*
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                         AllExperienceList(profileData: profileData, myActivities: myActivities)),
                              );

                               */

                              /*
                        numberOfExperience.value == minNumberOfExperience+1
                            ? numberOfExperience.value = profileData.experiences.length+1
                            : numberOfExperience.value = minNumberOfExperience+1;
                        print("çalıştı .........");
                         */
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: _mode.bottomMenuBackground(),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Color(0xFF939393).withOpacity(0.6),
                                      blurRadius: 0.5,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 0))
                                ],
                                //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                              ),
                              child: Center(
                                  child: Text(
                                numberOfExperience.value == minNumberOfExperience + 1
                                    ? "Daha Fazla Göster"
                                    : "Daha Az Göster",
                                textScaleFactor: 1,
                                style: GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 16),
                              )),
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: _mode.bottomMenuBackground(),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color(0xFF939393).withOpacity(0.6),
                                    blurRadius: 0.5,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 0))
                              ],
                              //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                            ),
                            child: Row(
                              children: [
                                MediaQuery.of(context).size.width < 320
                                    ? const SizedBox.shrink()
                                    : Stack(
                                        children: [
                                          Container(
                                            height: _photoSize,
                                            width: _photoSize,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(999),
                                                border: Border.all(
                                                  width: 1,
                                                  color: _mode.search_peoples_scaffold_background() as Color,
                                                )),
                                            child: CircleAvatar(
                                              backgroundColor: Color(0xFF0353EF),
                                              child: Text("ppl$index",
                                                  textScaleFactor: 1, style: GoogleFonts.rubik(fontSize: 12)),
                                            ),
                                          ),
                                          Container(
                                              height: _photoSize,
                                              width: _photoSize,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(999),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: _mode.search_peoples_scaffold_background() as Color,
                                                  )),
                                              child: hobbyItem(0, profileData.hobbies[index].split("%").first)),
                                        ],
                                      ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profileData.hobbies[index].split("%")[0],
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                          color: _mode.blackAndWhiteConversion(),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${profileData.hobbies[index].split("%")[1]} ${profileData.hobbies[index].split("%")[2]}" +
                                              (profileData.hobbies[index].split("%").length == 3
                                                  ? " - halen"
                                                  : " - ${profileData.hobbies[index].split("%")[3]} ${profileData.hobbies[index].split("%")[4]}") +
                                              " ~ " +
                                              hobbyDateRange(index),
                                          textScaleFactor: 1,
                                          style:
                                              GoogleFonts.rubik(color: _mode.blackAndWhiteConversion(), fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      }),
            ],
          );
        });
  }

  schoolName(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return profileData.schoolName != ""
        ? SizedBox(
            width: (screenWidth / 2) - 25,
            child: Text(
              profileData.schoolName,
              textScaleFactor: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: _mode.blackAndWhiteConversion(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  currentJob(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return profileData.schoolName != ""
        ? SizedBox(
            width: (screenWidth / 2) - 25,
            child: Text(
              profileData.currentJobName,
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: _mode.blackAndWhiteConversion(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  companyName() {
    return profileData.company != ""
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              profileData.company + "'da çalışıyor",
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: GoogleFonts.rubik(
                fontSize: 14,
                color: _mode.blackAndWhiteConversion(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  /*
  String hobbyDateRange(index) {
    DateTime _startDate =
    DateTime.parse(profileData.experiences.values.elementAt(index)[0]);
    DateTime _finishDate = DateTime.parse(
      //bitiş tarihi girilmiş mi girilmemiş mi kontorlünü sağlama
      profileData.experiences.values.elementAt(index).length == 2
          ? profileData.experiences.values.elementAt(index)[1]
          : DateTime.now().toString(),
    );
    int _days = _finishDate.difference(_startDate).inDays;
    int _months = _days ~/ 30 != 0 ? _days ~/ 30 : 1;
    if (_months < 12) {
      return "$_months Ay";
    } else if (_months >= 12) {
      return "${_months ~/ 12} Yıl " +
          (_months % 12 != 0 ? "${_months % 12} Ay" : "");
    } else {
      return "error";
    }
  }
   */

  intToMonthName(int monthNumber, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    switch (monthNumber) {
      case 1:
        {
          return screenWidth < 360 ? "Oca" : "Ocak";
        }
      case 2:
        {
          return screenWidth < 360 ? "Şub" : "Şubat";
        }
      case 3:
        {
          return screenWidth < 360 ? "Mar" : "Mart";
        }
      case 4:
        {
          return screenWidth < 360 ? "Nis" : "Nisan";
        }
      case 5:
        {
          return screenWidth < 360 ? "May" : "Mayıs";
        }
      case 6:
        {
          return screenWidth < 360 ? "Haz" : "Haziran";
        }
      case 7:
        {
          return screenWidth < 360 ? "Tem" : "Temmuz";
        }
      case 8:
        {
          return screenWidth < 360 ? "Ağu" : "Ağustos";
        }
      case 9:
        {
          return screenWidth < 360 ? "Eyl" : "Eylül";
        }
      case 10:
        {
          return screenWidth < 360 ? "Eki" : "Ekim";
        }
      case 11:
        {
          return screenWidth < 360 ? "Kas" : "Kasım";
        }
      case 12:
        {
          return screenWidth < 360 ? "Ara" : "Aralık";
        }
    }
  }

  String activityText(index) {
    switch (myActivities[index].activityType) {
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

  Container hobbyItem(double marginLeft, hobbyName) {
    hobbyName = Hobby().stringToHobbyTypes(hobbyName);
    double _size = 34;
    return Container(
      height: _size,
      width: _size,
      margin: EdgeInsets.only(left: marginLeft),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: const Color(0xFF939393).withOpacity(0.6),
              blurRadius: 2.0,
              spreadRadius: 0,
              offset: const Offset(-1.0, 0.75))
        ],
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        color: Colors.white, //Colors.orange,
      ),
      child: SvgPicture.asset(
        "assets/images/hobby_badges/$hobbyName.svg",
        fit: BoxFit.contain,
        width: _size,
        height: _size,
      ),
    );
  }
}

enum SendRequestButtonStatus {
  save,         // If I have opened other user's profile from "nearby"
  saved,        // If I have added other user in nearby and waiting for timeout
  connect,      // If I have opened other user's profile from "feeds, city"
  requestSent,  // If I have sent a request and waiting for him/her to accept
  accept,       // If other user sent me a connection request and waiting for me to accept
  connected     // If we are friends!
}
