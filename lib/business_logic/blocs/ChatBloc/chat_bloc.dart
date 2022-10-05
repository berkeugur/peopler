import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/repository/chat_repository.dart';
import 'package:peopler/data/services/db/firestore_db_service_users.dart';
import '../../../data/model/chat.dart';
import '../../../data/model/user.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository = locator<ChatRepository>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  final List<Chat> _allChatList = [];
  List<Chat> get allChatList => _allChatList;

  static const int _numberOfElements = 20;
  static Chat? _lastSelectedChat;
  static StreamSubscription? _streamSubscription;
  static bool _newChatListenListener = false;
  static bool _hasMore = true;

  ChatBloc() : super(InitialChatState()) {
    on<GetChatWithPaginationEvent>((event, emit) async {
      if (_hasMore == false) {
        emit(NoMoreChatsState());
      } else {
        if (_allChatList.isNotEmpty) {
          _lastSelectedChat = _allChatList.last;
        }

        emit(ChatsLoadingState());

        List<Chat> newChatList = await _chatRepository.getChatWithPagination(event.userID, _lastSelectedChat, _numberOfElements);

        if (newChatList.length < _numberOfElements) {
          _hasMore = false;
        }

        _allChatList.addAll(newChatList);

        if(_allChatList.isNotEmpty) {
          if(state is ChatsLoadedState1) {
            emit(ChatsLoadedState2());
          } else {
            emit(ChatsLoadedState1());
          }
        } else {
          emit(ChatNotExistState());
        }

        if (_newChatListenListener == false) {
          _newChatListenListener = true;
          _streamSubscription = _chatRepository
              .getChatWithStream(event.userID)
              .listen((updatedChat) async {

                if(updatedChat.isNotEmpty) {
                  MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(updatedChat[0].hostID);
                  updatedChat[0].hostUserName = _user!.displayName;
                  updatedChat[0].hostUserProfileUrl = _user.profileURL;

                  /// Call another ChatBloc event named NewChatListenerEvent
                  add(NewChatListenerEvent(updatedChat: updatedChat));
                } else {
                  add(TrigChatNotExistStateEvent());
                }
          });
        }
      }
    });

    on<TrigChatNotExistStateEvent>((event, emit) async {
        emit(ChatNotExistState());
    });

    on<NewChatListenerEvent>((event, emit) async {
        /// If there is a chat with updatedChat id, then remove it from _allChatList.
        /// Since updatedChat is a list with only one element, we get the only element whose index is 0.
        _allChatList.removeWhere((item) => item.hostID == event.updatedChat[0].hostID);

        /// Since this event runs, related chat last message received for host will be true
        await _chatRepository.updateIsLastMessageReceivedByHost(event.updatedChat[0].hostID, UserBloc.user!.userID, true);

        /// Insert updatedChat at the top of list
        _allChatList.insert(0, event.updatedChat[0]);

        if(state is ChatsLoadedState1) {
          emit(ChatsLoadedState2());
        } else {
          emit(ChatsLoadedState1());
        }
    });

    on<UpdateLastMessageSeenEvent>((event, emit) async {
      /// Since this event runs, related chat last message received for host will be true
      await _chatRepository.updateIsLastMessageSeenByHost(event.hostUserID, UserBloc.user!.userID, true);
      await _chatRepository.resetNumberOfNotOpenedMessages(UserBloc.user!.userID, event.hostUserID);
    });

    on<CreateChatEvent>((event, emit) async {

      /// Create chat object for owner
      Chat _chat = Chat(
          hostID: event.hostUserID,
          isLastMessageFromMe: false,
          isLastMessageReceivedByHost: false,
          isLastMessageSeenByHost: false,
          lastMessageCreatedAt: DateTime.now(),
          lastMessage: "",
          numberOfMessagesThatIHaveNotOpened: 0
      );

      await _chatRepository.createChat(UserBloc.user!.userID, _chat);

      /// Create chat object for host
      _chat = Chat(
          hostID: UserBloc.user!.userID,
          isLastMessageFromMe: false,
          isLastMessageReceivedByHost: false,
          isLastMessageSeenByHost: false,
          lastMessageCreatedAt: DateTime.now(),
          lastMessage: "",
          numberOfMessagesThatIHaveNotOpened: 0
      );

      await _chatRepository.createChat(event.hostUserID, _chat);
    });
  }

  @override
  Future<void> close() async {
    await closeStreams();
    await super.close();
  }

  static Future<void> closeStreams() async {
    if (_streamSubscription != null) {
      await _streamSubscription?.cancel();
    }
  }
}
