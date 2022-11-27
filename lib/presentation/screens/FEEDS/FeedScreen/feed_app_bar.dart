import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';

import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../components/FlutterWidgets/app_bars.dart';
import '../../../../components/FlutterWidgets/text_style.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/classes/variables.dart';
import '../../../../others/locator.dart';
import '../../SUBSCRIPTIONS/subscriptions_page.dart';
import '../../TUTORIAL/constants.dart';
import '../../TUTORIAL/onboardingscreen.dart';
import 'feed_functions.dart';

// SliverAppBar is stateless because when we scroll, state change is because of NestedScrollView in HomeScreen, not SliverAppBar
class MyFeedAppBar extends StatelessWidget {
  MyFeedAppBar({
    Key? key,
  }) : super(key: key);


  final Mode _mode = locator<Mode>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: true,
      floating: true,
      title: PEOPLER_TITLE(),
      leading: DRAWER_MENU_ICON(),
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (TutorialDataList.screen_list.length != 3) {
              TutorialDataList.prepareDataList();
            }
            UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
            _userBloc.mainKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const TutorialScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 30,
            width: screenWidth > 600 ? 298 : (screenWidth - 50) / 2,
            decoration: const BoxDecoration(
              color: Color(0xFF0353EF),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/svg_icons/compass.svg",
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                Text(
                  " Başlangıç rehberi",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () {
            UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
            _userBloc.mainKey.currentState?.push(
              MaterialPageRoute(builder: (context) => const SubscriptionsPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 30,
            width: screenWidth > 600 ? 298 : (screenWidth - 50) / 2,
            decoration: const BoxDecoration(
              color: Color(0xFF0353EF),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/svg_icons/ppl_mini_logo.svg",
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                Text(
                  " Ayrıcalıkları Keşfet",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}