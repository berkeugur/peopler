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

class ClickAcceptReceivedEvent extends NotificationReceivedEvent {
  final String requestUserID;

  ClickAcceptReceivedEvent({
    required this.requestUserID,
  });

  @override
  List<Object> get props => [requestUserID];
}

class ClickNotAcceptEvent extends NotificationReceivedEvent {
  final String requestUserID;
  final int index;

  ClickNotAcceptEvent({
    required this.requestUserID,
    required this.index
  });

  @override
  List<Object> get props => [requestUserID, index];
}
