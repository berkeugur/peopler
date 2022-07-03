import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../others/classes/variables.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/locator.dart';

Container bottomMenuForChannelList(BuildContext context) {
  var _menuItemHeight = MediaQuery.of(context).size.width < 425
      ? MediaQuery.of(context).size.width * 0.056 + 10
      : 425 * 0.056 + 10;
  var _menuItemWidth = MediaQuery.of(context).size.width < 425
      ? MediaQuery.of(context).size.width * 0.059 + 10
      : 425 * 0.059 + 10;

  final Mode _mode = locator<Mode>();

  return Container(
    decoration: BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Color(0xFF939393).withOpacity(0.6),
            blurRadius: 2.0,
            spreadRadius: 0,
            offset: Offset(0.0, 0.75))
      ],
      color: _mode.bottomMenuBackground(),
    ),
    width: MediaQuery.of(context).size.width,
    height: 50,
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/homeScreen');
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.all(5),
            height: _menuItemHeight,
            width: _menuItemWidth,
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              color: _mode.disabledSelectedMenuItemBackground(),
              borderRadius: BorderRadius.circular(menuItemBorderRadius),
            ),
            child: SvgPicture.asset(
              "assets/images/svg_icons/home.svg",
              color: _mode.disabledBottomMenuItemAssetColor(),
              width: 10,
              height: 10,
              fit: BoxFit.contain,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/homeScreen');
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.all(5),
            height: _menuItemHeight,
            width: _menuItemWidth,
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              color: _mode.disabledSelectedMenuItemBackground(),
              borderRadius: BorderRadius.circular(menuItemBorderRadius),
            ),
            child: SvgPicture.asset(
              "assets/images/svg_icons/search.svg",
              color: _mode.disabledBottomMenuItemAssetColor(),
              width: 10,
              height: 10,
              fit: BoxFit.contain,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/homeScreen');
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.all(5),
            height: _menuItemHeight,
            width: _menuItemWidth,
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              color: _mode.disabledSelectedMenuItemBackground(),
              borderRadius: BorderRadius.circular(menuItemBorderRadius),
            ),
            child: SvgPicture.asset(
              "assets/images/svg_icons/saved.svg",
              color: _mode.disabledBottomMenuItemAssetColor(),
              width: 10,
              height: 10,
              fit: BoxFit.contain,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/homeScreen');
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.all(5),
            height: _menuItemHeight,
            width: _menuItemWidth,
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              color: _mode.disabledSelectedMenuItemBackground(),
              borderRadius: BorderRadius.circular(menuItemBorderRadius),
            ),
            child: SvgPicture.asset(
              "assets/images/svg_icons/notification.svg",
              color: _mode.disabledBottomMenuItemAssetColor(),
              width: 10,
              height: 10,
              fit: BoxFit.contain,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/homeScreen');
          },
          child: AnimatedContainer(
            padding: const EdgeInsets.all(5),
            height: _menuItemHeight,
            width: _menuItemWidth,
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              color: _mode.disabledSelectedMenuItemBackground(),
              borderRadius: BorderRadius.circular(menuItemBorderRadius),
            ),
            child: SvgPicture.asset(
              "assets/images/svg_icons/profile_icon.svg",
              color: _mode.disabledBottomMenuItemAssetColor(),
              width: 10,
              height: 10,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    ),
  );
}
