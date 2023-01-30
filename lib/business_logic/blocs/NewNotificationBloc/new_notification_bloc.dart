import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/enums/tab_item_enum.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import '../UserBloc/user_bloc.dart';
import 'bloc.dart';

class NewNotificationBloc extends Bloc<NewNotificationEvent, NewNotificationState> {
  final NotificationRepository notificationRepository = locator<NotificationRepository>();
  final UserRepository userRepository = locator<UserRepository>();

  NewNotificationBloc() : super(const NewNotificationFalseState()) {
    on<NewNotificationReceivedEvent>((event, emit) async {
      if (event.homeScreen.currentTab != TabItem.chat && UserBloc.user!.newNotification == false) {
        UserBloc.user!.newNotification = true;
        await userRepository.updateUser(UserBloc.user!);
        emit(const NewNotificationTrueState());
      }
    });

    on<NotificationSeenEvent>((event, emit) async {
      if (UserBloc.user!.newNotification == true) {
        UserBloc.user!.newNotification = false;
        await userRepository.updateUser(UserBloc.user!);

        /// Update lastNotificationCreatedAt
        UserBloc.user!.lastNotificationCreatedAt = await userRepository.getLastNotificationFromNotifications(UserBloc.user!.userID);
        await userRepository.updateUser(UserBloc.user!);

        emit(const NewNotificationFalseState());
      }
    });

    on<CheckIfThereIsNewNotification>((event, emit) async {
      DateTime? lastNotificationCreatedAtFromNotifications = await userRepository.getLastNotificationFromNotifications(UserBloc.user!.userID);
      DateTime lastNotificationCreatedAtFromUser = UserBloc.user!.lastNotificationCreatedAt!;

      /// Check if there is a new message
      if (lastNotificationCreatedAtFromNotifications != null &&
          lastNotificationCreatedAtFromNotifications.isAfter(lastNotificationCreatedAtFromUser)) {
        add(NewNotificationReceivedEvent(homeScreen: event.homeScreen));
      }
    });
  }
}
