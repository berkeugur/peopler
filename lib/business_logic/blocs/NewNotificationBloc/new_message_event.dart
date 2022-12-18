import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../cubits/FloatingActionButtonCubit.dart';

@immutable
abstract class NewNotificationEvent extends Equatable {}

class NewNotificationReceivedEvent extends NewNotificationEvent {
  final FloatingActionButtonCubit homeScreen;

  NewNotificationReceivedEvent({
    required this.homeScreen,
  });

  @override
  List<Object> get props => [homeScreen];
}

class NotificationSeenEvent extends NewNotificationEvent {
  @override
  List<Object> get props => [];
}

class CheckIfThereIsNewNotification extends NewNotificationEvent {
  final FloatingActionButtonCubit homeScreen;

  CheckIfThereIsNewNotification({
    required this.homeScreen,
  });

  @override
  List<Object> get props => [homeScreen];
}
