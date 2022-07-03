import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import '../../../business_logic/blocs/ChatBloc/chat_bloc.dart';
import 'channel_list_components/channel_list_top_menu.dart';
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
          return BlocProvider<ChatBloc>(
            create: (BuildContext context) => _chatBloc,
            child: Scaffold(
              backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
              body: SafeArea(
                child: Column(
                  children: [
                    channelListTopMenu(context),
                    const ChannelListBody(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
