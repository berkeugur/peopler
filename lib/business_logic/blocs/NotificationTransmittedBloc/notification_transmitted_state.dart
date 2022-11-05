import 'package:equatable/equatable.dart';

abstract class NotificationTransmittedState extends Equatable {
  const NotificationTransmittedState();
}

class InitialNotificationTransmittedState extends NotificationTransmittedState {
  @override
  List<Object> get props => [];
}

class NewNotificationTransmittedLoadingState
    extends NotificationTransmittedState {
  @override
  List<Object> get props => [];
}

class NotificationTransmittedLoaded1State extends NotificationTransmittedState {
  @override
  List<Object> get props => [];
}

class NotificationTransmittedLoaded2State extends NotificationTransmittedState {
  @override
  List<Object> get props => [];
}

class NoMoreNotificationTransmittedState extends NotificationTransmittedState {
  @override
  List<Object> get props => [];
}

class NotificationTransmittedNotExistState
    extends NotificationTransmittedState {
  @override
  List<Object> get props => [];
}
