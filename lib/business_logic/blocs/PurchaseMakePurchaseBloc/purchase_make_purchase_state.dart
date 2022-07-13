import 'package:equatable/equatable.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/user.dart';

import '../../../presentation/screens/profile/OthersProfile/profile/profile_screen_components.dart';

abstract class PurchaseMakePurchaseState extends Equatable {
  const PurchaseMakePurchaseState();
}

class InitialPurchaseMakePurchaseState extends PurchaseMakePurchaseState {
  @override
  List<Object> get props => [];
}

class PurchaseMakePurchaseNotFoundState extends PurchaseMakePurchaseState {
  @override
  List<Object> get props => [];
}

class PurchaseMakePurchaseLoadedState extends PurchaseMakePurchaseState {
  final MyUser otherUser;
  final List<String> mutualConnectionUserIDs;
  final List<MyActivity> myActivities;
  final SendRequestButtonStatus status;

  const PurchaseMakePurchaseLoadedState(this.otherUser, this.mutualConnectionUserIDs, this.myActivities, this.status);

  @override
  List<Object> get props => [otherUser, mutualConnectionUserIDs, myActivities, status];
}
