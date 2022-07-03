import 'package:equatable/equatable.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class InitialMessageState extends MessageState {
  @override
  List<Object> get props => [];
}

class MessagesLoadingState extends MessageState {
  @override
  List<Object> get props => [];
}

class MessagesLoadedState extends MessageState {
  @override
  List<Object> get props => [];
}

class NewMessageReceivedState1 extends MessageState {
  @override
  List<Object> get props => [];
}

class NewMessageReceivedState2 extends MessageState {
  @override
  List<Object> get props => [];
}

class MessagesLoadedFirstTimeState extends MessageState {
  @override
  List<Object> get props => [];
}

class NoMoreMessagesState extends MessageState {
  @override
  List<Object> get props => [];
}

class MessageNotExistState extends MessageState {
  @override
  List<Object> get props => [];
}
