import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/core/constants/enums/screen_item_enum.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/others/widgets/drawer.dart';
import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../screens/GuestLoginScreen/guest_login_screen.dart';

class ProfileScreenNavigator extends StatefulWidget {
  const ProfileScreenNavigator({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileScreenNavigatorState createState() => _ProfileScreenNavigatorState();
}

class _ProfileScreenNavigatorState extends State<ProfileScreenNavigator> with AutomaticKeepAliveClientMixin {
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
            key: _homeScreen.navigatorKeys[TabItem.profile],
            initialRoute: NavigationConstants.INITIAL_ROUTE,
            onGenerateRoute: (routeSettings) {
              switch (routeSettings.name) {
                case NavigationConstants.INITIAL_ROUTE:
                  _homeScreen.currentScreen = {TabItem.profile: ScreenItem.profileScreen};
                  _homeScreen.changeFloatingActionButtonEvent();
                  if (UserBloc.user == null) {
                    return MaterialPageRoute(
                      builder: (context) => const GuestLoginScreen(),
                    );
                  }

                  return MaterialPageRoute(
                    builder: (context) => const DrawerProfilePage(),
                  );
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
