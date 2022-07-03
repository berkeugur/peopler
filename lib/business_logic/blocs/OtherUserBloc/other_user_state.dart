import 'package:equatable/equatable.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/user.dart';

import '../../../presentation/screens/profile/OthersProfile/profile/profile_screen_components.dart';

abstract class OtherUserState extends Equatable {
  const OtherUserState();
}

class InitialOtherUserState extends OtherUserState {
  @override
  List<Object> get props => [];
}

class OtherUserNotFoundState extends OtherUserState {
  @override
  List<Object> get props => [];
}

class OtherUserLoadedState extends OtherUserState {
  final MyUser otherUser;
  final List<String> mutualConnectionUserIDs;
  final List<MyActivity> myActivities;
  final SendRequestButtonStatus status;

  const OtherUserLoadedState(this.otherUser, this.mutualConnectionUserIDs, this.myActivities, this.status);

  @override
  List<Object> get props => [otherUser, mutualConnectionUserIDs, myActivities, status];
}
