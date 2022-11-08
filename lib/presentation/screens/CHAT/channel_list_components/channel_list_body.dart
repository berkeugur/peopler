import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/cubits/NewMessageCubit.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import '../../../../../business_logic/blocs/ChatBloc/bloc.dart';
import '../../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../../data/model/chat.dart';
import '../../MESSAGE/message_screen.dart';
import '../../../../others/empty_list.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class ChannelListBody extends StatefulWidget {
  const ChannelListBody({Key? key}) : super(key: key);

  @override
  ChannelListBodyState createState() => ChannelListBodyState();
}

class ChannelListBodyState extends State<ChannelListBody> {
  late final ChatBloc _chatBloc;

  static const double _borderRadius = 15;
  static const double _imageSize = 50;
  Size? _size;

  late ScrollController _scrollController;

  double? loadMoreOffset;
  double? chatHeight;

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);

    if (UserBloc.user != null) {
      NewMessageCubit _newMessageCubit = BlocProvider.of<NewMessageCubit>(context);
      _chatBloc.add(GetChatWithPaginationEvent(userID: UserBloc.user!.userID, newMessageCubit: _newMessageCubit));
    }
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    _size = MediaQuery.of(context).size;
    chatHeight = MediaQuery.of(context).size.height / 6;
    loadMoreOffset = chatHeight! * 5;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollNotification) => _listScrollListener(),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<ChatBloc, ChatState>(
                    bloc: _chatBloc,
                    builder: (context, state) {
                      if (state is InitialChatState) {
                        return _initialChatsStateWidget();
                      } else if (state is ChatNotExistState) {
                        return _noChatExistsWidget();
                      } else if (state is ChatsLoadedState1) {
                        return _showChatsWidget();
                      } else if (state is ChatsLoadedState2) {
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
                          return const SizedBox.shrink();
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }

  ListView _showChatsWidget() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _chatBloc.allChatList.length,
      itemBuilder: (BuildContext context, int index) {
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
            return _lastMessageDate.day.toString() + "." + _lastMessageDate.month.toString() + "." + _lastMessageDate.year.toString();
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
                color: Mode().homeScreenScaffoldBackgroundColor(), //_isNewMessage == true ? Colors.white : Colors.transparent,
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
    );
  }

  SizedBox _initialChatsStateWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  EmptyList _noChatExistsWidget() {
    return const EmptyList(
      emptyListType: EmptyListType.emptyChannelList,
      isSVG: false,
    );
  }

  Padding _chatsLoadingCircularButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: const [
        Expanded(flex: 5, child: SizedBox()),
        Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
        Expanded(flex: 5, child: SizedBox()),
      ]),
    );
  }

  bool _listScrollListener() {
    NewMessageCubit _newMessageCubit = BlocProvider.of<NewMessageCubit>(context);

    // When scroll position distance to bottom is less than load more offset,
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - (loadMoreOffset ?? 0) &&
        _scrollController.position.userScrollDirection == ScrollDirection.forward) {
      // If state is FeedsLoadedState
      if (_chatBloc.state is ChatsLoadedState1 || _chatBloc.state is ChatsLoadedState1) {
        _chatBloc.add(GetChatWithPaginationEvent(userID: UserBloc.user!.userID, newMessageCubit: _newMessageCubit));
      }
    }

    // If scroll position exceed max scroll extent (bottom),
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      // If state is NoMoreEventsState
      if (_chatBloc.state is NoMoreChatsState) {
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
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              ClipRRect(borderRadius: BorderRadius.circular(999), child: CircularProgressIndicator(value: downloadProgress.progress)),
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
              color: _isNewMessage != true ? const Color.fromARGB(255, 204, 203, 203) : Mode().blackAndWhiteConversion(),
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
