import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/AddAnFeedBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import '../../../../business_logic/blocs/FeedBloc/bloc.dart';
import '../../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../../others/classes/variables.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../../../tab_item.dart';
import 'feed_share_body.dart';

class FeedShareScreen extends StatefulWidget {
  const FeedShareScreen({Key? key}) : super(key: key);

  @override
  _FeedShareScreenState createState() => _FeedShareScreenState();
}

GlobalKey<ScaffoldState> feedShareScaffoldKey = GlobalKey<ScaffoldState>();

class _FeedShareScreenState extends State<FeedShareScreen> {
  late final FeedBloc _feedBloc;
  late final FloatingActionButtonCubit _homeScreen;
  final Mode _mode = locator<Mode>();

  @override
  void initState() {
    super.initState();
    _feedBloc = BlocProvider.of<FeedBloc>(context);
    _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return BlocProvider<AddFeedBloc>(
            create: (context) => AddFeedBloc(),
            child: Builder(builder: (BuildContext context) {
              return BlocListener<AddFeedBloc, AddFeedState>(
                  listener: (BuildContext context, state) {
                    if (state is FeedCreateSuccessfulState) {
                      _feedBloc.add(AddMyFeedEvent(myFeed: state.myFeed));
                      _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.feedScreen};
                      _homeScreen.changeFloatingActionButtonEvent();
                      Navigator.of(context).pop();
                      feedController.clear();
                    } else if (state is FeedCreateErrorState) {
                      _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.feedScreen};
                      _homeScreen.changeFloatingActionButtonEvent();
                      Navigator.of(context).pop();
                      feedController.clear();
                    }
                  },
                  child: SafeArea(
                    child: Scaffold(
                        key: feedShareScaffoldKey,
                        resizeToAvoidBottomInset: false,
                        backgroundColor: _mode.feedShareScreenScaffoldBackgroundColor(),
                        body: feedShareBody(context: context, setState: setState)),
                  ));
            }),
          );
        });
  }
}
