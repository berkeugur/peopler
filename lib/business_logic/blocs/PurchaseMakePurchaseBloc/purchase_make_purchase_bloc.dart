import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/in_app_purchases.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'bloc.dart';

class PurchaseMakePurchaseBloc extends Bloc<PurchaseMakePurchaseEvent, PurchaseMakePurchaseState> {

  PurchaseMakePurchaseBloc() : super(InitialPurchaseMakePurchaseState()) {
    on<MakePurchaseEvent>((event, emit) async {
      try {
        if(event.package == null) {
          emit(PurchaseMakePurchaseNotFoundState());
          return;
        }

        PurchaseApi.purchaserInfo = await Purchases.purchasePackage(event.package!);
        emit(PurchaseMakePurchaseLoadedState());
      } catch (e) {
        emit(PurchaseMakePurchaseNotFoundState());
        debugPrint("other user not found" + e.toString());
      }
    });
  }
}
