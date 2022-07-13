import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:peopler/business_logic/blocs/CityBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationPermissionBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationUpdateBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'dart:io' show Platform;
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/data/fcm_and_local_notifications.dart';
import 'package:peopler/presentation/router/chat_tab.dart';
import '../../../business_logic/cubits/ThemeCubit.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import '../../tab_item.dart';
import '../feeds/FeedScreen/feed_screen.dart';
import '../../router/feed_tab.dart';
import '../../router/notifications_tab.dart';
import '../../router/profile_tab.dart';
import '../../router/search_tab.dart';
import 'bottom_navigation_bar.dart';
import 'floating_action_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final FloatingActionButtonCubit _homeScreen;
  final feedListKey = GlobalKey<FeedScreenState>();
  final Mode _mode = locator<Mode>();
  late final ThemeCubit _themeCubit;
  late final LocationPermissionBloc _locationPermissionBloc;
  late final LocationBloc _locationBloc;
  late final CityBloc _cityBloc;

  @override
  void initState() {
    super.initState();
    _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    _locationPermissionBloc = BlocProvider.of<LocationPermissionBloc>(context);
    _locationBloc = BlocProvider.of<LocationBloc>(context);
    _cityBloc = BlocProvider.of<CityBloc>(context);
    FCMAndLocalNotifications().initializeFCMNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return WillPopScope(
            onWillPop: _buildWillPopScope,
            child: BlocBuilder<ThemeCubit, bool>(
                bloc: _themeCubit,
                builder: (_, state) {
                  return BlocBuilder<FloatingActionButtonCubit, bool>(
                      bloc: _homeScreen,
                      builder: (_, trig) {
                        return BlocListener<LocationUpdateBloc, LocationUpdateState>(
                            listener: (BuildContext context, state) {
                              if (state is PositionUpdatedState) {
                                _locationBloc.add(
                                    GetInitialSearchUsersEvent(latitude: UserBloc.user!.latitude, longitude: UserBloc.user!.longitude));
                              }
                            },
                            child: SafeArea(
                              child: Scaffold(
                                backgroundColor: _mode.homeScreenScaffoldBackgroundColor(),
                                floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                                floatingActionButton: const MyFloatingActionButtons(),
                                body: IndexedStack(
                                  index: _homeScreen.currentTab.index,
                                  children: [
                                    FeedScreenNavigator(
                                      feedListKey: feedListKey,
                                    ),
                                    const SearchScreenNavigator(),
                                    const ChatScreenNavigator(),
                                    const NotificationScreenNavigator(),
                                    const ProfileScreenNavigator()
                                  ],
                                ),
                                bottomNavigationBar: MyBottomNavigationBar(
                                  // Callback Function, when another tab is clicked, this method will run
                                    onBottomTabTapped: (index) {
                                      _buildOnBottomTabTapped(index);
                                    }),
                              ),
                            )
                        );
                      });
                }),
          );
        });
  }

  void _buildOnBottomTabTapped(index) {
    TabItem _oldTab = _homeScreen.currentTab;
    _homeScreen.currentTab = TabItem.values[index];
    _homeScreen.changeFloatingActionButtonEvent();

    // When both currentTab and clicked tab are Feed tab button, trigger feed_list_screen scrollToTap
    if (_oldTab == TabItem.feed &&
        TabItem.values[index] == TabItem.feed &&
        _homeScreen.currentScreen[TabItem.feed] == ScreenItem.feedScreen) {
      feedListKey.currentState!.scrollToTop();
    }

    // When both currentTab and clicked tab are Search tab button, and screen item is nearbyUsers, then check for permissions (and location setting)
    if (_oldTab == TabItem.search &&
        TabItem.values[index] == TabItem.search &&
        _homeScreen.currentScreen[TabItem.search] == ScreenItem.searchNearByScreen) {
      _locationPermissionBloc.add(GetLocationPermissionEvent());
    }

    // When both currentTab and clicked tab are Search tab button, and screen item is cityUsers, then trig City Bloc
    if (_oldTab == TabItem.search &&
        TabItem.values[index] == TabItem.search &&
        _homeScreen.currentScreen[TabItem.search] == ScreenItem.searchCityScreen) {
      _cityBloc.add(GetInitialSearchUsersCityEvent(city: UserBloc.user!.city));
    }
  }

  Future<bool> _buildWillPopScope() async {
    if ([ScreenItem.invitationsReceivedScreen, ScreenItem.invitationsTransmittedScreen]
        .contains(_homeScreen.currentScreen[_homeScreen.currentTab])) {
      _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.notificationScreen};
      _homeScreen.changeFloatingActionButtonEvent();
      return !await _homeScreen.navigatorKeys[_homeScreen.currentTab]!.currentState!.maybePop();
    } else {
      if (Platform.isAndroid) {
        MoveToBackground.moveTaskToBack();
        return Future.value(false);
      } else {
        MoveToBackground.moveTaskToBack();
        return Future.value(true);
      }
    }
  }
}
