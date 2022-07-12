import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peopler/business_logic/blocs/LocationPermissionBloc/location_permission_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import '../../../business_logic/blocs/LocationPermissionBloc/location_permission_event.dart';
import '../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../others/classes/variables.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import '../../tab_item.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final Function onBottomTabTapped;

  const MyBottomNavigationBar({Key? key, required this.onBottomTabTapped}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> with TickerProviderStateMixin {
  late final FloatingActionButtonCubit _homeScreen;
  final Mode _mode = locator<Mode>();

  @override
  void initState() {
    super.initState();
    _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    double _menuItemHeight = MediaQuery.of(context).size.width < 425 ? MediaQuery.of(context).size.width * 0.056 + 10 : 425 * 0.056 + 10;
    double _menuItemWidth = MediaQuery.of(context).size.width < 425 ? MediaQuery.of(context).size.width * 0.059 + 10 : 425 * 0.059 + 10;

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: const Color(0xFF939393).withOpacity(0.6),
                    blurRadius: 2.0,
                    spreadRadius: 0,
                    offset: const Offset(0.0, 0.75))
              ],
              color: _mode.bottomMenuBackground(),
            ),
            width: MediaQuery.of(context).size.width,
            height: 50,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFeedBottomIcon(_menuItemHeight, _menuItemWidth),
                _buildProfileBottomIcon(_menuItemHeight, _menuItemWidth),
                _buildSearchBottomIcon(_menuItemHeight, _menuItemWidth),
                _buildNotificationBottomIcon(_menuItemHeight, _menuItemWidth),
                _buildChatBottomIcon(_menuItemHeight, _menuItemWidth),
              ],
            ),
          );
        });
  }

  InkWell _buildFeedBottomIcon(double _menuItemHeight, double _menuItemWidth) {
    int index = TabItem.feed.index;
    return InkWell(
      onTap: () {
        setState(() {
          widget.onBottomTabTapped(index);
          _homeScreen.currentTab = TabItem.feed;
        });
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.all(5),
        height: _menuItemHeight * 1,
        width: _menuItemWidth * 1.45,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: _homeScreen.currentTab.index == index
              ? _mode.enabledMenuItemBackground()
              : _mode.disabledSelectedMenuItemBackground(),
          borderRadius: BorderRadius.circular(menuItemBorderRadius),
        ),
        child: SizedBox(
          height: _menuItemHeight,
          width: _menuItemWidth,
          child: SvgPicture.asset(
            "assets/images/svg_icons/home.svg",
            color: _homeScreen.currentTab.index == index
                ? _mode.enabledBottomMenuItemAssetColor()
                : _mode.disabledBottomMenuItemAssetColor(),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  InkWell _buildSearchBottomIcon(double _menuItemHeight, double _menuItemWidth) {
    int index = TabItem.search.index;
    return InkWell(
      onTap: () {
        setState(() {
          widget.onBottomTabTapped(index); // Index 1 Search Screen
          _homeScreen.currentTab = TabItem.search;
        });

        BlocProvider.of<LocationPermissionBloc>(context).add(GetLocationPermissionEvent());
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.all(5),
        height: _menuItemHeight * 1,
        width: _menuItemWidth * 1.45,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: _homeScreen.currentTab.index == index
              ? _mode.enabledMenuItemBackground()
              : _mode.disabledSelectedMenuItemBackground(),
          borderRadius: BorderRadius.circular(menuItemBorderRadius),
        ),
        child: SizedBox(
          height: _menuItemHeight,
          width: _menuItemWidth,
          child: SvgPicture.asset(
            "assets/images/svg_icons/search.svg",
            color: _homeScreen.currentTab.index == index
                ? _mode.enabledBottomMenuItemAssetColor()
                : _mode.disabledBottomMenuItemAssetColor(),
            width: 10,
            height: 10,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  InkWell _buildChatBottomIcon(double _menuItemHeight, double _menuItemWidth) {
    int index = TabItem.chat.index;
    return InkWell(
      onTap: () {
        setState(() {
          widget.onBottomTabTapped(index); // Index 2 Saved Screen
          _homeScreen.currentTab = TabItem.chat;
        });
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.all(5),
        height: _menuItemHeight * 1,
        width: _menuItemWidth * 1.45,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: _homeScreen.currentTab.index == index
              ? _mode.enabledMenuItemBackground()
              : _mode.disabledSelectedMenuItemBackground(),
          borderRadius: BorderRadius.circular(menuItemBorderRadius),
        ),
        child: SizedBox(
          height: _menuItemHeight,
          width: _menuItemWidth,
          child: SvgPicture.asset(
            "assets/images/svg_icons/message_icon.svg",
            color: _homeScreen.currentTab.index == index
                ? _mode.enabledBottomMenuItemAssetColor()
                : _mode.disabledBottomMenuItemAssetColor(),
            width: 10,
            height: 10,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  InkWell _buildNotificationBottomIcon(double _menuItemHeight, double _menuItemWidth) {
    int index = TabItem.notifications.index;
    return InkWell(
      onTap: () {
        setState(() {
          widget.onBottomTabTapped(index); // Index 3 Notification Screen
          _homeScreen.currentTab = TabItem.notifications;
        });
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.all(5),
        height: _menuItemHeight * 1,
        width: _menuItemWidth * 1.45,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: _homeScreen.currentTab.index == index
              ? _mode.enabledMenuItemBackground()
              : _mode.disabledSelectedMenuItemBackground(),
          borderRadius: BorderRadius.circular(menuItemBorderRadius),
        ),
        child: SizedBox(
          height: _menuItemHeight,
          width: _menuItemWidth,
          child: SvgPicture.asset(
            "assets/images/svg_icons/notification.svg",
            color: _homeScreen.currentTab.index == index
                ? _mode.enabledBottomMenuItemAssetColor()
                : _mode.disabledBottomMenuItemAssetColor(),
            width: 10,
            height: 10,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  InkWell _buildProfileBottomIcon(double _menuItemHeight, double _menuItemWidth) {
    int index = TabItem.profile.index;
    return InkWell(
      onTap: () {
        setState(() {
          widget.onBottomTabTapped(index); // Index 4 Profile Screen
          _homeScreen.currentTab = TabItem.profile;
        });
      },
      child: AnimatedContainer(
        padding: const EdgeInsets.all(5),
        height: _menuItemHeight * 1,
        width: _menuItemWidth * 1.45,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: _homeScreen.currentTab.index == index
              ? _mode.enabledMenuItemBackground()
              : _mode.disabledSelectedMenuItemBackground(),
          borderRadius: BorderRadius.circular(menuItemBorderRadius),
        ),
        child: SizedBox(
          height: _menuItemHeight,
          width: _menuItemWidth,
          child: SvgPicture.asset(
            "assets/images/svg_icons/profile_icon.svg",
            color: _homeScreen.currentTab.index == index
                ? _mode.enabledBottomMenuItemAssetColor()
                : _mode.disabledBottomMenuItemAssetColor(),
            width: 10,
            height: 10,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
