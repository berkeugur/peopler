import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class NotificationTransmittedEvent extends Equatable {}

class GetMoreDataEvent extends NotificationTransmittedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetInitialDataEvent extends NotificationTransmittedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
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