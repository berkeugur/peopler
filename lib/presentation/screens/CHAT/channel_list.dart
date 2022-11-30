import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import '../../../business_logic/blocs/ChatBloc/chat_bloc.dart';
import '../../../business_logic/blocs/ChatBloc/chat_event.dart';
import '../../../business_logic/blocs/ChatBloc/chat_state.dart';
import '../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../business_logic/cubits/NewMessageCubit.dart';
import '../../../components/FlutterWidgets/text_style.dart';
import '../../../data/model/chat.dart';
import '../../../others/empty_list.dart';
import '../../../others/locator.dart';
import '../MESSAGE/message_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatBloc _chatBloc;

  static const double _borderRadius = 15;
  static const double _imageSize = 50;
  Size? _size;

  late ScrollController _notificationScrollController;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc();

    if (UserBloc.user != null) {
      NewMessageCubit _newMessageCubit = BlocProvider.of<NewMessageCubit>(context);
      _chatBloc.add(GetChatWithPaginationEvent(userID: UserBloc.user!.userID, newMessageCubit: _newMessageCubit));
    }
  }

  @override
  void didChangeDependencies() {
    _size = MediaQuery.of(context).size;
    super.didChangeDependencies();
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
                body: Builder(
                  // This Builder is needed to provide a BuildContext that is "inside"
                  // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
                  // find the NestedScrollView.
                  builder: (BuildContext context) {
                    _notificationScrollController =
                        context.findAncestorStateOfType<NestedScrollViewState>()!.innerController;
                    if (_notificationScrollController.hasListeners == false) {
                      _notificationScrollController.addListener(_listScrollListener);
                    }
                    return CustomScrollView(
                      // The controller must be the inner controller of nested scroll view widget.
                      controller: _notificationScrollController,
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          // This is the flip side of the SliverOverlapAbsorber above.
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        BlocBuilder<ChatBloc, ChatState>(
                          bloc: _chatBloc,
                          builder: (context, state) {
                            if (state is InitialChatState) {
                              return _initialChatsStateWidget();
                            } else if (state is ChatNotExistState) {
                              return _noChatExistsWidget();
                            } else if (state is ChatsLoadedState1) {
                              loading = false;
                              return _showChatsWidget();
                            } else if (state is ChatsLoadedState2) {
                              loading = false;
                              return _showChatsWidget();
                            } else if (state is NoMoreChatsState) {
                              return _showChatsWidget();
                            } else if (state is ChatsLoadingState) {
                              return _showChatsWidget();
                            } else {
                              return const Text("Impossible");
                            }
                          },
                        ),
                        BlocBuilder<ChatBloc, ChatState>(
                            bloc: _chatBloc,
                            builder: (context, state) {
                              if (state is ChatsLoadingState) {
                                return _chatsLoadingCircularButton();
                              } else {
                                return const SliverToBoxAdapter(child: SizedBox.shrink());
                              }
                            }),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  SliverList _showChatsWidget() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          Chat currentChat = _chatBloc.allChatList[index];

          String _image = currentChat.hostUserProfileUrl;
          String _nameSurname = currentChat.hostUserName;
          String _lastMassage = currentChat.lastMessage;
          bool _isNewMessage = currentChat.numberOfMessagesThatIHaveNotOpened == 0 ? false : true;
          int _numberOfNewMessage = currentChat.numberOfMessagesThatIHaveNotOpened;
          DateTime _lastMessageDate = currentChat.lastMessageCreatedAt;

          DateTime _now = DateTime.now();

          String _channelListItemDate() {
            int _subtractDay = _now.difference(_lastMessageDate).inDays;

            if (_subtractDay < 1) {
              return _lastMessageDate.hour.toString() + ":" + _lastMessageDate.minute.toString();
            } else if (_subtractDay >= 1 && _subtractDay < 2) {
              return "Dün";
            } else {
              return _lastMessageDate.day.toString() +
                  "." +
                  _lastMessageDate.month.toString() +
                  "." +
                  _lastMessageDate.year.toString();
            }
          }

          return InkWell(
            onTap: () {
              UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
              _userBloc.mainKey.currentState?.push(
                MaterialPageRoute(builder: (context) => MessageScreen(currentChat: currentChat)),
              );
            },
            onLongPress: () {},
            child: Container(
              margin: EdgeInsets.only(bottom: 15, right: 15, top: index == 0 ? 30 : 0),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFF939393).withOpacity(0.6),
                      blurRadius: 0.5,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    )
                  ],
                  color: Mode()
                      .homeScreenScaffoldBackgroundColor(), //_isNewMessage == true ? Colors.white : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(_borderRadius),
                    topLeft: Radius.circular(_borderRadius),
                    topRight: Radius.circular(_borderRadius),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProfilePhoto(_image),
                  _buildNameAndLastMessage(_nameSurname, _lastMassage, _isNewMessage),
                  _buildDateAndNumberOfNewMessages(_channelListItemDate, _numberOfNewMessage)
                ],
              ),
            ),
          );
        },
        childCount: _chatBloc.allChatList.length,
      ),
    );
  }

  SliverToBoxAdapter _initialChatsStateWidget() {
    return const SliverToBoxAdapter(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  SliverToBoxAdapter _noChatExistsWidget() {
    return const SliverToBoxAdapter(
      child: EmptyList(
        emptyListType: EmptyListType.emptyChannelList,
        isSVG: false,
      ),
    );
  }

  SliverToBoxAdapter _chatsLoadingCircularButton() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: const [
          Expanded(flex: 5, child: SizedBox()),
          Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
          Expanded(flex: 5, child: SizedBox()),
        ]),
      ),
    );
  }

  bool _listScrollListener() {
    NewMessageCubit _newMessageCubit = BlocProvider.of<NewMessageCubit>(context);
    var nextPageTrigger = 0.8 * _notificationScrollController.positions.last.maxScrollExtent;

    if (_notificationScrollController.positions.last.axisDirection == AxisDirection.down &&
        _notificationScrollController.positions.last.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        _chatBloc.add(GetChatWithPaginationEvent(userID: UserBloc.user!.userID, newMessageCubit: _newMessageCubit));
      }
    }

    return true;
  }

  Container _buildProfilePhoto(String _image) {
    return Container(
        height: _imageSize,
        width: _imageSize,
        margin: const EdgeInsets.only(right: 15, left: 10),
        child: CachedNetworkImage(
          imageUrl: _image,
          progressIndicatorBuilder: (context, url, downloadProgress) => ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ));
  }

  SizedBox _buildNameAndLastMessage(String _nameSurname, String _lastMassage, bool _isNewMessage) {
    return SizedBox(
      width: _size!.width >= 600 ? 600 - 165 : _size!.width - 165,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _nameSurname,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Mode().blackAndWhiteConversion(),
            ),
          ),
          Text(
            _lastMassage,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(
              fontSize: 14,
              color:
                  _isNewMessage != true ? const Color.fromARGB(255, 204, 203, 203) : Mode().blackAndWhiteConversion(),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildDateAndNumberOfNewMessages(String Function() _channelListItemDate, int _numberOfNewMessage) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            child: Text(
              _channelListItemDate(),
              style: PeoplerTextStyle.normal.copyWith(fontSize: 12, color: Mode().blackAndWhiteConversion()),
            ),
          ),
          _numberOfNewMessage != 0
              ? Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0353EF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(99),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _numberOfNewMessage < 100 ? _numberOfNewMessage.toString() : "99+",
                      style: PeoplerTextStyle.normal.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
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
