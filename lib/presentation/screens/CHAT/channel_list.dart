import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import '../../../business_logic/blocs/ChatBloc/chat_bloc.dart';
import '../../../others/locator.dart';
import 'channel_list_components/channel_list_body.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatBloc _chatBloc;

  @override
  void initState() {
    _chatBloc = ChatBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return SafeArea(
            child: BlocProvider<ChatBloc>(
              create: (BuildContext context) => _chatBloc,
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool? innerBoxIsScrolled) {
                  return <Widget>[
                    SliverOverlapAbsorber(
                      // This widget takes the overlapping behavior of the SliverAppBar,
                      // and redirects it to the SliverOverlapInjector below. If it is
                      // missing, then it is possible for the nested "inner" scroll view
                      // below to end up under the SliverAppBar even when the inner
                      // scroll view thinks it has not been scrolled.
                      // This is not necessary if the "headerSliverBuilder" only builds
                      // widgets that do not overlap the next sliver.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: MyChatScreenAppBar(),
                    ),
                  ];
                },
                body: const ChannelListBody(),
              ),
            ),
          );
        });
  }
}

class MyChatScreenAppBar extends StatelessWidget {
  MyChatScreenAppBar({
    Key? key,
  }) : super(key: key);

  final Mode _mode = locator<Mode>();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: true,
      floating: true,
      title: const PEOPLER_TITLE(),
      centerTitle: true,
      backgroundColor: _mode.bottomMenuBackground(),
      shadowColor: Colors.transparent,
    );
  }
}
