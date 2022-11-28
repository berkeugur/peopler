import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/NewNotificationCubit.dart';
import '../../../business_logic/blocs/NotificationBloc/bloc.dart';
import '../../../business_logic/cubits/ThemeCubit.dart';
import '../../../others/empty_list.dart';
import 'notification_screen_app_bar.dart';
import 'notification_screen_list_view.dart';

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
    _notificationBloc.add(GetInitialNotificationEvent(newNotificationCubit: _newNotificationCubit));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool? innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    // This widget takes the overlapping behavior of the SliverAppBar,
                    // and redirects it to the SliverOverlapInjector below. If it is
                    // missing, then it is possible for the nested "inner" scroll view
                    // below to end up under the SliverAppBar even when the inner
                    // scroll view thinks it has not been scrolled.
                    // This is not necessary if the "headerSliverBuilder" only builds
                    // widgets that do not overlap the next sliver.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: MyNotificationScreenAppBar(),
                  ),
                ];
              },
              body: Builder(
                // This Builder is needed to provide a BuildContext that is "inside"
                // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
                // find the NestedScrollView.
                builder: (BuildContext context) {
                  notificationsScreenScrollController =
                      context.findAncestorStateOfType<NestedScrollViewState>()!.innerController;
                  if (notificationsScreenScrollController.hasListeners == false) {
                    notificationsScreenScrollController.addListener(_listScrollListener);
                  }
                  return CustomScrollView(
                    // The controller must be the inner controller of nested scroll view widget.
                    controller: notificationsScreenScrollController,
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        // This is the flip side of the SliverOverlapAbsorber above.
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      ),
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
                              return const SliverToBoxAdapter(child: SizedBox.shrink());
                            }
                          }),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }

  bool _listScrollListener() {
    var nextPageTrigger = 0.8 * notificationsScreenScrollController.positions.last.maxScrollExtent;

    if (notificationsScreenScrollController.positions.last.axisDirection == AxisDirection.down &&
        notificationsScreenScrollController.positions.last.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        _notificationBloc.add(GetMoreNotificationEvent());
      }
    }

    return true;
  }

  RenderObjectWidget _showNotifications(context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return customListItem(index, context);
        },
        childCount: _notificationBloc.allNotificationList.length,
      ),
    );
  }

  SliverToBoxAdapter _initialNotificationsStateWidget(context) {
    return SliverToBoxAdapter(
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
    );
  }

  SliverToBoxAdapter _noNotificationsExistsWidget(context) {
    return const SliverToBoxAdapter(
      child: EmptyList(
        emptyListType: EmptyListType.emptyNotifications,
        isSVG: false,
      ),
    );
  }

  SliverToBoxAdapter _notificationsLoadingCircularButton() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: const [
          Expanded(flex: 5, child: SizedBox()),
          Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
          Expanded(flex: 5, child: SizedBox()),
        ]),
      ),
    );
  }
}
