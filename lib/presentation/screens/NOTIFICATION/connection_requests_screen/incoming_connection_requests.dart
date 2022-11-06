import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/ChatBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import '../../../../business_logic/blocs/NotificationReceivedBloc/bloc.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../data/model/notifications.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/empty_list.dart';
import '../../../../others/locator.dart';
import '../../MESSAGE/message_screen.dart';
import '../notification_screen_list_view.dart';

/*
//sayfa değiştiğinde 2 listenin sıfırlanması ve fakeInComingRequestteki seçili index elemanların silinmesi gerekiyor
List<int> acceptedIndex = [];
List<int> notAcceptedIndex = [];

List<InComingRequest> fakeInComingRequests = [
  InComingRequest(
    type: NotificationType.inComingRequest,
    profilePhotoUrl: "https://i.picsum.photos/id/402/500/500.jpg?hmac=_x8LTdT3JIoZepA560TkobNXMZ5o9ZZ_M2Z_YjRInp8",
    fullName: "Berke Uğur",
    biography: "berkeleri severim. berkeleri severim. berkeleri severim.berkeleri severim.berkeleri severim.berkeleri severim.berkeleri severim.berkeleri severim.",
    mutualConnectionsProfilePhotos: [
      "https://i.picsum.photos/id/402/500/500.jpg?hmac=_x8LTdT3JIoZepA560TkobNXMZ5o9ZZ_M2Z_YjRInp8",
      "https://i.picsum.photos/id/402/500/500.jpg?hmac=_x8LTdT3JIoZepA560TkobNXMZ5o9ZZ_M2Z_YjRInp8",
      "https://i.picsum.photos/id/402/500/500.jpg?hmac=_x8LTdT3JIoZepA560TkobNXMZ5o9ZZ_M2Z_YjRInp8",
      "https://i.picsum.photos/id/402/500/500.jpg?hmac=_x8LTdT3JIoZepA560TkobNXMZ5o9ZZ_M2Z_YjRInp8",
      "https://i.picsum.photos/id/402/500/500.jpg?hmac=_x8LTdT3JIoZepA560TkobNXMZ5o9ZZ_M2Z_YjRInp8",
    ],
    dateTime: "2022-04-16 10:44:24.720",
  ),
  InComingRequest(
    type: NotificationType.inComingRequest,
    profilePhotoUrl: "https://i.picsum.photos/id/402/500/500.jpg?hmac=_x8LTdT3JIoZepA560TkobNXMZ5o9ZZ_M2Z_YjRInp8",
    fullName: "Berke Uğur",
    biography: "berkeleri severim. berkeleri severim. berkeleri severim.berkeleri severim.berkeleri severim.berkeleri severim.berkeleri severim.berkeleri severim.",
    mutualConnectionsProfilePhotos: [
      "https://i.picsum.photos/id/402/500/500.jpg?hmac=_x8LTdT3JIoZepA560TkobNXMZ5o9ZZ_M2Z_YjRInp8",
      "https://i.picsum.photos/id/402/500/500.jpg?hmac=_x8LTdT3JIoZepA560TkobNXMZ5o9ZZ_M2Z_YjRInp8",
    ],
    dateTime: "2022-04-16 10:44:24.720",
  ),

];


 */
class InComingConnectionRequestList extends StatefulWidget {
  const InComingConnectionRequestList({Key? key}) : super(key: key);

  @override
  _InComingConnectionRequestListState createState() => _InComingConnectionRequestListState();
}

class _InComingConnectionRequestListState extends State<InComingConnectionRequestList> {
  late final NotificationReceivedBloc _notificationReceivedBloc;
  late final ChatBloc _chatBloc;
  final Mode _mode = locator<Mode>();

  late ScrollController _scrollController;
  bool loading = false;

  @override
  void initState() {
    _notificationReceivedBloc = BlocProvider.of<NotificationReceivedBloc>(context);
    _notificationReceivedBloc.add(GetInitialDataReceivedEvent());
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _maxWidth = _size.width > 480 ? 480 : _size.width;

    final Mode _mode = locator<Mode>();
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Expanded(
            child: Container(
              color: _mode.search_peoples_scaffold_background(),
              child: SizedBox(
                  width: _maxWidth,
                  child: NotificationListener(
                    onNotification: (ScrollNotification scrollNotification) =>
                        _listScrollListener(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          BlocBuilder<NotificationReceivedBloc, NotificationReceivedState>(
                            bloc: _notificationReceivedBloc,
                            builder: (context, state) {
                              if (state is InitialNotificationReceivedState) {
                                return _initialNotificationsReceivedStateWidget();
                              } else if (state is NotificationReceivedNotExistState) {
                                return _noNotificationsReceivedExistsWidget();
                              } else if (state is NotificationReceivedLoaded1State) {
                                loading = false;
                                return _showNotificationsReceived();
                              } else if (state is NotificationReceivedLoaded2State) {
                                loading = false;
                                return _showNotificationsReceived();
                              } else if (state is NoMoreNotificationReceivedState) {
                                return _showNotificationsReceived();
                              } else if (state is NewNotificationReceivedLoadingState) {
                                return _showNotificationsReceived();
                              } else {
                                return const Text("Impossible");
                              }
                            },
                          ),
                          BlocBuilder<NotificationReceivedBloc, NotificationReceivedState>(
                              bloc: _notificationReceivedBloc,
                              builder: (context, state) {
                                if (state is NewNotificationReceivedLoadingState) {
                                  return _notificationsReceivedLoadingCircularButton();
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                        ],
                      ),
                    ),
                  )),
            ),
          );
        });
  }

  SizedBox _showNotificationsReceived() {
    return SizedBox(
      child: ListView.builder(
        itemCount: _notificationReceivedBloc.allReceivedList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Notifications _currentItem = _notificationReceivedBloc.allReceivedList[index];
          if (_currentItem.didAccepted == true) {
            return acceptedListItem(context, index);
          } else {
            return inComingRequestWidget(context, index, setState);
          }
        },
      ),
    );
  }

  SizedBox _initialNotificationsReceivedStateWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  EmptyList _noNotificationsReceivedExistsWidget() {
    return const EmptyList(
      emptyListType: EmptyListType.incomingRequest,
      isSVG: true,
    );
  }

  Padding _notificationsReceivedLoadingCircularButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: const [
        Expanded(flex: 5, child: SizedBox()),
        Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
        Expanded(flex: 5, child: SizedBox()),
      ]),
    );
  }

  Container acceptedListItem(BuildContext context, int index) {
    Notifications _currentItem = _notificationReceivedBloc.allReceivedList[index];

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

    double _centerColumnSize = _maxWidth - _leftColumnSize - 40 - 10;

    double _customTextSize;
    if (_size.width <= 320) {
      _customTextSize = 12;
    } else if (_size.width > 320 && _size.width < 480) {
      _customTextSize = 13;
    } else {
      _customTextSize = 14;
    }

    return Container(
      width: _maxWidth,
      decoration: BoxDecoration(
        color: _mode.bottomMenuBackground(),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))],
        //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          SizedBox(
            //color: Colors.green,
            width: _leftColumnSize,
            height: _leftColumnSize,
            child: profilePhoto(context, _currentItem.requestProfileURL, _currentItem.requestUserID!),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: _centerColumnSize,
            child: RichText(
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              text: TextSpan(
                  text: _currentItem.requestDisplayName + " artık bağlantınız. ",
                  style: PeoplerTextStyle.normal.copyWith(
                    color: _mode.blackAndWhiteConversion(),
                    fontSize: _customTextSize,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                          _userBloc.mainKey.currentState?.push(
                            MaterialPageRoute(
                                builder: (context) => MessageScreen(
                                      requestUserID: _currentItem.notificationID,
                                      requestProfileURL: _currentItem.requestProfileURL,
                                      requestDisplayName: _currentItem.requestDisplayName,
                                    )),
                          );
                        },
                      text: _currentItem.requestDisplayName + " ile konuşma başlat.",
                      style: PeoplerTextStyle.normal.copyWith(color: Color(0xFF0353EF), fontSize: _customTextSize),
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }

  Container noAcceptedListItem(BuildContext context, int index) {
    Size _size = MediaQuery.of(context).size;
    double _maxWidth = _size.width > 480 ? 480 : _size.width;
    double _leftColumnSize() {
      double _screenWidth = _size.width;
      if (_screenWidth <= 320) {
        return 44;
      } else if (_screenWidth > 320 && _screenWidth < 480) {
        return 50;
      } else {
        return 54;
      }
    }

    double _centerColumnSize = _maxWidth - _leftColumnSize() - 40 - 10;

    double _customTextSize() {
      if (_size.width <= 320) {
        return 12;
      } else if (_size.width > 320 && _size.width < 480) {
        return 13;
      } else {
        return 14;
      }
    }

    final Mode _mode = locator<Mode>();
    return Container(
      width: _maxWidth,
      decoration: BoxDecoration(
        color: _mode.bottomMenuBackground(),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))],
        //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          SizedBox(
            //color: Colors.green,
            width: _leftColumnSize(),
            height: _leftColumnSize(),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: _centerColumnSize,
            child: Text(
              "Davetiye yok sayıldı",
              style: PeoplerTextStyle.normal.copyWith(
                fontSize: _customTextSize() - 1,
                color: _mode.blackAndWhiteConversion(),
              ),
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }

  Container inComingRequestWidget(BuildContext context, int index, StateSetter setState) {
    Notifications _currentItem = _notificationReceivedBloc.allReceivedList[index];

    double _buttonSize = 28;
    Size _size = MediaQuery.of(context).size;
    double _customTextSize;
    if (_size.width <= 320) {
      _customTextSize = 12;
    } else if (_size.width > 320 && _size.width < 480) {
      _customTextSize = 13;
    } else {
      _customTextSize = 14;
    }

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

    double _rightColumnSize = _buttonSize * 2 + 10;
    double _centerColumnSize = _maxWidth - _leftColumnSize - _rightColumnSize - 40;

    return Container(
      width: _maxWidth,
      decoration: BoxDecoration(
        color: _mode.bottomMenuBackground(),
        boxShadow: <BoxShadow>[BoxShadow(color: Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))],
        //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            //color: Colors.green,
            width: _leftColumnSize,
            height: _leftColumnSize,
            child: profilePhoto(context, _currentItem.requestProfileURL, _currentItem.requestUserID!),
          ),
          SizedBox(
            //color: Colors.orange,
            width: _centerColumnSize,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      _currentItem.requestDisplayName,
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: _customTextSize),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      _currentItem.requestBiography,
                      style: PeoplerTextStyle.normal.copyWith(fontSize: _customTextSize - 1, color: Colors.grey),
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  /*
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          color: Colors.transparent, //Colors.pinkAccent,
                          child: Center(
                            child: Stack(
                              children: [
                                _data.mutualConnectionsProfilePhotos.length >= 3 ? mutualFriendProfilePhotoItem(context, 0, _data.mutualConnectionsProfilePhotos[2]) : const SizedBox(),
                                _data.mutualConnectionsProfilePhotos.length >= 2 ? mutualFriendProfilePhotoItem(context, 1, _data.mutualConnectionsProfilePhotos[1]) : const SizedBox(),
                                _data.mutualConnectionsProfilePhotos.isNotEmpty  ? mutualFriendProfilePhotoItem(context, 2, _data.mutualConnectionsProfilePhotos[0]) : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          _data.mutualConnectionsProfilePhotos.length>3
                              ? "  +${_data.mutualConnectionsProfilePhotos.length-3} ortak bağlantı"
                              : "  ${_data.mutualConnectionsProfilePhotos.length} ortak bağlantı",
                          textScaleFactor: 1,
                          style: PeoplerTextStyle.normal.copyWith(fontSize: _customSmallTextSize(), color:  Color(0xFF0353EF)),
                        ),
                      ],
                    ),
                  ),
                  */
                ],
              ),
            ),
          ),
          SizedBox(
            //color: Colors.red,
            width: _rightColumnSize,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _clickNotAccept(index, setState, _buttonSize),
                const SizedBox(
                  width: 10,
                ),
                _clickAccept(index, setState, _buttonSize),
              ],
            ),
            //_rightColumn(_data.dateTime, _customTextSize()-2),
          )
        ],
      ),
    );
  }

  InkWell _clickNotAccept(int index, StateSetter setState, double _buttonSize) {
    Notifications _currentItem = _notificationReceivedBloc.allReceivedList[index];
    return InkWell(
      onTap: () {
        _notificationReceivedBloc.add(ClickNotAcceptEvent(requestUserID: _currentItem.requestUserID!, index: index));
      },
      child: Container(
        height: _buttonSize,
        width: _buttonSize,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              width: 1,
              color: const Color(0xFF959595),
            )),
        child: const Icon(
          Icons.close,
          color: Color(0xFF959595),
        ),
      ),
    );
  }

  InkWell _clickAccept(int index, StateSetter setState, double _buttonSize) {
    Notifications _currentItem = _notificationReceivedBloc.allReceivedList[index];
    return InkWell(
      onTap: () {
        _notificationReceivedBloc.add(ClickAcceptReceivedEvent(requestUserID: _currentItem.requestUserID!));
        _notificationReceivedBloc.allReceivedList[index].didAccepted = true;

        setState(() {});

        String? _hostUserID = _notificationReceivedBloc.allReceivedList[index].requestUserID;
        String? _hostUserName = _notificationReceivedBloc.allReceivedList[index].requestDisplayName;
        String? _hostUserProfileUrl = _notificationReceivedBloc.allReceivedList[index].requestProfileURL;
        _chatBloc.add(CreateChatEvent(hostUserID: _hostUserID!, hostUserName: _hostUserName, hostUserProfileUrl: _hostUserProfileUrl));
      },
      child: Container(
        height: _buttonSize,
        width: _buttonSize,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              width: 1,
              color: Color(0xFF0353EF),
            )),
        child: const Icon(
          Icons.done,
          color: Color(0xFF0353EF),
        ),
      ),
    );
  }

  bool _listScrollListener() {
    var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

    if(_scrollController.position.userScrollDirection ==  ScrollDirection.reverse &&
        _scrollController.position.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        _notificationReceivedBloc.add(GetMoreDataReceivedEvent());
      }
    }

    return true;
  }
}
