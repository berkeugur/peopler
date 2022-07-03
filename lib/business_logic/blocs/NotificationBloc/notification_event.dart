import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class NotificationEvent extends Equatable {}

class GetMoreDataEvent extends NotificationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetInitialDataEvent extends NotificationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ClickAcceptEvent extends NotificationEvent {
  final String requestUserID;

  ClickAcceptEvent({
    required this.requestUserID,
  });

  @override
  List<Object> get props => [requestUserID];
}