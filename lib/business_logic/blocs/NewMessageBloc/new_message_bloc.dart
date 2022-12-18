import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/enums/tab_item_enum.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import '../UserBloc/user_bloc.dart';
import 'bloc.dart';

class NewMessageBloc extends Bloc<NewMessageEvent, NewMessageState> {
  final NotificationRepository notificationRepository = locator<NotificationRepository>();
  final UserRepository userRepository = locator<UserRepository>();

  NewMessageBloc() : super(const NewMessageFalseState()) {
    on<NewMessageReceivedEvent>((event, emit) async {
      if (event.homeScreen.currentTab != TabItem.chat && UserBloc.user!.newMessage == false) {
        UserBloc.user!.newMessage = true;
        await userRepository.updateUser(UserBloc.user!);
        emit(const NewMessageTrueState());
      }
    });

    on<MessageSeenEvent>((event, emit) async {
      if (UserBloc.user!.newMessage == true) {
        UserBloc.user!.newMessage = false;
        await userRepository.updateUser(UserBloc.user!);

        /// Update lastMessageCreatedAt
        UserBloc.user!.lastMessageCreatedAt = await userRepository.getLastMessageCreatedAtFromChats(UserBloc.user!.userID);
        await userRepository.updateUser(UserBloc.user!);

        emit(const NewMessageFalseState());
      }
    });

    on<CheckIfThereIsNewMessage>((event, emit) async {
      DateTime? lastMessageCreatedAtFromChats = await userRepository.getLastMessageCreatedAtFromChats(UserBloc.user!.userID);
      DateTime lastMessageCreatedAtFromUser = UserBloc.user!.lastMessageCreatedAt!;

      /// Check if there is a new message
      if (lastMessageCreatedAtFromChats != null && lastMessageCreatedAtFromChats.isAfter(lastMessageCreatedAtFromUser)) {
        add(NewMessageReceivedEvent(homeScreen: event.homeScreen));
      }
    });
  }
}
