import 'package:equatable/equatable.dart';

abstract class NotificationReceivedState extends Equatable {
  const NotificationReceivedState();
}

class InitialNotificationReceivedState extends NotificationReceivedState {
  @override
  List<Object> get props => [];
}

class NewNotificationReceivedLoadingState extends NotificationReceivedState {
  @override
  List<Object> get props => [];
}

class NotificationReceivedLoaded1State extends NotificationReceivedState {
  @override
  List<Object> get props => [];
}

class NotificationReceivedLoaded2State extends NotificationReceivedState {
  @override
  List<Object> get props => [];
}

class NoMoreNotificationReceivedState extends NotificationReceivedState {
  @override
  List<Object> get props => [];
}

class NotificationReceivedNotExistState extends NotificationReceivedState {
  @override
  List<Object> get props => [];
}


