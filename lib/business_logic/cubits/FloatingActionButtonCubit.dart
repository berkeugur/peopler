import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/tab_item.dart';

/*
enum TabItem { feed, search, saved, notifications, profile }
enum ScreenItem { feedScreen, searchScreen, savedScreen, notificationScreen, profileScreen }
 */

class FloatingActionButtonCubit extends Cubit<bool> {
  bool trig = true;

  TabItem currentTab = TabItem.feed;

  final Map<TabItem, ScreenItem> _currentScreen = {
    TabItem.feed: ScreenItem.feedScreen,
    TabItem.search: ScreenItem.searchNearByScreen,
    TabItem.saved: ScreenItem.savedScreen,
    TabItem.notifications: ScreenItem.notificationScreen,
    TabItem.profile: ScreenItem.profileScreen,
  };

  final Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.feed: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.saved: GlobalKey<NavigatorState>(),
    TabItem.notifications: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, ScreenItem> get currentScreen {
    return {
      TabItem.feed: _currentScreen[TabItem.feed]!,
      TabItem.search: _currentScreen[TabItem.search]!,
      TabItem.saved: _currentScreen[TabItem.saved]!,
      TabItem.notifications: _currentScreen[TabItem.notifications]!,
      TabItem.profile: _currentScreen[TabItem.profile]!,
    };
  }

  Map<TabItem, GlobalKey<NavigatorState>> get navigatorKeys {
    return {
      TabItem.feed: _navigatorKeys[TabItem.feed]!,
      TabItem.search: _navigatorKeys[TabItem.search]!,
      TabItem.saved: _navigatorKeys[TabItem.saved]!,
      TabItem.notifications: _navigatorKeys[TabItem.notifications]!,
      TabItem.profile: _navigatorKeys[TabItem.profile]!,
    };
  }

  set currentScreen(Map<TabItem, ScreenItem> value) {
    _currentScreen[value.entries.first.key] = value.entries.first.value;
    // notifyListeners();
  }

  set navigatorKeys(Map<TabItem, GlobalKey<NavigatorState>> value) {
    _navigatorKeys[value.entries.first.key] = value.entries.first.value;
    // notifyListeners();
  }

  FloatingActionButtonCubit() : super(true);

  void changeFloatingActionButtonEvent() {
    if (trig) {
      trig = false;
    } else {
      trig = true;
    }

    emit(trig);
  }
}
