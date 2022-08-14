import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../data/model/notifications.dart';


@immutable
abstract class NotificationEvent extends Equatable {}

class GetNotificationWithPaginationEvent extends NotificationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class NewNotificationListenerEvent extends NotificationEvent {
  final List<Notifications> updatedNotification;
  NewNotificationListenerEvent({
    required this.updatedNotification,
  });

  @override
  List<Object> get props => [updatedNotification];
}

class ClickAcceptEvent extends NotificationEvent {
  final String requestUserID;

  ClickAcceptEvent({
    required this.requestUserID,
  });

  @override
  List<Object> get props => [requestUserID];
}

class GeriAlButtonEvent extends NotificationEvent {
  final String requestUserID;
  GeriAlButtonEvent({
    required this.requestUserID,
  });

  @override
  List<Object> get props => [requestUserID];
}

class DeleteNotification extends NotificationEvent {
  final String notificationID;

  DeleteNotification({
    required this.notificationID,
  });

  @override
  List<Object> get props => [notificationID];
}


