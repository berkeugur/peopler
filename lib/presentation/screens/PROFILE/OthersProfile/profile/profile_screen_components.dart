import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/CityBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/CityBloc/city_bloc.dart';
import 'package:peopler/business_logic/blocs/LocationBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/OtherUserBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/core/constants/reloader/reload.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/data/model/HobbyModels/hobbies.dart';
import 'package:peopler/presentation/screen_services/other_profile_service.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/ProfileScreen/hobby_functions.dart';
import 'package:peopler/presentation/screens/PROFILE/OthersProfile/profile/all_activity_list.dart';
import '../../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../../others/locator.dart';
import '../../../../../../others/strings.dart';
import '../../../../../business_logic/blocs/ChatBloc/bloc.dart';
import '../../../../../business_logic/blocs/NotificationBloc/bloc.dart';
import '../../../../../business_logic/blocs/OtherUserBloc/other_user_bloc.dart';
import '../../../../../business_logic/blocs/SavedBloc/bloc.dart';
import '../../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../../core/constants/enums/subscriptions_enum.dart';
import '../../../../../data/model/chat.dart';
import '../../../../../data/model/notifications.dart';
import '../../../../../data/model/saved_user.dart';
import '../../../../../data/repository/user_repository.dart';
import '../../../../../data/send_notification_service.dart';
import '../../../../../data/services/db/firestore_db_service_users.dart';
import '../../../../../others/widgets/snack_bars.dart';
import '../../../MESSAGE/message_screen.dart';

class ProfileScreenComponentsOthersProfile {
  final MyUser profileData;
  final List<String> mutualConnectionUserIDs;
  final List<MyActivity> myActivities;

  ProfileScreenComponentsOthersProfile({required this.profileData, required this.mutualConnectionUserIDs, required this.myActivities});

  final Mode _mode = locator<Mode>();

  nameField(SendRequestButtonStatus status) {
    return Text(
      ((status == SendRequestButtonStatus.save) || (status == SendRequestButtonStatus.saved)) ? profileData.pplName! : profileData.displayName,
      // profileData.isProfileVisible == true ? profileData.displayName : profileData.pplName!,
      textScaleFactor: 1,
      style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 18, fontWeight: FontWeight.w500),
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
                style: PeoplerTextStyle.normal.copyWith(
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
                BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
              ],
            ),
            width: MediaQuery.of(context).size.width,
            duration: const Duration(seconds: 1),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              profileData.biography,
              textScaleFactor: 1,
              style: PeoplerTextStyle.normal.copyWith(
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
            child: CachedNetworkImage(
              imageUrl: profileData.profileURL,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  ClipRRect(borderRadius: BorderRadius.circular(999), child: CircularProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            )),
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
    ValueNotifier<int> _itemCount = ValueNotifier(profileData.photosURL.length > _numberOfPhoto ? _numberOfPhoto + 1 : profileData.photosURL.length);

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
                          ? SizedBox(
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
                                        style: PeoplerTextStyle.normal.copyWith(
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
                              ? SizedBox(
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
                                            style: PeoplerTextStyle.normal.copyWith(
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
                                    color: Colors.grey[400],
                                  ),
                                  margin: EdgeInsets.only(
                                      left: index == 0 && profileData.photosURL.length >= 3
                                          ? 5
                                          : profileData.photosURL.length == 1
                                              ? 10
                                              : _photoPadding,
                                      right: _photoPadding),
                                  child: CachedNetworkImage(
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7.5),
                                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                      ),
                                    ),
                                    imageUrl: profileData.photosURL[index],
                                    progressIndicatorBuilder: (context, url, downloadProgress) => ClipRRect(
                                        borderRadius: BorderRadius.circular(7.5), child: LinearProgressIndicator(value: downloadProgress.progress)),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
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
          profileData.city,
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
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
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(width: 1, color: const Color(0xFF0353EF)),
        color: status == SendRequestButtonStatus.saved
            ? const Color(0xFF0353EF) //,_mode.inActiveColor()
            : const Color(0xFF0353EF),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: buttonContent(context, status, otherUser)),
        ],
      ),
    );
  }

  Widget buttonContent(BuildContext context, SendRequestButtonStatus status, MyUser otherUser) {
    switch (status) {
      case SendRequestButtonStatus.save:
        return _buildSaveStatus(context, otherUser.userID);
      case SendRequestButtonStatus.saved:
        return _buildSavedStatus();
      case SendRequestButtonStatus.connect:
        return _buildConnectStatus(context, otherUser.userID);
      case SendRequestButtonStatus.requestSent:
        return _buildRequestSentStatus(context, otherUser.userID);
      case SendRequestButtonStatus.accept:
        return _buildAcceptStatus(context, otherUser.userID, otherUser);
      case SendRequestButtonStatus.connected:
        return OtherProfileService().isMyConnection(otherProfileID: otherUser.userID)
            ? _buildConnectedStatus(otherUser, context)
            : _buildConnectStatus(context, otherUser.userID);
      default:
        return const Text("error");
    }
  }

  InkWell _buildSaveStatus(BuildContext context, String otherUserID) {
    return InkWell(
      onTap: () {
        SavedBloc _savedBloc = BlocProvider.of<SavedBloc>(context);

        MyUser otherUser = LocationBloc.allUserList.singleWhere((element) => element.userID == otherUserID);
        _savedBloc.add(ClickSaveButtonEvent(savedUser: otherUser, myUserID: UserBloc.user!.userID));

        OtherUserBloc _otherUserBloc = BlocProvider.of<OtherUserBloc>(context);
        _otherUserBloc.add(TrigStatusEvent(status: SendRequestButtonStatus.saved));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: SvgPicture.asset(
              "assets/images/svg_icons/saved.svg",
              color: Colors.white,
              matchTextDirection: true,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox.square(dimension: 5),
          Text(
            "Kaydet",
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFFFFFFFF), fontSize: 14),
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
      style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFFFFFFFF), fontSize: 14),
    );
  }

  InkWell _buildConnectStatus(BuildContext context, String otherUserID) {
    return InkWell(
      onTap: () async {
        if (UserBloc.entitlement == SubscriptionTypes.free && UserBloc.user!.numOfSendRequest < 1) {
          showNumOfConnectionRequestsConsumed(context);
          return;
        }

        if (UserBloc.entitlement == SubscriptionTypes.free && UserBloc.user!.numOfSendRequest == 1) {
          showNumOfConnectionRequestsConsumed(context);
        }

        OtherUserBloc _otherUserBloc = BlocProvider.of<OtherUserBloc>(context);
        _otherUserBloc.add(TrigStatusEvent(status: SendRequestButtonStatus.requestSent));

        SavedBloc _savedBloc = BlocProvider.of<SavedBloc>(context);

        final SendNotificationService _sendNotificationService = locator<SendNotificationService>();
        final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

        final UserRepository _userRepository = locator<UserRepository>();
        MyUser? otherUser = await _userRepository.getUserWithUserId(otherUserID);

        SavedUser _savedUser = SavedUser();
        _savedUser.userID = otherUser!.userID;
        _savedUser.pplName = otherUser.pplName!;
        _savedUser.displayName = otherUser.displayName;
        _savedUser.gender = otherUser.gender;
        _savedUser.profileURL = otherUser.profileURL;
        _savedUser.biography = otherUser.biography;
        _savedUser.hobbies = otherUser.hobbies;

        if (UserBloc.entitlement == SubscriptionTypes.free) {
          showRestNumOfConnectionRequests(context);
        }

        _savedBloc.add(ClickSendRequestButtonEvent(myUser: UserBloc.user!, savedUser: _savedUser));

        String? _token = await _firestoreDBServiceUsers.getToken(_savedUser.userID);
        if (_token != null) {
          await _sendNotificationService
              .sendNotification(
            Strings.sendRequest,
            _token,
            "",
            UserBloc.user!.displayName,
            UserBloc.user!.profileURL,
            UserBloc.user!.userID,
          )
              .then((value) {
            setTheme.value = !setTheme.value;
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          true
              ? const SizedBox.shrink()
              : SizedBox(
                  height: 16,
                  width: 16,
                  child: SvgPicture.asset(
                    "assets/images/svg_icons/saved.svg",
                    color: Colors.white,
                    matchTextDirection: true,
                    fit: BoxFit.contain,
                  ),
                ),
          const SizedBox.square(dimension: 5),
          Text(
            "Bağlantı Kur",
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFFFFFFFF), fontSize: 14),
          ),
          const SizedBox.square(dimension: 5)
        ],
      ),
    );
  }

  InkWell _buildBlockedStatus(BuildContext context, String otherUserID) {
    return InkWell(
      onTap: () async {
        final UserRepository _userRepository = locator<UserRepository>();
        _userRepository.unblockUser(UserBloc.user!.userID, otherUserID);

        OtherUserBloc _otherUserBloc = BlocProvider.of<OtherUserBloc>(context);
        _otherUserBloc.add(TrigStatusEvent(status: SendRequestButtonStatus.connect));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          true
              ? const SizedBox.shrink()
              : SizedBox(
                  height: 16,
                  width: 16,
                  child: SvgPicture.asset(
                    "assets/images/svg_icons/saved.svg",
                    color: Colors.white,
                    matchTextDirection: true,
                    fit: BoxFit.contain,
                  ),
                ),
          const SizedBox.square(dimension: 5),
          Text(
            "Engeli Kaldır",
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFFFFFFFF), fontSize: 14),
          ),
          const SizedBox.square(dimension: 5)
        ],
      ),
    );
  }

  Widget _buildRequestSentStatus(BuildContext context, String otherUserID) {
    return InkWell(
      onTap: () {
        if (UserBloc.entitlement == SubscriptionTypes.free) {
          showGeriAlWarning(context);
          return;
        }

        OtherUserBloc _otherUserBloc = BlocProvider.of<OtherUserBloc>(context);
        _otherUserBloc.add(TrigStatusEvent(status: SendRequestButtonStatus.connect));

        NotificationBloc _notificationBloc = BlocProvider.of<NotificationBloc>(context);
        _notificationBloc.add(GeriAlButtonEvent(requestUserID: otherUserID));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          true
              ? const SizedBox.shrink()
              : SizedBox(
                  height: 16,
                  width: 16,
                  child: SvgPicture.asset(
                    "assets/images/svg_icons/saved.svg",
                    color: Colors.white,
                    matchTextDirection: true,
                    fit: BoxFit.contain,
                  ),
                ),
          const SizedBox.square(dimension: 5),
          Text(
            "Geri Al",
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFFFFFFFF), fontSize: 14),
          ),
          const SizedBox.square(dimension: 5)
        ],
      ),
    );
  }

  InkWell _buildAcceptStatus(BuildContext context, String otherUserID, MyUser otherUser) {
    return InkWell(
      onTap: () {
        OtherUserBloc _otherUserBloc = BlocProvider.of<OtherUserBloc>(context);
        _otherUserBloc.add(TrigStatusEvent(status: SendRequestButtonStatus.connected));

        NotificationBloc _notificationBloc = BlocProvider.of<NotificationBloc>(context);
        Notifications _notification = _notificationBloc.allNotificationList.singleWhere((element) => element.requestUserID == otherUserID);

        ChatBloc _chatBloc = BlocProvider.of<ChatBloc>(context);

        _notificationBloc.add(ClickAcceptEvent(requestUserID: otherUserID));
        _notification.didAccepted = true;

        String? _hostUserID = _notification.requestUserID;
        String? _hostUserName = _notification.requestDisplayName;
        String? _hostUserProfileUrl = _notification.requestProfileURL;

        _chatBloc.add(CreateChatEvent(hostUserID: _hostUserID!, hostUserName: _hostUserName, hostUserProfileUrl: _hostUserProfileUrl));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          true
              ? const SizedBox.shrink()
              : Padding(
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
            style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFFFFFFFF), fontSize: 14),
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
        UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
        _userBloc.mainKey.currentState?.push(
          MaterialPageRoute(
              builder: (context) => MessageScreen(
                    requestUserID: otherUser.userID,
                    requestProfileURL: otherUser.profileURL,
                    requestDisplayName: otherUser.displayName,
                  )),
        );
      },
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/images/svg_icons/message_icon.svg",
            width: 16,
            color: Colors.white,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            "Mesajlaş",
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFFFFFFFF), fontSize: 14),
          ),
        ],
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
                      style: PeoplerTextStyle.normal.copyWith(
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
                style: PeoplerTextStyle.normal.copyWith(fontSize: _customSmallTextSize(), color:  Color(0xFF0353EF)),
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
          "assets/images/svg_icons/up_arrow.svg",
          color: Colors.green,
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
          style: PeoplerTextStyle.normal.copyWith(
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
              "assets/images/svg_icons/down_arrow.svg",
              color: _mode.blackAndWhiteConversion(),
              fit: BoxFit.contain,
            )),
        const SizedBox(
          width: 5,
        ),
        Text(
          myActivities[index].disliked.toString(),
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
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
                      style: PeoplerTextStyle.normal.copyWith(
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
                              showDialog(
                                context: context,
                                builder: (contextSD) => AlertDialog(
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                  contentPadding: const EdgeInsets.only(top: 20.0, bottom: 5, left: 25, right: 25),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Yakında...",
                                        textAlign: TextAlign.center,
                                        style: PeoplerTextStyle.normal.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(contextSD).pop();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(999),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 10,
                                          ),
                                          child: Text(
                                            "TAMAM",
                                            style: PeoplerTextStyle.normal.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              /*
                              

                              UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                              _userBloc.mainKey.currentState?.push(
                                MaterialPageRoute(builder: (context) => AllActivityListOthersProfile(profileData: profileData, myActivities: myActivities)),
                              );

                              numberOfActivity.value == minNumberOfActivity + 1
                                  ? numberOfActivity.value = myActivities.length + 1
                                  : numberOfActivity.value = minNumberOfActivity + 1;
                              debugPrint("çalıştı .........");
                              */
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: _mode.bottomMenuBackground(),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
                                ],
                                //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                              ),
                              child: Center(
                                  child: Text(
                                numberOfActivity.value == minNumberOfActivity + 1 ? "Daha Fazla Göster" : "Daha Az Göster",
                                textScaleFactor: 1,
                                style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 16),
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
                                    color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
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
                                      style: PeoplerTextStyle.normal
                                          .copyWith(fontSize: 14, color: _mode.blackAndWhiteConversion(), fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      " " + activityText(index),
                                      textScaleFactor: 1,
                                      style: PeoplerTextStyle.normal
                                          .copyWith(fontSize: 14, color: _mode.blackAndWhiteConversion(), fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                MediaQuery.of(context).size.width < 320
                                    ? const SizedBox.shrink()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          buildDislike(index),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width < 600 ? MediaQuery.of(context).size.width * 0.05 : 600 * 0.05,
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
                  style: PeoplerTextStyle.normal.copyWith(
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
                        if (profileData.hobbies.length > numberOfExperience.value && index == numberOfExperience.value - 1) {
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (contextSD) => AlertDialog(
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                  contentPadding: const EdgeInsets.only(top: 20.0, bottom: 5, left: 25, right: 25),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Yakında...",
                                        textAlign: TextAlign.center,
                                        style: PeoplerTextStyle.normal.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(contextSD).pop();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(999),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 10,
                                          ),
                                          child: Text(
                                            "TAMAM",
                                            style: PeoplerTextStyle.normal.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              );
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
                                      color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
                                ],
                                //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                              ),
                              child: Center(
                                  child: Text(
                                numberOfExperience.value == minNumberOfExperience + 1 ? "Daha Fazla Göster" : "Daha Az Göster",
                                textScaleFactor: 1,
                                style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 16),
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
                                    color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
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
                                              backgroundColor: const Color(0xFF0353EF),
                                              child: Text("ppl$index", textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(fontSize: 12)),
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
                                              child: hobbyItem(0, "hghg4425")),
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
                                      "r434rgf",
                                      textScaleFactor: 1,
                                      style: PeoplerTextStyle.normal
                                          .copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "sd213fdgdf",
                                          textScaleFactor: 1,
                                          style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 14),
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
              style: PeoplerTextStyle.normal.copyWith(
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
              style: PeoplerTextStyle.normal.copyWith(
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
              style: PeoplerTextStyle.normal.copyWith(
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
          BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 2.0, spreadRadius: 0, offset: const Offset(-1.0, 0.75))
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
