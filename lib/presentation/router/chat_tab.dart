import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/presentation/screens/ChatScreen/channel_list.dart';
import 'package:peopler/presentation/screens/GuestLoginScreen/guest_login_screen.dart';
import '../../business_logic/blocs/SavedBloc/saved_bloc.dart';
import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../tab_item.dart';

class ChatScreenNavigator extends StatefulWidget {
  const ChatScreenNavigator({
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenNavigatorState createState() => _ChatScreenNavigatorState();
}

class _ChatScreenNavigatorState extends State<ChatScreenNavigator> with AutomaticKeepAliveClientMixin {
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
            key: _homeScreen.navigatorKeys[TabItem.chat],
            initialRoute: '/',
            onGenerateRoute: (routeSettings) {
              switch (routeSettings.name) {
                case '/':
                  _homeScreen.currentScreen = {TabItem.chat: ScreenItem.chatScreen};
                  _homeScreen.changeFloatingActionButtonEvent();
                  if (UserBloc.user != null) {
                    return MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(child: const ChatScreen(), providers: [
                        BlocProvider.value(value: _savedBloc),
                      ]),
                    );
                  } else {
                    return MaterialPageRoute(
                      builder: (context) => const GuestLoginScreen(),
                    );
                  }
                default:
                  debugPrint('ERROR: Chat Tab Router unknown route');
                  return null;
              }
            },
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
