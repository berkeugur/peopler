import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/MessageBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/others/swipedetector.dart';
import '../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../data/model/chat.dart';
import '../../../data/model/message.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import 'message_screen_components/messageScreenTopMenu.dart';
import 'message_screen_components/message_screen_body.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'message_screen_functions.dart';

TextEditingController messageController = TextEditingController();

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key, this.requestUserID, this.requestProfileURL, this.requestDisplayName, this.currentChat}) : super(key: key);

  final String? requestUserID;
  final String? requestProfileURL;
  final String? requestDisplayName;

  final Chat? currentChat;

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with TickerProviderStateMixin {
  /*
  void _scrollToBottom() {
    if (messageListController.hasClients) {
      messageListController.animateTo(messageListController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(const Duration(milliseconds: 400), () => _scrollToBottom());
    }
  }
 */
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    print('_onEmojiSelected: ${emoji.emoji}');
  }

  _onBackspacePressed() {
    print('_onBackspacePressed');
  }

  late final MessageBloc _messageBloc;
  late final ScrollController messageListController;
  late final Mode _mode;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _messageBloc = MessageBloc();

    if (widget.currentChat == null) {
      Chat currentChat = Chat(
          hostID: widget.requestUserID!,
          isLastMessageFromMe: false,
          isLastMessageReceivedByHost: true,
          isLastMessageSeenByHost: true,
          lastMessageCreatedAt: DateTime.now(),
          lastMessage: "",
          numberOfMessagesThatIHaveNotOpened: 0);

      currentChat.hostUserProfileUrl = widget.requestProfileURL!;
      currentChat.hostUserName = widget.requestDisplayName!;

      _messageBloc.currentChat = currentChat;
    } else {
      _messageBloc.currentChat = widget.currentChat;
    }
    _messageBloc.add(GetMessageWithPaginationEvent());
    messageListController = ScrollController();
    _mode = locator<Mode>();
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return WillPopScope(
            onWillPop: () => popMessageScreen(context, _messageBloc.currentChat!.hostID),
            child: BlocProvider<MessageBloc>(
              create: (context) => _messageBloc,
              child: Builder(
                builder: (BuildContext context) {
                  return SwipeDetector(
                    onSwipeRight: () {
                      popMessageScreen(context, _messageBloc.currentChat!.hostID);
                    },
                    child: Scaffold(
                      backgroundColor: Mode.isEnableDarkMode == true ? const Color(0xFF000B21) : const Color(0xFFF0F4F5),
                      body: SafeArea(
                        child: Column(
                          children: [
                            messageScreenTopMenu(context, _controller, _messageBloc.currentChat?.hostID ?? "null host"),
                            MessageScreenBody(
                              messageListController: messageListController,
                            ),
                            message_input_field(context, messageListController),
                            Offstage(
                              offstage: !emojiShowing,
                              child: SizedBox(
                                height: 250,
                                child: EmojiPicker(
                                    textEditingController: messageController,
                                    onEmojiSelected: (Category? category, Emoji emoji) {
                                      _onEmojiSelected(emoji);
                                    },
                                    onBackspacePressed: _onBackspacePressed,
                                    config: Config(
                                        columns: 7,
                                        // Issue: https://github.com/flutter/flutter/issues/28894
                                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                                        verticalSpacing: 0,
                                        horizontalSpacing: 0,
                                        gridPadding: EdgeInsets.zero,
                                        initCategory: Category.RECENT,
                                        bgColor: const Color(0xFFF2F2F2),
                                        indicatorColor: Colors.blue,
                                        iconColor: Colors.grey,
                                        iconColorSelected: Colors.blue,
                                        backspaceColor: Colors.blue,
                                        skinToneDialogBgColor: Colors.white,
                                        skinToneIndicatorColor: Colors.grey,
                                        enableSkinTones: true,
                                        showRecentsTab: true,
                                        recentsLimit: 28,
                                        replaceEmojiOnLimitExceed: false,
                                        noRecents: const Text(
                                          'No Recents',
                                          style: TextStyle(fontSize: 20, color: Colors.black26),
                                          textAlign: TextAlign.center,
                                        ),
                                        tabIndicatorAnimDuration: kTabScrollDuration,
                                        categoryIcons: const CategoryIcons(),
                                        buttonMode: ButtonMode.MATERIAL)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  Widget message_input_field(context, ScrollController messageListController) {
    Size _size = MediaQuery.of(context).size;

    MessageBloc _messageBloc = BlocProvider.of<MessageBloc>(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: _size.width,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 2.0, spreadRadius: 0, offset: const Offset(0.0, 0.75))
        ],
        color: _mode.enabledMenuItemBackground(),
      ),
      height: 50,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();

              await Future.delayed(Duration(milliseconds: 200), (() {
                emojiShowing = !emojiShowing;
              }));
              setState(() {});
            },
            icon: Icon(
              Icons.tag_faces,
              size: 25,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                onTap: () {
                  setState(() {
                    emojiShowing = false;
                  });
                  Future.delayed(const Duration(milliseconds: 700), (() {
                    messageListController.jumpTo(messageListController.position.maxScrollExtent);
                  }));
                },
                controller: messageController,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: 99,
                cursorColor: Colors.white,
                minLines: 1,
                maxLength: MaxLengthConstants.MESSAGE,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Mesaj yazın',
                  counterText: "",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                if (messageController.text.isEmpty) {
                  debugPrint("boş mesaj gönderilemez");
                } else {
                  Message _newMessage = Message(
                      from: UserBloc.user!.userID,
                      to: _messageBloc.currentChat!.hostID,
                      isFromMe: true,
                      isReceived: false,
                      isSeen: false,
                      message: messageController.text);
                  _messageBloc.allMessageList.insert(_messageBloc.allMessageList.length, _newMessage);

                  _messageBloc.add(SaveMessageEvent(newMessage: _newMessage));
                  messageController.clear();
                  Future.delayed(const Duration(milliseconds: 300), (() {
                    messageListController.jumpTo(messageListController.position.maxScrollExtent);
                  }));
                  setState(() {});
                }
              },
              icon: Icon(
                Icons.send,
                size: 25,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
