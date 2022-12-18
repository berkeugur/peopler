import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../cubits/FloatingActionButtonCubit.dart';

@immutable
abstract class NewMessageEvent extends Equatable {}

class NewMessageReceivedEvent extends NewMessageEvent {
  final FloatingActionButtonCubit homeScreen;

  NewMessageReceivedEvent({
    required this.homeScreen,
  });

  @override
  List<Object> get props => [homeScreen];
}

class MessageSeenEvent extends NewMessageEvent {
  @override
  List<Object> get props => [];
}

class CheckIfThereIsNewMessage extends NewMessageEvent {
  final FloatingActionButtonCubit homeScreen;

  CheckIfThereIsNewMessage({
    required this.homeScreen,
  });

  @override
  List<Object> get props => [homeScreen];
}
