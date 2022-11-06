import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class NotificationTransmittedEvent extends Equatable {}

class GetMoreDataTransmittedEvent extends NotificationTransmittedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetInitialDataTransmittedEvent extends NotificationTransmittedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GeriAlTransmittedButtonEvent extends NotificationTransmittedEvent {
  final String requestUserID;
  GeriAlTransmittedButtonEvent({
    required this.requestUserID,
  });

  @override
  List<Object> get props => [requestUserID];
}


/*
class AddMyNotificationTransmittedEvent extends NotificationTransmittedEvent {
  MyNotificationTransmitted myNotificationTransmitted;
  AddMyNotificationTransmittedEvent({
    required this.myNotificationTransmitted,
  });

  @override
  List<Object> get props => [myNotificationTransmitted];
}
 */