import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peopler/data/model/saved_user.dart';
import 'package:peopler/data/model/user.dart';

@immutable
abstract class SavedEvent extends Equatable {}

class GetMoreSavedUsersEvent extends SavedEvent {
  final String myUserID;
  GetMoreSavedUsersEvent({
    required this.myUserID,
  });

  @override
  List<Object> get props => [myUserID];
}

class GetInitialSavedUsersEvent extends SavedEvent {
  final String myUserID;
  GetInitialSavedUsersEvent({
    required this.myUserID,
  });

  @override
  List<Object> get props => [myUserID];
}

class ClickSaveButtonEvent extends SavedEvent {
  final String myUserID;
  final MyUser savedUser;
  ClickSaveButtonEvent({
    required this.myUserID,
    required this.savedUser,
  });

  @override
  List<Object> get props => [myUserID, savedUser];
}

class ClickSendRequestButtonEvent extends SavedEvent {
  final MyUser myUser;
  final SavedUser savedUser;
  ClickSendRequestButtonEvent({
    required this.myUser,
    required this.savedUser,
  });

  @override
  List<Object> get props => [myUser, savedUser];
}

class DeleteSavedUserEvent extends SavedEvent {
  final String savedUserID;
  DeleteSavedUserEvent({
    required this.savedUserID,
  });

  @override
  List<Object> get props => [savedUserID];
}

class TrigUserNotExistSavedStateEvent extends SavedEvent {
  @override
  List<Object> get props => [];
}

class ResetSavedEvent extends SavedEvent {
  @override
  List<Object> get props => [];
}
