import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/FeedBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/core/constants/enums/screen_item_enum.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';

import '../screens/feeds/FeedScreen/feed_screen.dart';

class FeedScreenNavigator extends StatefulWidget {
  final GlobalKey<FeedScreenState> feedListKey;

  const FeedScreenNavigator({
    Key? key,
    required this.feedListKey,
  }) : super(key: key);

  @override
  _FeedScreenNavigatorState createState() => _FeedScreenNavigatorState();
}

class _FeedScreenNavigatorState extends State<FeedScreenNavigator> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FeedBloc _feedBloc = BlocProvider.of<FeedBloc>(context);
    FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Navigator(
            key: _homeScreen.navigatorKeys[TabItem.feed],
            initialRoute: NavigationConstants.INITIAL_ROUTE,
            onGenerateRoute: (routeSettings) {
              switch (routeSettings.name) {
                case NavigationConstants.INITIAL_ROUTE:
                  _homeScreen.currentScreen = {TabItem.feed: ScreenItem.feedScreen};
                  _homeScreen.changeFloatingActionButtonEvent();

                  return MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                          child: FeedScreen(
                            key: widget.feedListKey,
                          ),
                          providers: [BlocProvider.value(value: _feedBloc), BlocProvider.value(value: _homeScreen)]));
                /*
                case '/addFeed':
                _homeScreen.currentScreen = {TabItem.feed: ScreenItem.addFeedScreen};
                _homeScreen.changeFloatingActionButtonEvent();

                return MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(providers: [
                    BlocProvider.value(value: _feedBloc),
                    BlocProvider.value(value: _addAnFeedBloc),
                  ], child: const FeedShareScreen()),
                );

              case '/settings':
                _homeScreen.currentScreen = {TabItem.feed: ScreenItem.settingsScreen};
                _homeScreen.changeFloatingActionButtonEvent();

                return MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                );

              case '/chat':
                _homeScreen.currentScreen = {TabItem.feed: ScreenItem.chatScreen};
                _homeScreen.changeFloatingActionButtonEvent();

                return MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                );
              */
                default:
                  debugPrint('ERROR: Event Tab Router unknown route');
                  return null;
              }
            },
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
