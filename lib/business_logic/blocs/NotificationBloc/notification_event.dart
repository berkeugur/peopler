import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../data/model/notifications.dart';
import '../../cubits/NewNotificationCubit.dart';


@immutable
abstract class NotificationEvent extends Equatable {}

class GetNotificationWithPaginationEvent extends NotificationEvent {
  final NewNotificationCubit newNotificationCubit;

  GetNotificationWithPaginationEvent({
    required this.newNotificationCubit
  });

  @override
  List<Object> get props => [newNotificationCubit];
}

class NewNotificationListenerEvent extends NotificationEvent {
  final List<Notifications> updatedNotification;
  final NewNotificationCubit newNotificationCubit;

  NewNotificationListenerEvent({
    required this.updatedNotification, required this.newNotificationCubit
  });

  @override
  List<Object> get props => [updatedNotification, newNotificationCubit];
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


