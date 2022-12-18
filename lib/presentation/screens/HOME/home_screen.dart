import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:peopler/business_logic/blocs/CityBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationPermissionBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/NewMessageBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/NotificationBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'dart:io' show Platform;
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import 'package:peopler/data/fcm_and_local_notifications.dart';
import 'package:peopler/others/swipedetector.dart';
import 'package:peopler/presentation/router/chat_tab.dart';
import '../../../business_logic/blocs/NewNotificationBloc/bloc.dart';
import '../../../business_logic/blocs/NotificationReceivedBloc/bloc.dart';
import '../../../business_logic/blocs/NotificationTransmittedBloc/bloc.dart';
import '../../../business_logic/blocs/PuchaseGetOfferBloc/bloc.dart';
import '../../../business_logic/blocs/SavedBloc/bloc.dart';
import '../../../business_logic/cubits/ThemeCubit.dart';
import '../../../core/constants/enums/screen_item_enum.dart';
import '../../../data/repository/location_repository.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import '../FEEDS/FeedScreen/feed_screen.dart';
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
  late final CityBloc _cityBloc;
  late final PurchaseGetOfferBloc _purchaseGetOfferBloc;
  late final SavedBloc _savedBloc;
  late final NewMessageBloc _newMessageBloc;

  @override
  void initState() {
    super.initState();
    _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    _locationPermissionBloc = BlocProvider.of<LocationPermissionBloc>(context);
    _cityBloc = BlocProvider.of<CityBloc>(context);

    _savedBloc = BlocProvider.of<SavedBloc>(context);

    if (UserBloc.user != null) {
      _savedBloc.add(GetInitialSavedUsersEvent(myUserID: UserBloc.user!.userID));
      FCMAndLocalNotifications().initializeFCMNotifications(context);

      _newMessageBloc = BlocProvider.of<NewMessageBloc>(context);
      _newMessageBloc.add(CheckIfThereIsNewMessage(homeScreen: _homeScreen));
    }

    /// Get offerings
    _purchaseGetOfferBloc = BlocProvider.of<PurchaseGetOfferBloc>(context);
    _purchaseGetOfferBloc.add(GetInitialOfferEvent());
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
                        return SwipeDetector(
                          onSwipeLeft: () {
                            if (_homeScreen.currentTab == TabItem.profile) {
                              return;
                            }

                            if (_homeScreen.currentTab == TabItem.feed) {
                              _homeScreen.currentTab = TabItem.notifications;
                            } else if (_homeScreen.currentTab == TabItem.notifications) {
                              _homeScreen.currentTab = TabItem.search;
                            } else if (_homeScreen.currentTab == TabItem.search) {
                              _homeScreen.currentTab = TabItem.chat;
                            } else if (_homeScreen.currentTab == TabItem.chat) {
                              _homeScreen.currentTab = TabItem.profile;
                            }

                            _homeScreen.changeFloatingActionButtonEvent();
                          },
                          onSwipeRight: () {
                            if (_homeScreen.currentTab == TabItem.feed) {
                              return;
                            }

                            if (_homeScreen.currentTab == TabItem.notifications) {
                              _homeScreen.currentTab = TabItem.feed;
                            } else if (_homeScreen.currentTab == TabItem.search) {
                              _homeScreen.currentTab = TabItem.notifications;
                            } else if (_homeScreen.currentTab == TabItem.chat) {
                              _homeScreen.currentTab = TabItem.search;
                            } else if (_homeScreen.currentTab == TabItem.profile) {
                              _homeScreen.currentTab = TabItem.chat;
                            }

                            _homeScreen.changeFloatingActionButtonEvent();
                          },
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
                                const NotificationScreenNavigator(),
                                const SearchScreenNavigator(),
                                const ChatScreenNavigator(),
                                const ProfileScreenNavigator()
                              ],
                            ),
                            bottomNavigationBar: SafeArea(
                              child: MyBottomNavigationBar(
                                  // Callback Function, when another tab is clicked, this method will run
                                  onBottomTabTapped: (index) {
                                _buildOnBottomTabTapped(index);
                              }),
                            ),
                          ),
                        );
                      });
                }),
          );
        });
  }

  Future<void> _buildOnBottomTabTapped(index) async {
    TabItem _oldTab = _homeScreen.currentTab;
    _homeScreen.currentTab = TabItem.values[index];
    _homeScreen.changeFloatingActionButtonEvent();

    // Below code will be uncommented if pageview is used
    // _pageController.jumpToPage(_homeScreen.currentTab.index);

    /// When both currentTab and clicked tab are Feed tab button, trigger feed_list_screen scrollToTap
    if (_oldTab == TabItem.feed && TabItem.values[index] == TabItem.feed && _homeScreen.currentScreen[TabItem.feed] == ScreenItem.feedScreen) {
      feedListKey.currentState!.scrollToTop();
      return;
    }

    /// When both currentTab and clicked tab are Notification tab button, and screen is main notification screen
    if (_oldTab == TabItem.notifications &&
        TabItem.values[index] == TabItem.notifications &&
        _homeScreen.currentScreen[TabItem.notifications] == ScreenItem.notificationScreen) {
      NewNotificationBloc _newNotificationBloc = BlocProvider.of<NewNotificationBloc>(context);
      NotificationBloc _notificationBloc = BlocProvider.of<NotificationBloc>(context);
      _notificationBloc.add(GetInitialNotificationEvent(newNotificationBloc: _newNotificationBloc, context: context));
      return;
    }

    /// When both currentTab and clicked tab are Notification tab button, and screen is received invitations
    if (_oldTab == TabItem.notifications &&
        TabItem.values[index] == TabItem.notifications &&
        _homeScreen.currentScreen[TabItem.notifications] == ScreenItem.invitationsReceivedScreen) {
      NotificationReceivedBloc _notificationReceivedBloc = BlocProvider.of<NotificationReceivedBloc>(context);
      _notificationReceivedBloc.add(GetInitialDataReceivedEvent());
      return;
    }

    /// When both currentTab and clicked tab are Notification tab button, and screen is transmitted invitations
    if (_oldTab == TabItem.notifications &&
        TabItem.values[index] == TabItem.notifications &&
        _homeScreen.currentScreen[TabItem.notifications] == ScreenItem.invitationsTransmittedScreen) {
      NotificationTransmittedBloc _notificationTransmittedBloc = BlocProvider.of<NotificationTransmittedBloc>(context);
      _notificationTransmittedBloc.add(GetInitialDataTransmittedEvent());
      return;
    }

    /// When clicked tab is Search tab button, and screen item is nearbyUsers, then check for permissions (and location setting)
    if (TabItem.values[index] == TabItem.search && _homeScreen.currentScreen[TabItem.search] == ScreenItem.searchNearByScreen) {
      _locationPermissionBloc.add(GetLocationPermissionEvent());

      final LocationRepository _locationRepository = locator<LocationRepository>();
      LocationPermission _permission = await _locationRepository.checkPermissions();
      if (_permission == LocationPermission.whileInUse || _permission == LocationPermission.always) {
        LocationBloc _locationBloc = BlocProvider.of<LocationBloc>(context);
        _locationBloc.add(GetInitialSearchUsersEvent());
      }
      return;
    }

    /// When clicked tab is Search tab button, and screen item is cityUsers, then trig City Bloc
    if (TabItem.values[index] == TabItem.search && _homeScreen.currentScreen[TabItem.search] == ScreenItem.searchCityScreen) {
      _cityBloc.add(GetInitialSearchUsersCityEvent(city: UserBloc.user!.city));
      return;
    }
  }

  Future<bool> _buildWillPopScope() async {
    if ([ScreenItem.invitationsReceivedScreen, ScreenItem.invitationsTransmittedScreen].contains(_homeScreen.currentScreen[_homeScreen.currentTab])) {
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
