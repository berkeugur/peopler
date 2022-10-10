import 'package:flutter_bloc/flutter_bloc.dart';

class NewMessageCubit extends Cubit<bool> {

  NewMessageCubit() : super(false);

  void newMessageEvent() {
    emit(true);
  }

  void messageSeenEvent() {
    emit(false);
  }
}