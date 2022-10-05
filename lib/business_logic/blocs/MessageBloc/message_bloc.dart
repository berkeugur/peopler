import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/model/message.dart';
import '../../../data/model/chat.dart';
import '../../../data/repository/message_repository.dart';
import '../../../data/send_notification_service.dart';
import '../../../data/services/db/firestore_db_service_users.dart';
import '../../../others/locator.dart';
import '../../../others/strings.dart';
import 'bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository _messageRepository = locator<MessageRepository>();
  final SendNotificationService _sendNotificationService = locator<SendNotificationService>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  List<Message> _allMessageList = [];
  List<Message> get allMessageList => _allMessageList;

  static const int _numberOfElements = 20;
  Message? _lastSelectedMessage;
  StreamSubscription? _streamSubscription;
  bool _newMessageListenListener = false;
  bool _hasMore = true;
  Chat? currentChat;

  bool isScrolling = false;

  MessageBloc() : super(InitialMessageState()) {
    on<GetMessageWithPaginationEvent>((event, emit) async {
      if (_hasMore == false) {
        emit(NoMoreMessagesState());
      } else {
        if (_allMessageList.isNotEmpty) {
          _lastSelectedMessage = _allMessageList.first;
        }

        /// _newMessageListenListener is false, then this event called first time.
        if (_newMessageListenListener == false) {
          emit(InitialMessageState());
        } else {
          emit(MessagesLoadingState());
        }

        // await Future.delayed(const Duration(seconds: 2));

        /// Get messages descending from last created message (Example: 50 -> 30)
        List<Message> newChatList = await _messageRepository.getMessageWithPagination(UserBloc.user!.userID, currentChat!.hostID, _lastSelectedMessage, _numberOfElements);

        if (newChatList.length < _numberOfElements) {
           _hasMore = false;
        }

        newChatList = List.from(newChatList.reversed);

        /// Add the new list beginning of the allMessageList (Example: 30 -> 50 + 51 -> 70)
        _allMessageList = [...newChatList, ..._allMessageList];

        if (_allMessageList.isNotEmpty) {
          if (_newMessageListenListener == false) {
            emit(MessagesLoadedFirstTimeState());
          } else {
            emit(MessagesLoadedState());
          }
        } else {
          emit(MessageNotExistState());
        }

        if (_newMessageListenListener == false) {
          _newMessageListenListener = true;
          _streamSubscription = _messageRepository
              .getMessages(UserBloc.user!.userID, currentChat!.hostID)
              .listen((newMessage) {
            /// Call another ChatBloc event named NewChatListenerEvent
            add(NewMessageListenerEvent(newMessage: newMessage));
          });
        }
      }
    });

    on<NewMessageListenerEvent>((event, emit) async {
      if (event.newMessage.isNotEmpty) {
        if (!(_allMessageList.map((item) => item.messageID).contains(event.newMessage[0].messageID))) {
          _allMessageList.insert(_allMessageList.length, event.newMessage[0]);
          if(state is NewMessageReceivedState1) {
            emit(NewMessageReceivedState2());
          } else {
            emit(NewMessageReceivedState1());
          }
        }
      }
    });

    on<SaveMessageEvent>((event, emit) async {

      await _messageRepository.saveMessage(event.newMessage);

      /// Send host user a message notification
      String _token = await _firestoreDBServiceUsers.getToken(event.newMessage.to);
      await _sendNotificationService.sendNotification(Strings.message, _token, event.newMessage.message, UserBloc.user!.displayName, UserBloc.user!.profileURL, UserBloc.user!.userID);

      if(state is MessageNotExistState) {
        emit(MessagesLoadedState());
      }
    });
  }

  @override
  Future<void> close() async {
    await closeStreams();
    await super.close();
  }

  Future<void> closeStreams() async {
    if (_streamSubscription != null) {
      await _streamSubscription?.cancel();
    }
  }
}
