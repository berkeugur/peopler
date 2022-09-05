import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/app_bars.dart';
import 'package:peopler/core/constants/enums/screen_item_enum.dart';
import '../../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';

import 'incoming_connection_requests.dart';
import 'outgoing_connection_requests.dart';

class ConnectionRequestScreenFunctions {
  void backButton(context) {
    final FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.notificationScreen};
    _homeScreen.changeFloatingActionButtonEvent();
    Navigator.pop(context);
    debugPrint("pressed back button");
  }

  void pressedTitle(context, ScrollController _scrollController) {
    _scrollController.animateTo(10, duration: const Duration(seconds: 1), curve: Curves.easeInOutSine);
    return;
  }
}

enum ConnectionRequestList { inComingRequestList, outGoingRequestList }

class ConnectionRequestScreen extends StatefulWidget {
  const ConnectionRequestScreen({Key? key}) : super(key: key);
  @override
  _ConnectionRequestScreenState createState() => _ConnectionRequestScreenState();
}

class _ConnectionRequestScreenState extends State<ConnectionRequestScreen> {
  ConnectionRequestList selectedConnectionRequestList = ConnectionRequestList.inComingRequestList;

  final Mode _mode = locator<Mode>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: _mode.search_peoples_scaffold_background(),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTopHeader(context),
                  _buildBottomHeader(),
                  selectedConnectionRequestList == ConnectionRequestList.inComingRequestList
                      ? const InComingConnectionRequestList()
                      : const OutGoingConnectionRequestList(),
                ],
              ),
            ),
          );
        });
  }

  Padding _buildTopHeader(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: PeoplerAppBars(context: context).CONNECTION_REQ(() {
          final FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
          _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.notificationScreen};
          _homeScreen.changeFloatingActionButtonEvent();
          Navigator.pop(context);
          debugPrint("pressed back button");
        }));
  }

  Container _buildBottomHeader() {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildButtonAlinan(),
          _buildButtonGonderilen(),
        ],
      ),
    );
  }

  InkWell _buildButtonAlinan() {
    return InkWell(
      onTap: () {
        selectedConnectionRequestList = ConnectionRequestList.inComingRequestList;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10, left: 20),
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
        decoration: BoxDecoration(
          color: selectedConnectionRequestList == ConnectionRequestList.inComingRequestList ? const Color(0xFF0353EF) : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          "Alınan",
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            fontSize: 14,
            color: selectedConnectionRequestList == ConnectionRequestList.inComingRequestList ? Colors.white : const Color(0xFF0353EF),
          ),
        ),
      ),
    );
  }

  InkWell _buildButtonGonderilen() {
    return InkWell(
      onTap: () {
        selectedConnectionRequestList = ConnectionRequestList.outGoingRequestList;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
        decoration: BoxDecoration(
          color: selectedConnectionRequestList == ConnectionRequestList.outGoingRequestList ? const Color(0xFF0353EF) : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          "Gönderilen",
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            fontSize: 14,
            color: selectedConnectionRequestList == ConnectionRequestList.outGoingRequestList ? Colors.white : const Color(0xFF0353EF),
          ),
        ),
      ),
    );
  }
}
