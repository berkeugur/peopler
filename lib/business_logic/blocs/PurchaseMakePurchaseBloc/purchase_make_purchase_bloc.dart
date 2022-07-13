import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/data/model/activity.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import '../../../presentation/screens/profile/OthersProfile/profile/profile_screen_components.dart';
import 'bloc.dart';

class PurchaseMakePurchaseBloc extends Bloc<PurchaseMakePurchaseEvent, PurchaseMakePurchaseState> {
  final UserRepository _userRepository = locator<UserRepository>();

  MyUser? PurchaseMakePurchase;
  late final List<String> mutualConnectionUserIDs;
  late final List<MyActivity> myActivities;
  late final SendRequestButtonStatus status;

  PurchaseMakePurchaseBloc() : super(InitialPurchaseMakePurchaseState()) {
    on<MakePurchaseEvent>((event, emit) async {
      try {

        emit(PurchaseMakePurchaseLoadedState(PurchaseMakePurchase!, mutualConnectionUserIDs, myActivities, status));
      } catch (e) {
        emit(PurchaseMakePurchaseNotFoundState());
        debugPrint("other user not found" + e.toString());
      }
    });
  }
}
