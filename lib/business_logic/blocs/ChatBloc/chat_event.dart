import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/model/chat.dart';
import '../NewMessageBloc/new_message_bloc.dart';

@immutable
abstract class ChatEvent extends Equatable {}

class GetChatWithPaginationEvent extends ChatEvent {
  final String userID;
  final NewMessageBloc newMessageBloc;
  final BuildContext context;

  GetChatWithPaginationEvent({required this.userID, required this.newMessageBloc, required this.context});

  @override
  List<Object> get props => [userID, newMessageBloc];
}

class NewChatListenerEvent extends ChatEvent {
  final List<Chat> updatedChat;
  final NewMessageBloc newMessageBloc;
  final BuildContext context;

  NewChatListenerEvent({required this.updatedChat, required this.newMessageBloc, required this.context});

  @override
  List<Object> get props => [updatedChat, newMessageBloc];
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
  CreateChatEvent({required this.hostUserID, required this.hostUserName, required this.hostUserProfileUrl});

  @override
  List<Object> get props => [hostUserID, hostUserName, hostUserProfileUrl];
}

class TrigChatNotExistStateEvent extends ChatEvent {
  @override
  List<Object> get props => [];
}

class ResetChatEvent extends ChatEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
