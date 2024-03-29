import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/constants/enums/send_req_button_status_enum.dart';
import '../../../data/model/user.dart';
import '../../../presentation/screens/PROFILE/OthersProfile/profile/profile_screen_components.dart';

@immutable
abstract class OtherUserEvent extends Equatable {}

class GetInitialDataEvent extends OtherUserEvent {
  final String userID;
  final SendRequestButtonStatus status;

  GetInitialDataEvent({required this.userID, required this.status});

  @override
  List<Object> get props => [userID, status];
}

class RemoveConnectionEvent extends OtherUserEvent {
  final String otherUserID;

  RemoveConnectionEvent({required this.otherUserID});

  @override
  List<Object> get props => [otherUserID];
}

class TrigStatusEvent extends OtherUserEvent {
  final SendRequestButtonStatus status;

  TrigStatusEvent({required this.status});

  @override
  List<Object> get props => [status];
}

class NewUserListenerEvent extends OtherUserEvent {
  final MyUser myUser;
  NewUserListenerEvent({
    required this.myUser,
  });

  @override
  List<Object> get props => [myUser];
}