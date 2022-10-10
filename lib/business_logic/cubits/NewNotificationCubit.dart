import 'package:flutter_bloc/flutter_bloc.dart';

class NewNotificationCubit extends Cubit<bool> {

  NewNotificationCubit() : super(false);

  void newNotificationEvent() {
    emit(true);
  }

  void notificationSeenEvent() {
    emit(false);
  }
}