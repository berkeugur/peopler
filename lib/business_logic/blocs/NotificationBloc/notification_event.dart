import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/model/notifications.dart';
import '../NewNotificationBloc/new_notification_bloc.dart';

@immutable
abstract class NotificationEvent extends Equatable {}

class GetInitialNotificationEvent extends NotificationEvent {
  final NewNotificationBloc newNotificationBloc;
  final BuildContext context;

  GetInitialNotificationEvent({required this.newNotificationBloc, required this.context});

  @override
  List<Object> get props => [newNotificationBloc, context];
}

class GetMoreNotificationEvent extends NotificationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class NewNotificationListenerEvent extends NotificationEvent {
  final List<Notifications> updatedNotification;
  final NewNotificationBloc newNotificationBloc;
  final BuildContext context;

  NewNotificationListenerEvent({required this.updatedNotification, required this.newNotificationBloc, required this.context});

  @override
  List<Object> get props => [updatedNotification, newNotificationBloc, context];
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

class TrigNotificationsNotExistEvent extends NotificationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class DeleteNotification extends NotificationEvent {
  final String notificationID;

  DeleteNotification({
    required this.notificationID,
  });

  @override
  List<Object> get props => [notificationID];
}

class ResetNotificationEvent extends NotificationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
