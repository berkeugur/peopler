import 'package:equatable/equatable.dart';

abstract class NewMessageState extends Equatable {
  const NewMessageState();
}

class NewMessageTrueState extends NewMessageState {
  const NewMessageTrueState();

  @override
  List<Object> get props => [];
}


class NewMessageFalseState extends NewMessageState {
  const NewMessageFalseState();

  @override
  List<Object> get props => [];
}
