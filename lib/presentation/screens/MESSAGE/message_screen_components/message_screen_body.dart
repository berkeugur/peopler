import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/data/model/message.dart';
import '../../../../business_logic/blocs/MessageBloc/bloc.dart';

ValueNotifier<double> contHeight = ValueNotifier(20.0);

class MessageScreenBody extends StatelessWidget {
  MessageScreenBody({
    Key? key,
    required this.messageListController,
  }) : super(key: key);

  final ScrollController messageListController;

  late final Size _size;
  late final DateTime _now;

  late final MessageBloc _messageBloc;

  late final double messageHeight;
  late final double loadMoreOffset;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _now = DateTime.now();

    _messageBloc = BlocProvider.of<MessageBloc>(context);

    messageHeight = MediaQuery.of(context).size.height / 20;
    loadMoreOffset = messageHeight * 40;

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Expanded(
            child: SizedBox(
              width: _size.width >= 600 ? 600 : _size.width,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollNotification) => _listScrollListener(context, loadMoreOffset),
                child: SingleChildScrollView(
                  controller: messageListController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<MessageBloc, MessageState>(
                          bloc: _messageBloc,
                          builder: (context, state) {
                            if (state is MessagesLoadingState) {
                              return _messagesLoadingCircularButton();
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                      BlocBuilder<MessageBloc, MessageState>(
                        bloc: _messageBloc,
                        builder: (context, state) {
                          if (state is InitialMessageState) {
                            return _initialMessagesStateWidget(context);
                          } else if (state is MessageNotExistState) {
                            return _noMessagesExistsWidget(context);
                          } else if (state is MessagesLoadedFirstTimeState) {
                            _messageBloc.isScrolling = false;
                            return _showMessagesFirstTime();
                          } else if (state is MessagesLoadedState) {
                            _messageBloc.isScrolling = false;
                            return _showMessages();
                          } else if (state is NewMessageReceivedState1 || state is NewMessageReceivedState2) {
                            _messageBloc.isScrolling = false;
                            return _newMessageLoaded();
                          } else if (state is NoMoreMessagesState) {
                            return _showMessages();
                          } else if (state is MessagesLoadingState) {
                            return _showMessages();
                          } else {
                            return const Text("Impossible");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Padding _messagesLoadingCircularButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: const [
        Expanded(flex: 5, child: SizedBox()),
        Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
        Expanded(flex: 5, child: SizedBox()),
      ]),
    );
  }

  _showMessagesFirstTime() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1), (() {
        messageListController.jumpTo(messageListController.position.maxScrollExtent);
      }));
    });
    return _showMessages();
  }

  _newMessageLoaded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1), (() {
        messageListController.jumpTo(messageListController.position.maxScrollExtent);
      }));
    });
    return _showMessages();
  }

  _showMessages() {
    List<Message> _messages = _messageBloc.allMessageList;
    return GroupedListView<dynamic, String>(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        elements: _messageBloc.allMessageList,
        groupBy: (element) => DateFormat("yyyy-MM-dd").format(element.createdAt),
        groupComparator: (value1, value2) => value2.compareTo(value1),
        itemComparator: (item1, item2) => item1.from.compareTo(item2.from),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: false,
        dragStartBehavior: DragStartBehavior.down,
        sort: false,
        groupSeparatorBuilder: (String value) => _buildDate(value, _now),
        indexedItemBuilder: (context, t, index) {
          bool _isNextItem = _messages[index + (_messages.length - 1 != index ? 1 : 0)].from == _messages[index].from ? true : false;
          bool _isPreviousItem = _messages[index -
                          (_messages.length - 1 != index
                              ? index != 0
                                  ? 1
                                  : 0
                              : 0)]
                      .from ==
                  _messages[index].from
              ? true
              : false;
          return _messages[index].from == UserBloc.user!.userID
              ? _buildMyMessage(_isNextItem, _isPreviousItem, _size, _messages, index)
              : _buildHostMessage(_isNextItem, _size, _isPreviousItem, _messages, index);
        });
  }

  bool _listScrollListener(BuildContext context, double loadMoreOffset) {
    final MessageBloc _messageBloc = BlocProvider.of<MessageBloc>(context);

    /*
    // If you force to screen to scroll bottom when there is no possible scrolling place
    if (messageListController.position.pixels >= messageListController.position.maxScrollExtent && messageListController.position.userScrollDirection == ScrollDirection.reverse) {
      // debugPrint('bottom' + messageListController.position.pixels.toString());
    }

    // If you force to screen to scroll top when there is no possible scrolling place
    if (messageListController.position.pixels <= messageListController.position.minScrollExtent && messageListController.position.userScrollDirection == ScrollDirection.forward) {
      // debugPrint('top' + messageListController.position.pixels.toString());
    }
     */

    // To prevent add GetMessageWithPaginationEvent multiple times
    if (_messageBloc.isScrolling == false) {
      // When scroll position distance to top(0.0) is less than load more offset,
      if (messageListController.position.pixels <= loadMoreOffset && messageListController.position.userScrollDirection == ScrollDirection.forward) {
        _messageBloc.isScrolling = true;
        // If state is MessagesLoadedState
        if (_messageBloc.state is MessagesLoadedState ||
            _messageBloc.state is MessagesLoadedFirstTimeState ||
            _messageBloc.state is NewMessageReceivedState1 ||
            _messageBloc.state is NewMessageReceivedState2) {
          _messageBloc.add(GetMessageWithPaginationEvent());
        }
      }
    }
    return true;
  }

  SizedBox _initialMessagesStateWidget(context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  SizedBox _noMessagesExistsWidget(context) {
    return const SizedBox.shrink();
    /*
    SizedBox(
      height: MediaQuery.of(context).size.height - 134,
      child: Center(
        child: Text(
          "İlk adımı sen at \nHemen mesajlaşmaya Başla",
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
              color: Mode().blackAndWhiteConversion(), fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
    );
    */
  }

  Container _buildDate(String value, DateTime _now) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
              valueListenable: contHeight,
              builder: (context, snapshot, _) {
                return AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: contHeight.value,
                  margin: const EdgeInsets.only(bottom: 13, top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: Colors.grey[500],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 3,
                    ),
                    child: Center(
                      child: Text(
                        value.toString().substring(0, 10) == _now.toString().substring(0, 10)
                            ? "Bugün"
                            : value.toString().substring(0, 10) == _now.subtract(const Duration(days: 1)).toString().substring(0, 10)
                                ? "Dün"
                                : DateFormat("dd MMMM yyyy", "tr_TR").format(DateTime.parse(value)).toString(),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Row _buildHostMessage(bool _isNextItem, Size _size, bool _isPreviousItem, List<Message> _messages, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 35),
          padding: const EdgeInsets.only(left: 8, right: 6, top: 7, bottom: 5),
          margin: EdgeInsets.only(
            bottom: _isNextItem ? 5 : 15,
            right: (_size.width >= 600 ? 600 : _size.width) * 0.2,
            left: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: _isPreviousItem ? const Radius.circular(5) : const Radius.circular(15),
              topRight: _isPreviousItem ? const Radius.circular(15) : const Radius.circular(15),
              bottomRight: _isNextItem ? const Radius.circular(15) : const Radius.circular(15),
              bottomLeft: _isNextItem ? const Radius.circular(5) : const Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: (_size.width >= 600 ? 600 : _size.width) * 0.8 - 65),
                child: Text(
                  _messages[index].message,
                  textScaleFactor: 1,
                  textAlign: TextAlign.left,
                  style: PeoplerTextStyle.normal.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 30,
                child: Text(
                  _messages[index].createdAt.toString().substring(10, 16),
                  textScaleFactor: 1,
                  textAlign: TextAlign.end,
                  style: PeoplerTextStyle.normal.copyWith(
                    fontSize: 11,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildMyMessage(bool _isNextItem, bool _isPreviousItem, Size _size, List<Message> _messages, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF0353EF),
            borderRadius: BorderRadius.only(
              topLeft: _isNextItem ? const Radius.circular(15) : const Radius.circular(15),
              topRight: _isPreviousItem ? const Radius.circular(5) : const Radius.circular(15),
              bottomRight: _isNextItem ? const Radius.circular(5) : const Radius.circular(15),
              bottomLeft: _isNextItem ? const Radius.circular(15) : const Radius.circular(15),
            ),
          ),
          margin: EdgeInsets.only(
            left: (_size.width >= 600 ? 600 : _size.width) * 0.2,
            bottom: _isNextItem ? 5 : 10,
            right: 10,
          ),
          constraints: const BoxConstraints(minHeight: 35),
          padding: const EdgeInsets.only(left: 12, right: 6, top: 7, bottom: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: (_size.width >= 600 ? 600 : _size.width) * 0.8 - 70),
                child: Text(
                  _messages[index].message,
                  textScaleFactor: 1,
                  textAlign: TextAlign.left,
                  style: PeoplerTextStyle.normal.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 30,
                child: Text(
                  _messages[index].createdAt.toString().substring(10, 16),
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                    fontSize: 11,
                    color: Color(0xFFB3CBFA),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
