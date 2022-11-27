import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/NotificationBloc/bloc.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';

import '../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../business_logic/cubits/NewNotificationCubit.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/classes/variables.dart';
import '../../../others/locator.dart';

class NotificationScreenFunctions {
  void pressedTitle(context, ScrollController _scrollController) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(10, duration: const Duration(seconds: 1), curve: Curves.easeInOutSine);
    }

    return;
  }

  void messageButton(context) {
    print("pressed message button");
  }

  String numberOfConnectionRequest() {
    return "3";
  }

  void pushConnectionRequestPage(context) {
    final FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    _homeScreen.navigatorKeys[TabItem.notifications]!.currentState!.pushNamed(NavigationConstants.INVITATIONS);
  }
}

// SliverAppBar is stateless because when we scroll, state change is because of NestedScrollView in HomeScreen, not SliverAppBar
class MyNotificationScreenAppBar extends StatelessWidget {
  MyNotificationScreenAppBar({
    Key? key,
  }) : super(key: key);

  final Mode _mode = locator<Mode>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: true,
      floating: true,
      title: const NOTIFICATION_TITLE(),
      centerTitle: true,
      backgroundColor: _mode.bottomMenuBackground(),
      shadowColor: Colors.transparent,
      expandedHeight: 2 * kToolbarHeight,
      flexibleSpace: const Padding(
        padding: EdgeInsets.only(top: kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: _BottomAppBar(),
        ),
      ),
    );
  }
}

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Mode _mode = locator<Mode>();

    return InkWell(
      onTap: () => NotificationScreenFunctions().pushConnectionRequestPage(context),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: _mode.bottomMenuBackground(),
          boxShadow: <BoxShadow>[
            BoxShadow(color: const Color(0xFFE3E2E2).withOpacity(0.6), blurRadius: 1.5, spreadRadius: 0.7, offset: const Offset(0, 0))
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        height: Variables.animatedNotificationHeaderBottom.value,
        duration: const Duration(milliseconds: 250),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Davetiyeler", //(${NotificationScreenFunctions().numberOfConnectionRequest()})
              textScaleFactor: 1,
              style: PeoplerTextStyle.normal.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _mode.disabledBottomMenuItemAssetColor(),
              ),
            ),
            RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                "assets/images/svg_icons/back_arrow.svg",
                width: 20,
                height: 20,
                color: _mode.homeScreenIconsColor(),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
