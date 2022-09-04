import 'package:equatable/equatable.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/user.dart';

import '../../../presentation/screens/PROFILE/OthersProfile/profile/profile_screen_components.dart';

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
  @override
  List<Object> get props => [];
}
