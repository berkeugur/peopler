import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/model/chat.dart';
import '../../cubits/NewMessageCubit.dart';

@immutable
abstract class ChatEvent extends Equatable {}

class GetChatWithPaginationEvent extends ChatEvent {
  final String userID;
  final NewMessageCubit newMessageCubit;

  GetChatWithPaginationEvent({
    required this.userID,
    required this.newMessageCubit
  });

  @override
  List<Object> get props => [userID, newMessageCubit];
}

class NewChatListenerEvent extends ChatEvent {
  final List<Chat> updatedChat;
  final NewMessageCubit newMessageCubit;

  NewChatListenerEvent({
    required this.updatedChat,
    required this.newMessageCubit
  });

  @override
  List<Object> get props => [updatedChat, newMessageCubit];
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

class TrigChatNotExistStateEvent extends ChatEvent {
  @override
  List<Object> get props => [];
}
