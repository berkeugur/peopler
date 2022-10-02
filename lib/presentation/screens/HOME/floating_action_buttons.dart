import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/FeedBloc/feed_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/core/constants/enums/screen_item_enum.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import 'package:peopler/others/functions/guest_login_alert_dialog.dart';
import 'package:peopler/presentation/screens/FEEDS/FeedShare/feed_share_screen.dart';
import 'package:peopler/presentation/screens/SAVED/saved_screen.dart';
import 'package:restart_app/restart_app.dart';
import '../../../business_logic/blocs/SavedBloc/saved_bloc.dart';
import '../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../core/constants/navigation/navigation_constants.dart';

class MyFloatingActionButtons extends StatefulWidget {
  const MyFloatingActionButtons({Key? key}) : super(key: key);

  @override
  State<MyFloatingActionButtons> createState() => _MyFloatingActionButtonsState();
}

class _MyFloatingActionButtonsState extends State<MyFloatingActionButtons> {
  late final FeedBloc _feedBloc;
  late final SavedBloc _savedBloc;
  late final FloatingActionButtonCubit _homeScreen;

  @override
  void initState() {
    _feedBloc = BlocProvider.of<FeedBloc>(context);
    _savedBloc = BlocProvider.of<SavedBloc>(context);
    _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return BlocBuilder<FloatingActionButtonCubit, bool>(
              bloc: _homeScreen,
              builder: (_, trig) {
                if ((_homeScreen.currentTab == TabItem.feed) && (_homeScreen.currentScreen[TabItem.feed] == ScreenItem.feedScreen)) {
                  return _buildAddFeedFAB(context);
                } else if (_homeScreen.currentTab == TabItem.notifications &&
                    _homeScreen.currentScreen[TabItem.notifications] == ScreenItem.notificationScreen) {
                  // return _buildNotificationDeleteFAB();
                  return const SizedBox.shrink();
                } else if (_homeScreen.currentTab == TabItem.search && _homeScreen.currentScreen[TabItem.search] == ScreenItem.searchNearByScreen) {
                  return _buildSavedFAB(context);
                } else {
                  return const SizedBox.shrink();
                }
              });
        });
  }

  Padding _buildAddFeedFAB(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: FloatingActionButton.small(
        child: const Icon(Icons.add),
        heroTag: "btn1",
        tooltip: "Feed Ekle",
        backgroundColor: const Color(0xFF0353EF),
        onPressed: () {
          UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
          if (UserBloc.user != null) {
            _userBloc.mainKey.currentState?.push(
              MaterialPageRoute(builder: (context) => BlocProvider<FeedBloc>.value(value: _feedBloc, child: const FeedShareScreen())),
            );
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Giriş Yapmalısınız.",
                      style: GoogleFonts.rubik(
                        color: Color(0xFF0353EF),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Kapat",
                            style: GoogleFonts.rubik(
                              color: Color(0xFF0353EF),
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            Restart.restartApp();
                            // UserBloc _userBloc = BlocProvider.of(context);
                            // _userBloc.mainKey.currentState?.pushNamedAndRemoveUntil(NavigationConstants.WELCOME, (Route<dynamic> route) => false);
                          },
                          child: Text(
                            "Giriş Yap",
                            style: GoogleFonts.rubik(
                              color: Color(0xFF0353EF),
                            ),
                          )),
                    ],
                  );
                });
            GuestAlert.dialog(context);
          }
        },
      ),
    );
  }

  SizedBox _buildNotificationDeleteFAB() {
    return SizedBox(
      height: 30,
      child: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: const Color(0xFF0353EF),
          extendedPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          extendedIconLabelSpacing: 0,
          label: Text(
            "Tümünü Sil",
            style: GoogleFonts.rubik(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Padding _buildSavedFAB(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: FloatingActionButton.small(
        child: SvgPicture.asset(
          "assets/images/svg_icons/saved.svg",
          width: 25,
          height: 25,
          color: Colors.white,
          fit: BoxFit.contain,
        ),
        heroTag: "btn3",
        tooltip: "Kaydedilenler",
        backgroundColor: const Color(0xFF0353EF),
        onPressed: () {
          UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
          if (UserBloc.user != null) {
            UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
            _userBloc.mainKey.currentState?.push(
              MaterialPageRoute(builder: (context) => BlocProvider<SavedBloc>.value(value: _savedBloc, child: const SavedScreen())),
            );
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Giriş Yapmalısınız.",
                      style: GoogleFonts.rubik(
                        color: Color(0xFF0353EF),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Kapat",
                            style: GoogleFonts.rubik(
                              color: Color(0xFF0353EF),
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            Restart.restartApp();
                            // UserBloc _userBloc = BlocProvider.of(context);
                            // _userBloc.mainKey.currentState?.pushNamedAndRemoveUntil(NavigationConstants.WELCOME, (Route<dynamic> route) => false);
                          },
                          child: Text(
                            "Giriş Yap",
                            style: GoogleFonts.rubik(
                              color: Color(0xFF0353EF),
                            ),
                          )),
                    ],
                  );
                });
            GuestAlert.dialog(context);
            /*
    _userBloc.mainKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const GuestLoginScreen(),
      ),
    );*/
          }
        },
      ),
    );
  }
}
