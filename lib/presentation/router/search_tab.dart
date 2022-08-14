import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/SavedBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../screens/guest_login_screen.dart';
import '../screens/search/search_screen.dart';
import '../tab_item.dart';

class SearchScreenNavigator extends StatefulWidget {
  const SearchScreenNavigator({
    Key? key,
  }) : super(key: key);

  @override
  _SearchScreenNavigatorState createState() => _SearchScreenNavigatorState();
}

class _SearchScreenNavigatorState extends State<SearchScreenNavigator> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SavedBloc _savedBloc = BlocProvider.of<SavedBloc>(context);
    FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Navigator(
            key: _homeScreen.navigatorKeys[TabItem.search],
            initialRoute: '/',
            onGenerateRoute: (routeSettings) {
              switch (routeSettings.name) {
                case '/':
                  _homeScreen.currentScreen = {TabItem.search: ScreenItem.searchNearByScreen};
                  _homeScreen.changeFloatingActionButtonEvent();
                  if (UserBloc.user != null) {
                    return MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(child: const SearchScreen(), providers: [
                        BlocProvider.value(value: _savedBloc),
                      ]),
                    );
                  } else {
                    return MaterialPageRoute(
                      builder: (context) => const GuestLoginScreen(),
                    );
                  }
                default:
                  debugPrint('ERROR: Search Tab Router unknown route');
                  return null;
              }
            },
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
