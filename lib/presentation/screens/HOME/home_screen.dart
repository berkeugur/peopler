import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:peopler/business_logic/blocs/CityBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationPermissionBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationUpdateBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/NotificationBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'dart:io' show Platform;
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import 'package:peopler/data/fcm_and_local_notifications.dart';
import 'package:peopler/presentation/router/chat_tab.dart';
import 'package:preload_page_view/preload_page_view.dart';
import '../../../business_logic/blocs/PuchaseGetOfferBloc/bloc.dart';
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
  late final LocationBloc _locationBloc;
  late final CityBloc _cityBloc;
  late final NotificationBloc _notificationBloc;
  late final PurchaseGetOfferBloc _purchaseGetOfferBloc;
  late PreloadPageController _pageController;

  @override
  void initState() {
    super.initState();
    _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    _locationPermissionBloc = BlocProvider.of<LocationPermissionBloc>(context);
    _locationBloc = BlocProvider.of<LocationBloc>(context);
    _cityBloc = BlocProvider.of<CityBloc>(context);
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _pageController = PreloadPageController(initialPage: _homeScreen.currentTab.index);

    if (UserBloc.user != null) {
      FCMAndLocalNotifications().initializeFCMNotifications(context);
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
                        return Scaffold(
                          backgroundColor: _mode.homeScreenScaffoldBackgroundColor(),
                          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                          floatingActionButton: const MyFloatingActionButtons(),
                          body:
                              /*
                              PreloadPageView.builder(
                                preloadPagesCount: 5,
                                itemBuilder: (BuildContext context, int position) {
                                  switch (position) {
                                    case 1:
                                      return FeedScreenNavigator(
                                        feedListKey: feedListKey,
                                      );
                                    case 2:
                                      return const NotificationScreenNavigator();
                                    case 3:
                                      return const SearchScreenNavigator();
                                    case 4:
                                      return const ChatScreenNavigator();
                                    case 5:
                                      return const ProfileScreenNavigator();
                                    default:
                                      return const ProfileScreenNavigator();
                                  }
                                },
                                controller: _pageController,
                                onPageChanged: (int position) {
                                  _homeScreen.currentTab = TabItem.values[position];
                                  _homeScreen.changeFloatingActionButtonEvent();
                                },
                              ),
                               */


                          IndexedStack(
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



                          bottomNavigationBar: MyBottomNavigationBar(
                              // Callback Function, when another tab is clicked, this method will run
                              onBottomTabTapped: (index) {
                            _buildOnBottomTabTapped(index);
                          }),
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
    }

    /// When clicked tab is Search tab button, and screen item is cityUsers, then trig City Bloc
    if (TabItem.values[index] == TabItem.search && _homeScreen.currentScreen[TabItem.search] == ScreenItem.searchCityScreen) {
      _cityBloc.add(GetInitialSearchUsersCityEvent(city: UserBloc.user!.city));
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
