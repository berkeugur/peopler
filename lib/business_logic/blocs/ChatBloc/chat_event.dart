import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/chat.dart';

@immutable
abstract class ChatEvent extends Equatable {}

class GetChatWithPaginationEvent extends ChatEvent {
  final String userID;
  GetChatWithPaginationEvent({
    required this.userID,
  });

  @override
  List<Object> get props => [userID];
}

class NewChatListenerEvent extends ChatEvent {
  final List<Chat> updatedChat;
  NewChatListenerEvent({
    required this.updatedChat,
  });

  @override
  List<Object> get props => [updatedChat];
}

class UpdateLastMessageSeenEvent extends ChatEvent {
  final String hostUserID;
  UpdateLastMessageSeenEvent({
    required this.hostUserID,
  });

  @override
  List<Object> get props => [hostUserID];
}

class CreateChatEvent extends ChatEvent {
  final String hostUserID;
  final String hostUserName;
  final String hostUserProfileUrl;
  CreateChatEvent({
    required this.hostUserID,
    required this.hostUserName,
    required this.hostUserProfileUrl
  });

  @override
  List<Object> get props => [hostUserID, hostUserName, hostUserProfileUrl];
}


