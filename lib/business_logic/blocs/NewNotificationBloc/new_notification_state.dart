import 'package:equatable/equatable.dart';

abstract class NewNotificationState extends Equatable {
  const NewNotificationState();
}

class NewNotificationTrueState extends NewNotificationState {
  const NewNotificationTrueState();

  @override
  List<Object> get props => [];
}


class NewNotificationFalseState extends NewNotificationState {
  const NewNotificationFalseState();

  @override
  List<Object> get props => [];
}
