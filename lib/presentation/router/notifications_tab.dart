import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/core/constants/enums/screen_item_enum.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../core/constants/navigation/navigation_constants.dart';
import '../screens/GUEST_LOGIN/guest_login_screen.dart';
import '../screens/NOTIFICATION/connection_requests_screen/connection_request_screen.dart';
import '../screens/NOTIFICATION/notification_screen.dart';

class NotificationScreenNavigator extends StatefulWidget {
  const NotificationScreenNavigator({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationScreenNavigatorState createState() => _NotificationScreenNavigatorState();
}

class _NotificationScreenNavigatorState extends State<NotificationScreenNavigator> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Navigator(
            key: _homeScreen.navigatorKeys[TabItem.notifications],
            initialRoute: NavigationConstants.INITIAL_ROUTE,
            onGenerateRoute: (routeSettings) {
              switch (routeSettings.name) {
                case NavigationConstants.INITIAL_ROUTE:
                  _homeScreen.currentScreen = {TabItem.notifications: ScreenItem.notificationScreen};
                  _homeScreen.changeFloatingActionButtonEvent();
                  if (UserBloc.user == null) {
                    return MaterialPageRoute(
                      builder: (context) => const GuestLoginScreen(),
                    );
                  }

                  return MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  );
                case '/invitations':
                  _homeScreen.currentScreen = {TabItem.notifications: ScreenItem.invitationsReceivedScreen};
                  _homeScreen.changeFloatingActionButtonEvent();
                  return MaterialPageRoute(
                    builder: (context) => const ConnectionRequestScreen(),
                  );
                /*
                case '/chat':
                  _homeScreen.currentScreen = {TabItem.notifications: ScreenItem.chatScreen};
                  _homeScreen.changeFloatingActionButtonEvent();

                  return MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  );
                 */
                default:
                  debugPrint('ERROR: Notification Tab Router unknown route');
                  return null;
              }
            },
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
