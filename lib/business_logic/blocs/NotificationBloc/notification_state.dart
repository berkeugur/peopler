import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class InitialNotificationState extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationsLoadingState extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoadedState1 extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoadedState2 extends NotificationState {
  @override
  List<Object> get props => [];
}

class NoMoreNotificationState extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationNotExistState extends NotificationState {
  @override
  List<Object> get props => [];
}
