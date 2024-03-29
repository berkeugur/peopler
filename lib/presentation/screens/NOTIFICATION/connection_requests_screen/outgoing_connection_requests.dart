import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/NotificationTransmittedBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import '../../../../business_logic/blocs/NotificationBloc/bloc.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../core/constants/enums/subscriptions_enum.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/empty_list.dart';
import '../../../../others/locator.dart';
import '../../../../others/widgets/snack_bars.dart';
import '../notification_screen_list_view.dart';

class OutGoingConnectionRequestList extends StatefulWidget {
  const OutGoingConnectionRequestList({Key? key}) : super(key: key);

  @override
  _OutGoingConnectionRequestListState createState() => _OutGoingConnectionRequestListState();
}

class _OutGoingConnectionRequestListState extends State<OutGoingConnectionRequestList> {
  final Mode _mode = locator<Mode>();

  late final NotificationTransmittedBloc _notificationTransmittedBloc;

  bool loading = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    _notificationTransmittedBloc = BlocProvider.of<NotificationTransmittedBloc>(context);
    _notificationTransmittedBloc.add(GetInitialDataTransmittedEvent());
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _maxWidth = _size.width > 480 ? 480 : _size.width;

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Expanded(
            child: Container(
              color: _mode.search_peoples_scaffold_background(),
              child: SizedBox(
                  width: _maxWidth,
                  child: NotificationListener(
                    onNotification: (ScrollNotification scrollNotification) => _listScrollListener(),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          BlocBuilder<NotificationTransmittedBloc, NotificationTransmittedState>(
                            bloc: _notificationTransmittedBloc,
                            builder: (context, state) {
                              if (state is InitialNotificationTransmittedState) {
                                return _initialNotificationsTransmittedStateWidget();
                              } else if (state is NotificationTransmittedNotExistState) {
                                return _noNotificationsTransmittedExistsWidget();
                              } else if (state is NotificationTransmittedLoaded1State) {
                                loading = false;
                                return _showNotificationsTransmitted();
                              } else if (state is NotificationTransmittedLoaded2State) {
                                loading = false;
                                return _showNotificationsTransmitted();
                              } else if (state is NoMoreNotificationTransmittedState) {
                                return _showNotificationsTransmitted();
                              } else if (state is NewNotificationTransmittedLoadingState) {
                                return _showNotificationsTransmitted();
                              } else {
                                return const Text("Impossible");
                              }
                            },
                          ),
                          BlocBuilder<NotificationTransmittedBloc, NotificationTransmittedState>(
                              bloc: _notificationTransmittedBloc,
                              builder: (context, state) {
                                if (state is NewNotificationTransmittedLoadingState) {
                                  return _notificationsTransmittedLoadingCircularButton();
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

  _showNotificationsTransmitted() {
    return SizedBox(
      child: ListView.builder(
        itemCount: _notificationTransmittedBloc.allTransmittedList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return outGoingRequestWidget(index, setState);
        },
      ),
    );
  }

  SizedBox _initialNotificationsTransmittedStateWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  EmptyList _noNotificationsTransmittedExistsWidget() {
    return const EmptyList(
      emptyListType: EmptyListType.outgoingRequest,
      isSVG: true,
    );
  }

  Padding _notificationsTransmittedLoadingCircularButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: const [
        Expanded(flex: 5, child: SizedBox()),
        Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
        Expanded(flex: 5, child: SizedBox()),
      ]),
    );
  }

  Container outGoingRequestWidget(int index, StateSetter setState) {
    double _buttonSize = 44;
    Size _size = MediaQuery.of(context).size;

    double _customTextSize() {
      if (_size.width <= 320) {
        return 12;
      } else if (_size.width > 320 && _size.width < 480) {
        return 13;
      } else {
        return 14;
      }
    }

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

    double _rightColumnSize = _buttonSize;
    double _centerColumnSize = _maxWidth - _leftColumnSize() - _rightColumnSize - 40;

    return Container(
      width: _maxWidth,
      decoration: BoxDecoration(
        color: _mode.bottomMenuBackground(),
        boxShadow: <BoxShadow>[
          BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
        ],
        //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            //color: Colors.green,
            width: _leftColumnSize(),
            height: _leftColumnSize(),
            child: profilePhoto(context, _notificationTransmittedBloc.allTransmittedList[index].requestProfileURL,
                _notificationTransmittedBloc.allTransmittedList[index].requestUserID!),
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
                      _notificationTransmittedBloc.allTransmittedList[index].requestDisplayName,
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: _customTextSize()),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      _notificationTransmittedBloc.allTransmittedList[index].requestBiography,
                      style: PeoplerTextStyle.normal.copyWith(fontSize: _customTextSize() - 1, color: Colors.grey),
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    child: Text(
                      elapsedTimeLongText(_notificationTransmittedBloc.allTransmittedList[index].createdAt!.toString()) + " önce gönderildi",
                      style: PeoplerTextStyle.normal.copyWith(fontSize: _customTextSize() - 2, color: Colors.grey),
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            //color: Colors.red,
            width: _rightColumnSize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (UserBloc.entitlement == SubscriptionTypes.free) {
                      showGeriAlWarning(context);
                      return;
                    }

                    String requestUserID = _notificationTransmittedBloc.allTransmittedList[index].requestUserID!;
                    _notificationTransmittedBloc.add(GeriAlTransmittedButtonEvent(requestUserID: requestUserID));

                    NotificationBloc _notificationBloc = BlocProvider.of<NotificationBloc>(context);
                    _notificationBloc.allNotificationList.removeWhere((element) => element.requestUserID == requestUserID);
                  },
                  child: SizedBox(
                      height: _buttonSize + 7,
                      width: _buttonSize,
                      child: Center(
                        child: Text(
                          "Geri Al",
                          style: PeoplerTextStyle.normal.copyWith(fontSize: _customTextSize(), color: Colors.grey),
                          textScaleFactor: 1,
                        ),
                      )),
                ),
              ],
            ),
            //_rightColumn(_data.dateTime, _customTextSize()-2),
          )
        ],
      ),
    );
  }

  bool _listScrollListener() {
    var nextPageTrigger = 0.8 * _scrollController.positions.last.maxScrollExtent;

    if (_scrollController.positions.last.axisDirection == AxisDirection.down && _scrollController.positions.last.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        _notificationTransmittedBloc.add(GetMoreDataTransmittedEvent());
      }
    }

    return true;
  }
}
