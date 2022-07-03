import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import '../../business_logic/blocs/SavedBloc/saved_bloc.dart';
import '../screens/saved/saved_screen.dart';
import '../tab_item.dart';

class SavedScreenNavigator extends StatefulWidget {
  const SavedScreenNavigator({
    Key? key,
  }) : super(key: key);

  @override
  _SavedScreenNavigatorState createState() => _SavedScreenNavigatorState();
}

class _SavedScreenNavigatorState extends State<SavedScreenNavigator> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _savedBloc = BlocProvider.of<SavedBloc>(context);
    var _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Navigator(
            key: _homeScreen.navigatorKeys[TabItem.saved],
            initialRoute: '/',
            onGenerateRoute: (routeSettings) {
              switch (routeSettings.name) {
                case '/':
                  _homeScreen.currentScreen = {TabItem.saved: ScreenItem.savedScreen};
                  _homeScreen.changeFloatingActionButtonEvent();
                  return MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(child: const SavedScreen(), providers: [
                      BlocProvider.value(value: _savedBloc),
                    ]),
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
