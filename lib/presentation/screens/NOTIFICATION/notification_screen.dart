import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/NewNotificationCubit.dart';
import '../../../business_logic/blocs/NotificationBloc/bloc.dart';
import '../../../business_logic/cubits/ThemeCubit.dart';
import '../../../others/classes/variables.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import '../../../others/empty_list.dart';
import 'notification_screen_app_bar.dart';
import 'notification_screen_list_view.dart';

String notificationText = "Bildirimler";

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  late ScrollController notificationsScreenScrollController;
  late final NotificationBloc _notificationBloc;

  bool loading = false;
  late final NewNotificationCubit _newNotificationCubit;

  @override
  void initState() {
    super.initState();

    _newNotificationCubit = BlocProvider.of<NewNotificationCubit>(context);

    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _notificationBloc.add(GetNotificationWithPaginationEvent(newNotificationCubit: _newNotificationCubit));
    notificationsScreenScrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeCubit _themeCubit = BlocProvider.of<ThemeCubit>(context);

    Size _size = MediaQuery.of(context).size;
    double _maxWidth = _size.width > 480 ? 480 : _size.width;

    final Mode _mode = locator<Mode>();

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return BlocBuilder<ThemeCubit, bool>(
              bloc: _themeCubit,
              builder: (_, state) {
                return SafeArea(
                  child: Container(
                    color: _mode.search_peoples_scaffold_background(),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: _maxWidth,
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollNotification) => _listScrollListener(),
                            child: SingleChildScrollView(
                              controller: notificationsScreenScrollController,
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  BlocBuilder<NotificationBloc, NotificationState>(
                                    bloc: _notificationBloc,
                                    builder: (context, state) {
                                      if (state is InitialNotificationState) {
                                        return _initialNotificationsStateWidget(context);
                                      } else if (state is NotificationNotExistState) {
                                        return _noNotificationsExistsWidget(context);
                                      } else if (state is NotificationLoadedState1) {
                                        loading = false;
                                        return _showNotifications(context);
                                      } else if (state is NotificationLoadedState2) {
                                        loading = false;
                                        return _showNotifications(context);
                                      } else if (state is NoMoreNotificationState) {
                                        return _showNotifications(context);
                                      } else if (state is NotificationsLoadingState) {
                                        return _showNotifications(context);
                                      } else {
                                        return const Text("Impossible");
                                      }
                                    },
                                  ),
                                  BlocBuilder<NotificationBloc, NotificationState>(
                                      bloc: _notificationBloc,
                                      builder: (context, state) {
                                        if (state is NotificationsLoadingState) {
                                          return _notificationsLoadingCircularButton();
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        notificationScreenAppBar(context, notificationsScreenScrollController),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  bool _listScrollListener() {
    if (notificationsScreenScrollController.hasClients &&
        notificationsScreenScrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (Variables.animatedNotificationHeaderBottom.value != 50) {
        Variables.animatedNotificationsHeaderTop.value = 70;

        Future.delayed(const Duration(milliseconds: 450), () {
          Variables.animatedNotificationHeaderBottom.value = 50;
        });
      }
    } else if (notificationsScreenScrollController.hasClients &&
        notificationsScreenScrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (Variables.animatedNotificationHeaderBottom.value != 0) {
        Variables.animatedNotificationHeaderBottom.value = 0;
        Future.delayed(const Duration(milliseconds: 450), () {
          Variables.animatedNotificationsHeaderTop.value = 0;
        });
      }
    }

    var nextPageTrigger = 0.8 * notificationsScreenScrollController.position.maxScrollExtent;

    if (notificationsScreenScrollController.position.userScrollDirection == ScrollDirection.reverse &&
        notificationsScreenScrollController.position.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        _notificationBloc.add(GetNotificationWithPaginationEvent(newNotificationCubit: _newNotificationCubit));
      }
    }

    return true;
  }

  SizedBox _showNotifications(context) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 70 + 50),
        itemCount: _notificationBloc.allNotificationList.length,
        itemBuilder: (context, index) {
          return customListItem(index, context);
        },
      ),
    );
  }

  SizedBox _initialNotificationsStateWidget(context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  EmptyList _noNotificationsExistsWidget(context) {
    return const EmptyList(
      emptyListType: EmptyListType.emptyNotifications,
      isSVG: false,
    );
  }

  Padding _notificationsLoadingCircularButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: const [
        Expanded(flex: 5, child: SizedBox()),
        Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
        Expanded(flex: 5, child: SizedBox()),
      ]),
    );
  }
}
