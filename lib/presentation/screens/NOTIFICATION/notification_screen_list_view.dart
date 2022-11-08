import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import '../../../business_logic/blocs/ChatBloc/bloc.dart';
import '../../../business_logic/blocs/NotificationBloc/bloc.dart';
import '../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../core/constants/enums/subscriptions_enum.dart';
import '../../../data/model/chat.dart';
import '../../../data/model/notifications.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import '../../../others/widgets/snack_bars.dart';
import '../MESSAGE/message_screen.dart';
import '../PROFILE/OthersProfile/functions.dart';
import '../PROFILE/OthersProfile/profile/profile_screen_components.dart';

String elapsedTime(String date) {
  DateTime _oldDay = DateTime.parse(date);
  int _subMinute = DateTime.now().difference(_oldDay).inMinutes;

  if (_subMinute == 0) {
    return "yeni";
  } else if (_subMinute < 60) {
    return "${_subMinute}dk"; //dakika
  } else if (_subMinute >= 60 && _subMinute < 24 * 60) {
    return "${(_subMinute / 60).toStringAsFixed(0)}sa"; //saat
  } else if (_subMinute >= 24 * 60 && _subMinute < 24 * 60 * 7) {
    return "${(_subMinute / (24 * 60)).toStringAsFixed(0)}gn"; //gün
  } else if (_subMinute >= 24 * 60 * 7) {
    return "${(_subMinute / (24 * 60 * 7)).toStringAsFixed(0)}hf"; //hafta
  }
  return "error";
}

String elapsedTimeLongText(String date) {
  DateTime _oldDay = DateTime.parse(date);
  int _subMinute = DateTime.now().difference(_oldDay).inMinutes;
  if (_subMinute == 0) {
    return "az";
  } else if (_subMinute < 60) {
    return "${(_subMinute)} dakika"; //dakika
  } else if (_subMinute >= 60 && _subMinute < 24 * 60) {
    return "${(_subMinute / 60).toStringAsFixed(0)} saat"; //saat
  } else if (_subMinute >= 24 * 60 && _subMinute < 24 * 60 * 7) {
    return "${(_subMinute / (24 * 60)).toStringAsFixed(0)} gün"; //gün
  } else if (_subMinute >= 24 * 60 * 7) {
    return "${(_subMinute / (24 * 60 * 7)).toStringAsFixed(0)} Hafta"; //hafta
  }
  return "error";
}

Widget customListItem(int index, context) {
  Size _size = MediaQuery.of(context).size;
  double _maxWidth = _size.width > 480 ? 480 : _size.width;

  double _leftColumnSize;
  double _screenWidth = _size.width;
  if (_screenWidth <= 320) {
    _leftColumnSize = 44;
  } else if (_screenWidth > 320 && _screenWidth < 480) {
    _leftColumnSize = 50;
  } else {
    _leftColumnSize = 54;
  }

  double _rightColumnSize = 30;
  double _centerColumnSize = _maxWidth - _leftColumnSize - _rightColumnSize - 40;

  double _customTextSize;
  if (_size.width <= 320) {
    _customTextSize = 12;
  } else if (_size.width > 320 && _size.width < 480) {
    _customTextSize = 13;
  } else {
    _customTextSize = 14;
  }

  double _customSmallTextSize;
  if (_size.width <= 320) {
    _customSmallTextSize = 10;
  } else if (_size.width > 320 && _size.width < 480) {
    _customSmallTextSize = 11;
  } else {
    _customSmallTextSize = 12;
  }

  NotificationBloc _notificationBloc = BlocProvider.of<NotificationBloc>(context);
  Notifications _notification = _notificationBloc.allNotificationList[index];

  switch (_notification.notificationType) {
    case 'ReceivedRequest':
      {
        return inComingRequestNotificationWidget(
            _maxWidth, _leftColumnSize, context, _notification, _centerColumnSize, _customTextSize, _customSmallTextSize, _rightColumnSize, index);
      }
    case 'TransmittedRequest':
      {
        return acceptYourRequestWidget(_maxWidth, _leftColumnSize, context, _notification, _centerColumnSize, _customTextSize, _rightColumnSize);
      }
    case 'AddedToSaved':
      {
        return youAreOnTheOtherPeoplesList(_maxWidth, _leftColumnSize, context, _notification, _centerColumnSize, _customTextSize, _rightColumnSize);
      }
    case 'NewFeeds':
      {
        return newFeedWidget(_maxWidth, _leftColumnSize, context, _notification, _centerColumnSize, _customTextSize, _rightColumnSize);
      }
  }
  return const Text(
    "error: unknown class",
    textScaleFactor: 1,
  );
}

Container newFeedWidget(double _maxWidth, double _leftColumnSize, context, Notifications _data, double _centerColumnSize, double _customTextSize,
    double _rightColumnSize) {
  final Mode _mode = locator<Mode>();
  return Container(
    width: _maxWidth,
    decoration: _boxDecoration(),
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          //color: Colors.green,
          width: _leftColumnSize,
          height: _leftColumnSize,
          child: profilePhoto(context, _data.requestProfileURL, _data.requestUserID!),
        ),
        SizedBox(
          //color: Colors.orange,
          width: _centerColumnSize,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: RichText(
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    text: TextSpan(
                        text: "Feedinde ",
                        style: TextStyle(
                          color: _mode.blackAndWhiteConversion(),
                          fontSize: _customTextSize,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "yeni " + _data.numberOfNewFeed.toString() + " paylaşım",
                            style: TextStyle(color: const Color(0xFF0353EF), fontSize: _customTextSize),
                          ),
                          TextSpan(
                              text: " seni bekliyor.",
                              style: TextStyle(
                                color: _mode.blackAndWhiteConversion(),
                                fontSize: _customTextSize,
                              ))
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0353EF),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    "Gör",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      fontSize: _customTextSize - 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          //color: Colors.red,
          width: _rightColumnSize,
          height: 70,
          child: _rightColumn(context, _data, _customTextSize - 2),
        )
      ],
    ),
  );
}

Container youAreOnTheOtherPeoplesList(double _maxWidth, double _leftColumnSize, context, Notifications _data, double _centerColumnSize,
    double _customTextSize, double _rightColumnSize) {
  final Mode _mode = locator<Mode>();
  return Container(
    width: _maxWidth,
    decoration: _boxDecoration(),
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          //color: Colors.green,
          width: _leftColumnSize,
          height: _leftColumnSize,
          child: profilePhoto(context, _data.requestProfileURL, _data.requestUserID!),
        ),
        SizedBox(
          //color: Colors.orange,
          width: _centerColumnSize,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: RichText(
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    text: TextSpan(
                        text: "Bugün ",
                        style: TextStyle(
                          color: _mode.blackAndWhiteConversion(),
                          fontSize: _customTextSize,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: _data.youAreOnOtherPeoplesListLength.toString() + " kişinin",
                            style: TextStyle(color: const Color(0xFF0353EF), fontSize: _customTextSize),
                          ),
                          TextSpan(
                              text: " listesine eklendin.",
                              style: TextStyle(
                                color: _mode.blackAndWhiteConversion(),
                                fontSize: _customTextSize,
                              ))
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0353EF),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    "Kim olduklarını gör",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      fontSize: _customTextSize - 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          //color: Colors.red,
          width: _rightColumnSize,
          height: 70,
          child: _rightColumn(context, _data, _customTextSize - 2),
        )
      ],
    ),
  );
}

Widget acceptYourRequestWidget(double _maxWidth, double _leftColumnSize, context, Notifications _data, double _centerColumnSize,
    double _customTextSize, double _rightColumnSize) {
  final Mode _mode = locator<Mode>();
  return Container(
    width: _maxWidth,
    decoration: _boxDecoration(),
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          //color: Colors.green,
          width: _leftColumnSize,
          height: _leftColumnSize,
          child: profilePhoto(context, _data.requestProfileURL, _data.requestUserID!),
        ),
        SizedBox(
          //color: Colors.orange,
          width: _centerColumnSize,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: RichText(
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    text: TextSpan(
                        text: _data.requestDisplayName,
                        style: TextStyle(
                          color: const Color(0xFF0353EF),
                          fontSize: _customTextSize,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: _data.didAccepted! ? ', bağlantı isteğini kabul etti.' : ', isteğinizi henüz görmemiş olabilir. Sabırlı olun :) ',
                            style: TextStyle(color: _mode.blackAndWhiteConversion(), fontSize: _customTextSize),
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  child: Text(
                    _data.requestBiography,
                    style: PeoplerTextStyle.normal.copyWith(fontSize: _customTextSize - 1, color: Colors.grey),
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                InkWell(
                  onTap: () {
                    if (_data.didAccepted!) {
                      UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                      _userBloc.mainKey.currentState?.push(
                        MaterialPageRoute(
                            builder: (context) => MessageScreen(
                                  requestUserID: _data.requestUserID!,
                                  requestProfileURL: _data.requestProfileURL,
                                  requestDisplayName: _data.requestDisplayName,
                                )),
                      );
                    } else {
                      _clickGeriAl(context, _data);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0353EF),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      _data.didAccepted! ? "Mesajlaş" : "Geri Al",
                      textScaleFactor: 1,
                      style: PeoplerTextStyle.normal.copyWith(
                        fontSize: _customTextSize - 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          //color: Colors.red,
          width: _rightColumnSize,
          height: 70,
          child: _rightColumn(context, _data, _customTextSize - 2),
        )
      ],
    ),
  );
}

void _clickGeriAl(BuildContext context, Notifications notification) {
  if (UserBloc.entitlement == SubscriptionTypes.free) {
    showGeriAlWarning(context);
    return;
  }

  NotificationBloc _notificationBloc = BlocProvider.of<NotificationBloc>(context);
  _notificationBloc.add(GeriAlButtonEvent(requestUserID: notification.requestUserID!));
}

Widget inComingRequestNotificationWidget(double _maxWidth, double _leftColumnSize, context, Notifications _data, double _centerColumnSize,
    double _customTextSize, double _customSmallTextSize, double _rightColumnSize, index) {
  final Mode _mode = locator<Mode>();
  return Container(
    width: _maxWidth,
    decoration: _boxDecoration(),
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          //color: Colors.green,
          width: _leftColumnSize,
          height: _leftColumnSize,
          child: profilePhoto(context, _data.requestProfileURL, _data.requestUserID!),
        ),
        SizedBox(
          //color: Colors.orange,
          width: _centerColumnSize,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: RichText(
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    text: TextSpan(
                        text: _data.requestDisplayName,
                        style: TextStyle(
                          color: const Color(0xFF0353EF),
                          fontSize: _customTextSize,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: _data.didAccepted! ? ', artık arkadaşınız.' : ', sana bağlantı isteği gönderdi',
                            style: TextStyle(color: _mode.blackAndWhiteConversion(), fontSize: _customTextSize),
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  child: Text(
                    _data.requestBiography,
                    style: PeoplerTextStyle.normal.copyWith(fontSize: _customTextSize - 1, color: Colors.grey),
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 7,
                ),
                InkWell(
                  onTap: () {
                    if (_data.didAccepted!) {
                      UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                      _userBloc.mainKey.currentState?.push(
                        MaterialPageRoute(
                            builder: (context) => MessageScreen(
                                  requestUserID: _data.requestUserID!,
                                  requestProfileURL: _data.requestProfileURL,
                                  requestDisplayName: _data.requestDisplayName,
                                )),
                      );
                    } else {
                      _clickAccept(context, _data, index);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0353EF),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      _data.didAccepted! ? "Mesajlaş" : "Kabul Et",
                      textScaleFactor: 1,
                      style: PeoplerTextStyle.normal.copyWith(
                        fontSize: _customTextSize - 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          //color: Colors.red,
          width: _rightColumnSize,
          height: 70,
          child: _rightColumn(context, _data, _customTextSize - 2),
        )
      ],
    ),
  );
}

void _clickAccept(context, Notifications _data, index) {
  ChatBloc _chatBloc = BlocProvider.of<ChatBloc>(context);

  NotificationBloc notificationBloc = BlocProvider.of<NotificationBloc>(context);

  notificationBloc.add(ClickAcceptEvent(requestUserID: _data.requestUserID!));
  notificationBloc.allNotificationList[index].didAccepted = true;

  String? _hostUserID = notificationBloc.allNotificationList[index].requestUserID;
  String? _hostUserName = notificationBloc.allNotificationList[index].requestDisplayName;
  String? _hostUserProfileUrl = notificationBloc.allNotificationList[index].requestProfileURL;

  _chatBloc.add(CreateChatEvent(hostUserID: _hostUserID!, hostUserName: _hostUserName, hostUserProfileUrl: _hostUserProfileUrl));
}

Column _rightColumn(context, Notifications _data, double _customTextSize) {
  final Mode _mode = locator<Mode>();
  NotificationBloc _notificationBloc = BlocProvider.of<NotificationBloc>(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      AutoSizeText(
        elapsedTime(_data.createdAt.toString()),
        textScaleFactor: 1,
        style: PeoplerTextStyle.normal.copyWith(
          fontSize: _customTextSize,
          color: _mode.blackAndWhiteConversion(),
        ),
      ),
      IconButton(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerRight,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF0353EF),
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        //delete notification function
                        _notificationBloc.add(DeleteNotification(notificationID: _data.notificationID));
                        Navigator.pop(context);
                      },
                      leading: const Icon(
                        Icons.delete_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Bildirimi Sil',
                        style: PeoplerTextStyle.normal.copyWith(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                );
              });
        },
        icon: Icon(
          Icons.more_vert_outlined,
          size: _customTextSize * 1.5,
          color: _mode.blackAndWhiteConversion(),
        ),
      ),
    ],
  );
}

BoxDecoration _boxDecoration() {
  final Mode _mode = locator<Mode>();
  return BoxDecoration(
    color: _mode.bottomMenuBackground(),
    boxShadow: <BoxShadow>[BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))],
    //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
  );
}

Stack profilePhoto(BuildContext context, String _data, String userID) {
  double _screenWidth = MediaQuery.of(context).size.width;
  double _photoSize;
  if (_screenWidth <= 320) {
    _photoSize = 40;
  } else if (_screenWidth > 320 && _screenWidth < 480) {
    _photoSize = 48;
  } else {
    _photoSize = 54;
  }

  return Stack(
    children: [
      SizedBox(
        height: _photoSize,
        width: _photoSize,
        child: const CircleAvatar(
          backgroundColor: Color(0xFF0353EF),
          child: Text(
            "ppl",
            textScaleFactor: 1,
          ),
        ),
      ),
      InkWell(
        onTap: () => openOthersProfile(context, userID, SendRequestButtonStatus.connect),
        child: SizedBox(
            height: _photoSize,
            width: _photoSize,
            child: //_userBloc != null ?
                CachedNetworkImage(
              imageUrl: _data,
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
      ),
    ],
  );
}

Container mutualFriendProfilePhotoItem(BuildContext context, int index, String photoUrl) {
  double _screenWidth = MediaQuery.of(context).size.width;
  double _itemSize() {
    if (_screenWidth <= 320) {
      return 24;
    } else if (_screenWidth > 320 && _screenWidth < 480) {
      return 26;
    } else {
      return 30;
    }
  }

  double _customMarginLeftValue() {
    switch (index) {
      case 0:
        {
          return _itemSize() * 0.75 * 2;
        }
      case 1:
        {
          return _itemSize() * 0.75 * 1;
        }
      case 2:
        {
          return _itemSize() * 0.75 * 0;
        }
    }
    return 0;
  }

  return Container(
    height: _itemSize(),
    width: _itemSize(),
    margin: EdgeInsets.only(left: _customMarginLeftValue()),
    decoration: BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 2.0, spreadRadius: 0, offset: const Offset(1.0, 0.75))
      ],
      borderRadius: const BorderRadius.all(Radius.circular(999)),
      color: Colors.white, //Colors.orange,
    ),
    child: Stack(
      children: [
        SizedBox(
          height: _itemSize(),
          width: _itemSize(),
          child: const CircleAvatar(
            backgroundColor: Color(0xFF0353EF),
            child: Text(
              "ppl",
              style: TextStyle(fontSize: 10),
              textScaleFactor: 1,
            ),
          ),
        ),
        SizedBox(
            height: _itemSize(),
            width: _itemSize(),
            child: CachedNetworkImage(
              imageUrl: photoUrl,
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
    ),
  );
}
