import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peopler/data/model/message.dart';

@immutable
abstract class MessageEvent extends Equatable {}

class GetMessageWithPaginationEvent extends MessageEvent {
  GetMessageWithPaginationEvent();

  @override
  List<Object> get props => [];
}

class NewMessageListenerEvent extends MessageEvent {
  final List<Message> newMessage;
  NewMessageListenerEvent({
    required this.newMessage,
  });

  @override
  List<Object> get props => [newMessage];
}

class SaveMessageEvent extends MessageEvent {
  final Message newMessage;

  SaveMessageEvent({
    required this.newMessage,
  });

  @override
  List<Object> get props => [newMessage];
}
