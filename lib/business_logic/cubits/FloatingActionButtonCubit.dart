import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/core/constants/enums/screen_item_enum.dart';

import '../../core/constants/enums/tab_item_enum.dart';

/*
enum TabItem { feed, search, chat, notifications, profile }
enum ScreenItem { feedScreen, searchScreen, chatScreen, notificationScreen, profileScreen }
 */

class FloatingActionButtonCubit extends Cubit<bool> {
  bool trig = true;

  TabItem currentTab = TabItem.feed;

  Map<TabItem, ScreenItem> currentScreen = {
    TabItem.feed: ScreenItem.feedScreen,
    TabItem.notifications: ScreenItem.notificationScreen,
    TabItem.search: ScreenItem.searchNearByScreen,
    TabItem.chat: ScreenItem.chatScreen,
    TabItem.profile: ScreenItem.profileScreen,
  };

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.feed: GlobalKey<NavigatorState>(),
    TabItem.notifications: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.chat: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

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
