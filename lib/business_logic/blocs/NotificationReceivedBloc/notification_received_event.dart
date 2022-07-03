import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class NotificationReceivedEvent extends Equatable {}

class GetMoreDataEvent extends NotificationReceivedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetInitialDataEvent extends NotificationReceivedEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ClickAcceptEvent extends NotificationReceivedEvent {
  final String requestUserID;

  ClickAcceptEvent({
    required this.requestUserID,
  });

  @override
  List<Object> get props => [requestUserID];
}

class ClickNotAcceptEvent extends NotificationReceivedEvent {
  final String requestUserID;

  ClickNotAcceptEvent({
    required this.requestUserID,
  });

  @override
  List<Object> get props => [requestUserID];
}
